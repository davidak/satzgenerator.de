#!/usr/bin/python3
# -*- coding: utf-8 -*-

from bottle import route, run, template, static_file, error, request, response, redirect, default_app
import sqlite3
from pyzufall import pyzufall as z
import random
import time

#DEBUG=True

random.seed() # Zufallsgenerator initialisieren

def counter():
	randb = int( request.cookies.get('randb', str(random.randint(7,15))) )
	visits = int( request.cookies.get('visits', '0') )
	visits += 1
	if visits >= randb:
		# Anzahl Datensätze
		#sql = "SELECT COUNT(*) FROM satz"
		
		con = sqlite3.connect('datenbank.db')
		sql = "SELECT id FROM satz WHERE pro >= contra"
		c = con.cursor()
		c.execute(sql)
		pro_satz_ids = c.fetchall()
		
		randb_satz = random.choice(pro_satz_ids)[0] #ID von zufälligem, gutem Satz aus DB
		
		c.close()
		con.close()
		
		response.delete_cookie('visits')
		response.delete_cookie('randb')
	else:
		randb_satz = ''
		response.set_cookie('visits', str(visits))
	return randb_satz

@route('/')
def index():
	satz = z.satz()
	randb_satz = counter()
	return template('default', satz=satz, randb_satz=randb_satz)

@route('/', method='POST')
def vote():
	if request.POST.get('pro','').strip():
		voted = 'pro'
	if request.POST.get('contra','').strip():
		voted = 'contra'
	if request.POST.get('permalink','').strip():
		voted = 'permalink'
	ip = request.get('REMOTE_ADDR')
	
	satz = request.POST.get('satz')
	try:
		satz = satz.encode('raw_unicode_escape').decode('utf-8')
	except:
		print("Fehler beim utf-8 encodieren von: " + satz)
	
	# Suche nach bereits vorhandenem Satz
	con = sqlite3.connect('datenbank.db')
	c = con.cursor()
	sql = "SELECT id FROM satz WHERE satz LIKE '" + satz +"'"
	c.execute(sql)
	id_in_db = None
	for dsatz in c: # ersten treffen auswählen
		id_in_db = dsatz[0]
		break
	c.close()
	con.close()
	
	if id_in_db and voted == 'permalink': # wenn Satz bereits in DB gibe Permalink
		redirect("http://satzgenerator.net/" + str(id_in_db) + "?permalink=true")
	elif id_in_db: # wenn Satz bereits in DB, bewerten
		con = sqlite3.connect('datenbank.db')
		c = con.cursor()
		
		# alte user daten löschen
		sql = "DELETE FROM user WHERE zeitstempel < " + str(int(time.time()) - 60*60*24)
		c.execute(sql)
		con.commit()
				
		# Zeit suchen, wann den Satz zu letzt abgestimmt
		sql = "SELECT zeitstempel FROM user WHERE satz_id = '" + str(id_in_db) + "' AND ip = '" + ip + "'"
		c.execute(sql)
		dsatz = c.fetchall()
		try:
			damals = dsatz[0][0]
		except:
			damals = 0
		
		differenz = int(time.time()) - damals
		
		if differenz < 60*60*24:
			redirect("http://satzgenerator.net/" + str(id_in_db) + "?error=" + str(differenz))
		
		sql = "UPDATE satz SET " + voted + "=" + voted + " + 1 WHERE id = '" + str(id_in_db) + "'"
		c.execute(sql)
		con.commit()
		new_id = id_in_db
		
		# Bewertung speichern
		zeitstempel = int(time.time())
		sql = "INSERT INTO user (satz_id, ip, zeitstempel) VALUES(" + str(new_id) + ", '" + ip + "', " + str(zeitstempel) + ")"
		c.execute(sql)
		con.commit()
		
		c.close()
		con.close()
		redirect("http://satzgenerator.net/" + str(new_id))
	elif voted == 'permalink': # Satz für Permalink in DB speichern
		zeitstempel = time.strftime("%Y-%m-%d %H:%M:%S")
		con = sqlite3.connect('datenbank.db')
		sql = "INSERT INTO satz (pro, contra, zeitstempel, satz) VALUES(0, 0, '"+ zeitstempel + "', '" + satz + "')"
		c = con.cursor()
		c.execute(sql)
		new_id = c.lastrowid
		con.commit()
		c.close()
		con.close()
		redirect("http://satzgenerator.net/" + str(new_id) + "?permalink=true")
	else: # Satz in DB speichern mit Bewertung
		if voted == 'pro':
			procon = '1, 0'
		else:
			procon = '0, 1'
		
		zeitstempel = time.strftime("%Y-%m-%d %H:%M:%S")
		con = sqlite3.connect('datenbank.db')
		sql = "INSERT INTO satz (pro, contra, zeitstempel, satz) VALUES(" + procon +", '"+ zeitstempel + "', '" + satz + "')"
		c = con.cursor()
		c.execute(sql)
		new_id = c.lastrowid
		con.commit()
		
		# Bewertung speichern
		zeitstempel = int(time.time())
		sql = "INSERT INTO user (satz_id, ip, zeitstempel) VALUES(" + str(new_id) + ", '" + ip + "', " + str(zeitstempel) + ")"
		c.execute(sql)
		con.commit()
		
		c.close()
		con.close()
		redirect("http://satzgenerator.net/" + str(new_id))

@route('/<sid:int>')
def satz_db(sid):
	# Permalink direkt anzeigen
	permalink = False
	permalink = request.query.permalink # ?permalink=true
	
	if permalink:
		permalink = "<script>document.onload=show_permalink()</script>"
	
	# Fehlermeldung anzeigen
	fehler = False
	fehler = request.query.error # ?error=zeit_differenz
	
	if fehler:
		fehler = "<script>document.onload=show_warning()</script>"
	
	con = sqlite3.connect('datenbank.db')
	sql = "SELECT * FROM satz WHERE id =  '" + str(sid) +"'"
	c = con.cursor()
	c.execute(sql)
	
	for dsatz in c:
		pos, neg, satz = dsatz[1], dsatz[2], dsatz[4]
	c.close()
	con.close()
	return template('default', satz=satz, pos=pos, neg=neg, satz_id=sid, permalink=permalink, fehler=fehler)

@route('/beste-bewertung')
def beste():
	con = sqlite3.connect('datenbank.db')
	sql = "SELECT * FROM satz WHERE pro >= contra ORDER BY pro DESC, contra LIMIT 25"
	c = con.cursor()
	c.execute(sql)
	satze = c.fetchall()
	c.close()
	con.close()
	return template('stats', titel="Die Sätze mit den besten Bewertungen", satze=satze)


@route('/schlechteste-bewertung')
def schlechte():
	con = sqlite3.connect('datenbank.db')
	sql = "SELECT * FROM satz WHERE contra >= pro ORDER BY contra DESC, pro LIMIT 25"
	c = con.cursor()
	c.execute(sql)
	satze = c.fetchall()
	c.close()
	con.close()
	return template('stats', titel="Die Sätze mit den schlechtesten Bewertungen", satze=satze)

@route('/meiste-bewertungen')
def meiste():
	con = sqlite3.connect('datenbank.db')
	sql = "SELECT * FROM satz ORDER BY pro+contra DESC LIMIT 25"
	c = con.cursor()
	c.execute(sql)
	satze = c.fetchall()
	c.close()
	con.close()
	return template('stats', titel="Die Sätze mit den meisten Bewertungen", satze=satze)

@route('/neuste-saetze')
def meiste():
	con = sqlite3.connect('datenbank.db')
	sql = "SELECT * FROM satz ORDER BY zeitstempel DESC LIMIT 25"
	c = con.cursor()
	c.execute(sql)
	satze = c.fetchall()
	c.close()
	con.close()
	return template('stats', titel="Die neusten Sätze", satze=satze)

@route('/assets/<filepath:path>')
def server_static(filepath):
    return static_file(filepath, root='./assets/')

@error(404)
def error404(error):
    return '<h1>Diese Seite existiert nicht.</h1>'

#run(reloader=True, host='10.0.0.11', port=8080)