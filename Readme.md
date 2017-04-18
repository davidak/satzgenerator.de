satzgenerator.de
================

Der Quelltext von https://satzgenerator.de/.

Es ist in [Python](https://www.python.org/) programmiert, benutzt das [Bottle](http://bottlepy.org/docs/stable/) Webframework, den [Gunicorn](http://docs.gunicorn.org/en/stable/index.html) WSGI HTTP-Server, den Datenbank ORM [SQLAlchemy](https://www.sqlalchemy.org/) mit [PyMySQL](https://pymysql.readthedocs.io/en/latest/) MySQL-Client sowie [PyZufall](http://pyzufall.readthedocs.org/de/latest/) zum generieren der zufälligen Sätze. Das Frontend ist mit [Bootstrap](http://getbootstrap.com/) und [jQuery](http://jquery.com/) gebaut.

Generell wird auch [SQLite](https://www.sqlite.org/) unterstützt, z.B. für Testzwecke. Aktuell funktioniert es nicht. https://github.com/davidak/satzgenerator.de/issues/2

Deployment
----------

```
pip install -r requirements.txt
cp config.ini.dist config.ini
vim config.ini
gunicorn -w 2 --bind='0.0.0.0:8081' satzgenerator:app
```

Entwicklung
-----------

Eine Entwicklungsumgebung, die alle Abhängigkeiten enthält, kann mit [Nix](http://nixos.org/nix/) erstellt werden.

Es kann der integrierte Webserver gestartet werden, um lokal zu entwickeln.

```
$ nix-shell requirements.nix -A interpreter
$ python satzgenerator.py
Bottle v0.12.13 server starting up (using WSGIRefServer())...
Listening on http://127.0.0.1:8081/
Hit Ctrl-C to quit.
```

Bei Änderungen am Code wird er automatisch neu gestartet.

Getestet wurde es mit Python 3.5.

Die Entwicklungsumgebung wurde mit [pypi2nix](https://github.com/garbas/pypi2nix) erstellt.

```
pypi2nix -v -V "3.5" -r requirements.txt
```
