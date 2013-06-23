#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from sqlalchemy import create_engine, MetaData, Table, Column, Integer, String, Text, DateTime, Boolean, ForeignKey, select, func
from datetime import datetime
import random

# Verbindung zur MySQL-Datenbank herstellen
mysql = create_engine('mysql+mysqlconnector://davidak:9335be4gnjcvd7hbxp5f@localhost/davidak_satzgenerator')#, echo=True) # debug
sqlite = create_engine('sqlite:///datenbank.db')

metamysql = MetaData(mysql)
metasqlite = MetaData(sqlite)

# Datenbank-Schema
db_satz = Table('satz', metamysql,
	Column('uid', String(5), primary_key=True),
	Column('created', DateTime, nullable=False),
	Column('updated', DateTime),
	Column('pro', Integer, default=0),
	Column('kontra', Integer, default=0),
	Column('tmp', Boolean, default=1),
	Column('satz', String(256), nullable=False)
)

db_benutzer = Table('benutzer', metamysql,
	Column('id', Integer, primary_key=True),
	Column('uid', String(5), ForeignKey("satz.uid"), nullable=False),
	Column('ip', String(16), nullable=False),
	Column('voted', DateTime, nullable=False)
)

db_satz_2 = Table('satz', metasqlite,
	Column('id', Integer, primary_key=True),
	Column('pro', Integer, default=0),
	Column('contra', Integer, default=0),
	Column('zeitstempel', Integer, default=0),
	Column('satz', Text, nullable=False)
)

i = 0

for satz in sqlite.execute(db_satz_2.select().where(db_satz_2.c.pro >= db_satz_2.c.contra)).fetchall():
	i+=1
	print(i)
	uid = ''.join(random.choice('abcdefghiklmnopqrstuvwxyz') for x in range(5))
	mysql.execute(db_satz.insert(), uid=uid, created=satz.zeitstempel, pro=satz.pro, kontra=satz.contra, tmp=False, satz=satz.satz)
