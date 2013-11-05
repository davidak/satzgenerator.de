#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from bottle import route, template, static_file, error, request, response, redirect, default_app, run, debug
from sqlalchemy import create_engine, MetaData
from sqlalchemy import Table, Column, Integer, String, DateTime, Boolean, ForeignKey
from sqlalchemy import select, func
import smtplib
from email.mime.text import MIMEText
from pyzufall.satz import satz
from datetime import datetime, timedelta
import random
import sys

#debug(mode=True)

random.seed() # Zufallsgenerator initialisieren

debug = 1 # 0, 1

# Verbindung zur MySQL-Datenbank herstellen
#engine = create_engine('mysql+mysqlconnector://davidak:9335be4gnjcvd7hbxp5f@localhost/davidak_satzgenerator')#, echo=True) # debug
# test db
engine = create_engine('mysql+mysqlconnector://root:@localhost/satzgenerator_test')#, echo=True) # debug
#engine = create_engine('mysql+mysqlconnector://davidak:9335be4gnjcvd7hbxp5f@localhost/davidak_test_satzgenerator')#, echo=True) # debug

metadata = MetaData()

# Datenbank-Schema
db_satz = Table('satz', metadata,
	Column('uid', String(5), primary_key=True),
	Column('created', DateTime, nullable=False),
	Column('updated', DateTime),
	Column('pro', Integer, default=0),
	Column('kontra', Integer, default=0),
	Column('tmp', Boolean, default=1),
	Column('satz', String(256), nullable=False)
)

db_benutzer = Table('benutzer', metadata,
	Column('id', Integer, primary_key=True),
	Column('uid', String(5), ForeignKey("satz.uid"), nullable=False),
	Column('ip', String(16), nullable=False),
	Column('voted', DateTime, nullable=False)
)

# Tabellen erzeugen, falls sie nicht existieren
metadata.create_all(engine)

def jetzt():
	return datetime.now().strftime('%Y-%m-%d %H:%M:%S')

def neuen_satz_speichern(satz):
	for x in range(10): # 10 Versuche, den Satz zu speichern
		try:
			uid = ''.join(random.choice('abcdefghiklmnopqrstuvwxyz') for x in range(5))
			engine.execute(db_satz.insert(), uid=uid, created=jetzt(), satz=satz)
			return uid
		except:
			if debug: print('Fehler: Satz konnte nicht in die Datenbank gespeichert werden.')
	if debug: print('Der Satz konnte auch beim 10. Versuch nicht in die Datenbank gespeichert werden. Das ist vermutlich ein Datenbank-Problem und es sollte der Administrator informiert werden.')

def neuen_satz_generieren():
	s = satz()
	try:
		satz_row = engine.execute(db_satz.select().where(db_satz.c.satz == s)).fetchone()
		uid = satz_row.uid
		if debug: print('Satz bereits in Datenbank mit uid ' + uid)
		return uid
	except: # ansonsten speichern
		uid = neuen_satz_speichern(s)
		if debug: print('Satz in Datenbank gespeichert mit uid ' + uid)
		return uid

def satz_positiv_bewerten(uid):
	try:
		engine.execute(db_satz.update().where(db_satz.c.uid == uid).values(pro = db_satz.c.pro + 1, tmp = False, updated=jetzt()))
	except:
		if debug: print('Fehler: Die Bewertung konnte nicht in der Datenbank gespeichert werden.')

def satz_negativ_bewerten(uid):
	try:
		engine.execute(db_satz.update().where(db_satz.c.uid == uid).values(kontra = db_satz.c.kontra + 1, tmp = False, updated=jetzt()))
	except:
		if debug: print('Fehler: Die Bewertung konnte nicht in der Datenbank gespeichert werden.')

def satz_permanent_speichern(uid):
	try:
		engine.execute(db_satz.update().where(db_satz.c.uid == uid).values(tmp = False, updated=jetzt()))
	except:
		if debug: print('Fehler: Die Bewertung konnte nicht in der Datenbank gespeichert werden.')

def bewertung_loggen(uid):
	try:
		ip = request.get('REMOTE_ADDR')
		engine.execute(db_benutzer.insert(), uid=uid, ip=ip, voted=jetzt())
	except:
		if debug: print("Fehler: Bewertung konnte nicht geloggt werden.")

def ist_berechtigt(uid):
	try:
		ip = request.get('REMOTE_ADDR')
		log_row = engine.execute(db_benutzer.select().where((db_benutzer.c.uid == uid) & (db_benutzer.c.ip == ip))).fetchone()
		zuletzt_bewertet = log_row.voted
		differenz = datetime.now() - zuletzt_bewertet # vergangene Zeit seit der letzten Bewertung des Satzes
		if differenz.days > 1: # länger als 24 Stunden
			return True
		else:
			return False
	except:
		return True # wenn kein Eintrag in der Datenbank gefunden (oder irgend ein Fehler mit der Datenbankverbindung)

def temporaere_saetze_loeschen():
	try:
		engine.execute(db_satz.delete().where(db_satz.c.tmp == True))
	except:
		if debug: print('Fehler: Die temporären Sätze konnten nicht aus der Datenbank gelöscht werden.')

def log_aufraeumen():
	try:
		gestern = datetime.now() - timedelta(days=1)
		gestern = gestern.strftime('%Y-%m-%d %H:%M:%S')
		engine.execute(db_benutzer.delete().where(db_benutzer.c.voted < gestern))
	except:
		if debug: print("Fehler: Bewertungslog konnten nicht aufgeräumt werden.")

def cron():
	temporaere_saetze_loeschen()
	log_aufraeumen()

def keks_zaehler():
	randb = int(request.get_cookie('randb', '0'))
	visits = int(request.get_cookie('visits', '0'))
	visits += 1

	if randb == 0: # wenn keks nicht gesetzt, setze mit zufallszahl
		randb = random.randint(5,15)
		response.set_cookie('randb', str(randb))

	if visits >= randb:
		response.delete_cookie('visits')
		response.delete_cookie('randb')
		zufaelliger_satz()
	else:
		response.set_cookie('visits', str(visits))

@route('/')
def generator():
	keks_zaehler()
	redirect('/' + neuen_satz_generieren())

@route('/zufaelliger-satz')
def zufaelliger_satz():
	try:
		satz = engine.execute(db_satz.select().where((db_satz.c.tmp == False) & (db_satz.c.pro >= db_satz.c.kontra)).order_by(func.rand()).limit(1)).fetchone()
		uid = satz.uid
	except:
		print("Fehler: Es konnte kein zufälliger Satz aus der Datenbank geladen werden.")
		uid = ''
	redirect('/' + uid)

@route('/<uid:re:[a-z]{5}>', method='GET')
def satz_detailseite(uid):
	try:
		satz = engine.execute(db_satz.select().where(db_satz.c.uid == uid)).fetchone()
		return template('satz', titel='Satzgenerator: ' + satz.satz, satz_uid=satz.uid, satz=satz.satz, positiv=satz.pro, negativ=satz.kontra)
	except:
		response.status = 404
		return template('404', titel="Satzgenerator: Satz nicht gefunden.", text="Es gibt (noch) keinen Satz mit dieser ID.")

@route('/<uid:re:[a-z]{5}>', method='POST')
def satz_bewerten(uid):
	req = request.forms.text
	if req == "pro" and ist_berechtigt(uid):
		satz_positiv_bewerten(uid)
		bewertung_loggen(uid)
		satz = engine.execute(db_satz.select().where(db_satz.c.uid == uid)).fetchone()
		return str(satz.pro) + ',' + str(satz.kontra)
	elif req == "kontra" and ist_berechtigt(uid):
		satz_negativ_bewerten(uid)
		bewertung_loggen(uid)
		satz = engine.execute(db_satz.select().where(db_satz.c.uid == uid)).fetchone()
		return str(satz.pro) + ',' + str(satz.kontra)
	elif req == "permalink":
		satz_permanent_speichern(uid)
	else:
		return 'nein'

@route('/feedback', method='POST')
def feedback():
	try:
		empfaenger = "post@davidak.de"
		nachricht = request.forms.get('text') + "\n\n-----"
	
		if request.forms.get('current'):
			nachricht += "\n\nSatz: " + request.forms.get('satz').encode("utf-8")
	
		nachricht += "\n\nGesendet von IP " + request.get('REMOTE_ADDR')
	
		msg = MIMEText(nachricht)
		msg['Subject'] = "Feedback zum Satzgenerator (" + request.forms.get('art') + ")"
		msg['From'] = request.forms.get('name') + '<' + request.forms.get('email') + '>'
		msg['To'] = empfaenger
	
		s = smtplib.SMTP('localhost')
		s.sendmail('system@satzgenerator.de', empfaenger, msg.as_string())
		s.quit()
	
		return 'erfolgreich'
	except:
		return 'nicht erfolgreich'

@route('/beste-bewertung')
def beste_bewertung():
	anzahl = 50
	satze = engine.execute(db_satz.select().where(db_satz.c.pro >= db_satz.c.kontra).order_by(db_satz.c.pro.desc()).limit(anzahl)).fetchall()
	return template('stats', titel="Die Sätze mit den besten Bewertungen", satze=satze)

@route('/schlechte-bewertung')
def schlechte_bewertung():
	anzahl = 50
	satze = engine.execute(db_satz.select().where(db_satz.c.kontra >= db_satz.c.pro).order_by(db_satz.c.kontra.desc()).limit(anzahl)).fetchall()
	return template('stats', titel="Die Sätze mit den schlechtesten Bewertungen", satze=satze)

@route('/meiste-bewertung')
def meiste_bewertung():
	anzahl = 50
	satze = engine.execute(db_satz.select().order_by(db_satz.c.pro + db_satz.c.kontra.desc()).limit(anzahl)).fetchall()
	return template('stats', titel="Die Sätze mit den meisten Bewertungen", satze=satze)

@route('/neue-saetze')
def neue_saetze():
	anzahl = 50
	satze = engine.execute(db_satz.select().order_by(db_satz.c.created.desc()).limit(anzahl)).fetchall()
	return template('neue', titel="Die neusten Sätze", satze=satze)

@route('/style/<filepath:path>')
def server_static(filepath):
    return static_file(filepath, root='./style/')

@error(404)
def error404(error):
    return template('404', titel="Satzgenerator: Fehler 404 - Seite nicht gefunden.", text="Hier gibt es nichts zu sehen.")

# allow running from the command line
if __name__ == '__main__':
	run(debug=True, host='10.0.0.8', port=8081, reloader=True)
