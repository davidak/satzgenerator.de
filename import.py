#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from peewee import *
from datetime import datetime

mysql = MySQLDatabase('davidak_satzgenerator', user='davidak',passwd='9335be4gnjcvd7hbxp5f')
sqlite = SqliteDatabase('database.db')

class SQLite(Model):
	class Meta:
		database = sqlite

class MySQL(Model):
	class Meta:
		database = mysql

class Satz(MySQL):
	uid = CharField(primary_key=True)
	created = DateTimeField()
	updated = DateTimeField(null=True)
	pro = IntegerField(default=0, null=True)
	kontra = IntegerField(default=0, null=True)
	tmp = BooleanField(default=True)
	satz = CharField()

class Benutzer(MySQL):
	satz_uid = CharField()
	ip = CharField()
	voted = DateTimeField()

def erstelle_tabellen():
    mysql.connect()
    Satz.create_table()
    Benutzer.create_table()

class SatzAlt(SQLite):
	id = PrimaryKeyField()
	pro = IntegerField(null=True)
	contra = IntegerField(null=True)
	zeitstempel = DateTimeField()
	satz = TextField()

erstelle_tabellen()

def neuen_satz_speichern(satz, created, pro, kontra):
	for x in range(10): # 10 Versuche, den Satz zu speichern
		try:
			uid = ''.join(random.choice('abcdefghiklmnopqrstuvwxyz') for x in range(5))
			Satz.create( # Neuen Satz in DB speichern
			uid = uid,
			created = created,
			pro = pro,
			kontra = kontra,
			tmp = False,
			satz = satz
			)
		except:
			print('Fehler: Satz konnte nicht in die Datenbank gespeichert werden.')
	print('Der Satz konnte auch beim 10. Versuch nicht in die Datenbank gespeichert werden. Das ist vermutlich ein Datenbank-Problem und es sollte der Administrator informiert werden.')

def saetze_importieren():
	for satz in SatzAlt.select().where(SatzAlt.pro > SatzAlt.contra):
		neuen_satz_speichern(satz.satz, satz.zeitstempel, satz.pro, satz.contra)

saetze_importieren()
