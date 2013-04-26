#!/usr/bin/python3
# -*- coding: utf-8 -*-

import sqlite3

con = sqlite3.connect("datenbank.db")

cursor = con.cursor()

# Satz-Tabelle erzeugen
sql = "CREATE TABLE satz(id INTEGER PRIMARY KEY, pro INTEGER, contra INTEGER, zeitstempel INTEGER, satz TEXT)"
cursor.execute(sql)

# Benutzer-Tabelle erzeugen
sql = "CREATE TABLE user(id INTEGER PRIMARY KEY, satz_id INTEGER, ip TEXT, zeitstempel INTEGER)"
cursor.execute(sql)

con.close()