satzgenerator.de
================

Der Quelltext von https://satzgenerator.de/

Derzeit wird es über mod_wsgi mit Python 2.7 betrieben.

Datenbank ist MySQL. SQLite funktioniert momentan nicht.

Installation
------------

::

	./deploy.sh
	cp config.ini.dist config.ini
	vim config.ini

Entwicklung
-----------

Es kann der integrierte Webserver gestartet werden, um lokal zu entwickeln.

::

	$ python satzgenerator.py
	Bottle v0.12.9 server starting up (using WSGIRefServer())...
	Listening on http://127.0.0.1:8081/
	Hit Ctrl-C to quit.

Bei Änderungen am Code wird er automatisch neu gestartet.

Getestet wurde es mit Python 2.7.
