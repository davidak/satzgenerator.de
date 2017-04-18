satzgenerator.de
================

Der Quelltext von https://satzgenerator.de/

Derzeit wird es über mod_wsgi mit Python 2.7 betrieben.

Datenbank ist MySQL. SQLite funktioniert momentan nicht.

Installation
------------

::

	pip install -r requirements.txt
	cp config.ini.dist config.ini
	vim config.ini
	gunicorn -w 2 --bind='0.0.0.0:8081' satzgenerator:app

Entwicklung
-----------

Eine Entwicklungsumgebung, die alle Abhängigkeiten enthält, kann mit [Nix](http://nixos.org/nix/) erstellt werden.

Es kann der integrierte Webserver gestartet werden, um lokal zu entwickeln.

::
	$ nix-shell requirements.nix -A interpreter
	$ python satzgenerator.py
	Bottle v0.12.13 server starting up (using WSGIRefServer())...
	Listening on http://127.0.0.1:8081/
	Hit Ctrl-C to quit.

Bei Änderungen am Code wird er automatisch neu gestartet.

Getestet wurde es mit Python 3.5.

Die Entwicklungsumgebung wurde mit [pypi2nix](https://github.com/garbas/pypi2nix) erstellt.

	pypi2nix -v -V "3.5" -r requirements.txt
