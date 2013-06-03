pip-3.2 install virtualenv
virtualenv-3.2 -p /usr/local/bin/python3 --no-site-packages satzgenerator/
source bin/activate

pip freeze > requirements.txt
pip install -r requirements.txt
