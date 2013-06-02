#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from bottle import route, template, static_file, error, request, response, redirect, default_app, run, debug
from peewee import *
from pyzufall import pyzufall as z
from datetime import datetime, timedelta
import random
import sys

debug(mode=True)

random.seed() # Zufallsgenerator initialisieren

def jetzt():
	return datetime.now().strftime('%Y-%m-%d %H:%M:%S')

#db = MySQLDatabase('davidak_satzgenerator', user='davidak',passwd='9335be4gnjcvd7hbxp5f')
db = SqliteDatabase('dev.db')

class DBModel(Model):
	class Meta:
		database = db

class Satz(DBModel):
	uid = CharField(primary_key=True)
	created = DateTimeField()
	updated = DateTimeField(null=True)
	pro = IntegerField(default=0, null=True)
	kontra = IntegerField(default=0, null=True)
	tmp = BooleanField(default=True)
	satz = CharField()

class Benutzer(DBModel):
	satz_uid = CharField()
	ip = CharField()
	voted = DateTimeField()

def erstelle_tabellen():
    db.connect()
    Satz.create_table()
    Benutzer.create_table()

#erstelle_tabellen()

def neuen_satz_speichern(satz):
	for x in range(10): # 10 Versuche, den Satz zu speichern
		try:
			uid = ''.join(random.choice('abcdefghiklmnopqrstuvwxyz') for x in range(5))
			Satz.create( # Neuen Satz in DB speichern
			uid = uid,
			created = jetzt(),
			satz = satz
			)
			return uid
		except:
			print('Fehler: Satz konnte nicht in die Datenbank gespeichert werden.')
	print('Der Satz konnte auch beim 10. Versuch nicht in die Datenbank gespeichert werden. Das ist vermutlich ein Datenbank-Problem und es sollte der Administrator informiert werden.')

def neuen_satz_generieren():
	satz = z.satz()
	try:
		uid = Satz.get(Satz.satz == satz).uid # Wenn Satz bereits in DB, gib UID zurück
		return uid
	except Satz.DoesNotExist: # ansonsten speichern
		uid = neuen_satz_speichern(satz)
		return uid
	except: # andere Fehler
		print("Fehler beim speichern des Satzes.")

def satz_positiv_bewerten(uid):
	try:
		Satz.update(updated = jetzt(), pro = Satz.pro + 1, tmp = False).where(Satz.uid == uid).execute()
	except:
		print('Fehler: Die Bewertung konnte nicht in der Datenbank gespeichert werden.')

def satz_negativ_bewerten(uid):
	try:
		Satz.update(updated = jetzt(), kontra = Satz.kontra + 1, tmp = False).where(Satz.uid == uid).execute()
	except:
		print('Fehler: Die Bewertung konnte nicht in der Datenbank gespeichert werden.')

def satz_permanent_speichern(uid):
	try:
		Satz.update(updated = jetzt(), tmp = False).where(Satz.uid == uid).execute()
	except:
		print('Fehler: Die Bewertung konnte nicht in der Datenbank gespeichert werden.')

def ist_berechtigt(uid):
	try:
		ip = request.get('REMOTE_ADDR')
		zuletzt_bewertet = Benutzer.get((Benutzer.satz_uid == uid) & (Benutzer.ip == ip)).voted
		differenz = datetime.now() - zuletzt_bewertet # vergangene Zeit seit der letzten Bewertung des Satzes
		if differenz.days > 1: # länger als 24 Stunden
			return True
		else:
			return False
	except:
		return True # wenn kein Eintrag in der Datenbank gefunden (oder irgend ein Fehler mit der Datenbankverbindung)

def temporaere_saetze_loeschen():
	try:
		Satz.delete().where(Satz.tmp == True).execute()
	except:
		print('Fehler: Die temporären Sätze konnten nicht aus der Datenbank gelöscht werden.')

def bewertung_loggen(uid):
	try:
		Benutzer.create( # Benutzer hat Satz bewertet
		satz_uid = uid,
		ip = request.get('REMOTE_ADDR'),
		voted = jetzt()
		)
	except:
		print("Fehler: Bewerung konnte nicht geloggt werden.")

def log_aufraeumen():
	try:
		gestern = datetime.now() - timedelta(days=1)
		gestern = gestern.strftime('%Y-%m-%d %H:%M:%S')
		Benutzer.delete().where(Benutzer.voted < gestern).execute()
	except:
		print("Fehler: Bewertungslog konnten nicht aufgeräumt werden.")

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
		uid = Satz.select().where((Satz.tmp == False) & (Satz.pro >= Satz.kontra)).order_by(fn.Random()).limit(1).get().uid
	except:
		print("Fehler: Es konnte kein zufälliger Satz aus der Datenbank geladen werden.")
		uid = ''
	redirect('/' + uid)

@route('/<uid:re:[a-z]{5}>', method='GET')
def satz_detailseite(uid):
	try:
		satz = Satz.get(Satz.uid == uid)
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
		satz = Satz.get(Satz.uid == uid)
		return str(satz.pro) + ',' + str(satz.kontra)
	elif req == "kontra" and ist_berechtigt(uid):
		satz_negativ_bewerten(uid)
		bewertung_loggen(uid)
		satz = Satz.get(Satz.uid == uid)
		return str(satz.pro) + ',' + str(satz.kontra)
	elif req == "permalink":
		satz_permanent_speichern(uid)
	else:
		return 'nein'

@route('/beste-bewertung')
def beste_bewertung():
	anzahl = 50
	satze = Satz.raw('SELECT * FROM satz WHERE pro >= kontra ORDER BY pro DESC, kontra LIMIT ' + str(anzahl))
	return template('stats', titel="Die Sätze mit den besten Bewertungen", satze=satze)

@route('/schlechte-bewertung')
def schlechte_bewertung():
	anzahl = 50
	satze = Satz.raw('SELECT * FROM satz WHERE kontra >= pro ORDER BY kontra DESC, pro LIMIT ' + str(anzahl))
	return template('stats', titel="Die Sätze mit den schlechtesten Bewertungen", satze=satze)

@route('/meiste-bewertung')
def meiste_bewertung():
	anzahl = 50
	satze = Satz.raw('SELECT * FROM satz ORDER BY pro+kontra DESC LIMIT ' + str(anzahl))
	return template('stats', titel="Die Sätze mit den meisten Bewertungen", satze=satze)

@route('/neue-saetze')
def neue_saetze():
	anzahl = 50
	satze = Satz.raw('SELECT * FROM satz ORDER BY created DESC LIMIT ' + str(anzahl))
	return template('neue', titel="Die neusten Sätze", satze=satze)

@route('/bootstrap/<filepath:path>')
def server_static(filepath):
    return static_file(filepath, root='./bootstrap/')

@route('/style/<filepath:path>')
def server_static(filepath):
    return static_file(filepath, root='./style/')

@error(404)
def error404(error):
    return template('404', titel="Satzgenerator: Seite nicht gefunden.", text="Hier gibt es nichts zu sehen.")

# allow running from the command line
if __name__ == '__main__':
	run(reloader=True, debug=True, host='10.0.0.11', port=8080)
