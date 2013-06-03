pip-3.2 install virtualenv

virtualenv-3.2 -p /usr/bin/python3 --no-site-packages .
source bin/activate

easy_install -U distribute


pip install MySQL-python

ImportError: No module named ConfigParser

vim build/MySQL-python/setup_posix.py
rename to "configparser"

pip install MySQL-python


pip install -r requirements.txt
