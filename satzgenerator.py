#!/usr/bin/python3
# -*- coding: utf-8 -*-

from bottle import route, template, static_file, error, request, response, redirect, default_app, run, debug
from peewee import *
from pyzufall import pyzufall as z
from datetime import datetime
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
		uid = Satz.select().where(Satz.satz == satz).get().uid # Wenn Satz bereits in DB, gib UID zurück
		#print('Satz bereits in DB mit UID ' + uid + '!')
		return uid
	except Satz.DoesNotExist: # ansonsten speichern
		uid = neuen_satz_speichern(satz)
		#print('Neuen Satz generiert und mit UID ' + uid + ' in DB gespeichert.') # Neue UID
		return uid

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
		Satz.update(tmp = False).where(Satz.uid == uid).execute()
	except:
		print('Fehler: Die Bewertung konnte nicht in der Datenbank gespeichert werden.')

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

@route('/')
def generator():
	redirect('/' + neuen_satz_generieren())

@route('/<uid:re:[a-z]{5}>', method='GET')
def satz_detailseite(uid):
	satz = Satz.select().where(Satz.uid == uid).get()
	return template('default', satz_uid=satz.uid, satz=satz.satz, positiv=satz.pro, negativ=satz.kontra)

@route('/<uid:re:[a-z]{5}>', method='POST')
def satz_bewerten(uid):
	req = request.forms.text
	if req == "pro":
		satz_positiv_bewerten(uid)
		bewertung_loggen(uid)
		satz = Satz.select().where(Satz.uid == uid).get()
		return str(satz.pro) + ',' + str(satz.kontra)
	elif req == "kontra":
		satz_negativ_bewerten(uid)
		bewertung_loggen(uid)
		satz = Satz.select().where(Satz.uid == uid).get()
		return str(satz.pro) + ',' + str(satz.kontra)
	if req == "permalink":
		satz_permanent_speichern(uid)

@route('/bootstrap/<filepath:path>')
def server_static(filepath):
    return static_file(filepath, root='./bootstrap/')

@error(404)
def error404(error):
    return '<h1>Diese Seite existiert nicht.</h1>'

# allow running from the command line
if __name__ == '__main__':
	run(reloader=True, debug=True, host='10.0.0.11', port=8080)
