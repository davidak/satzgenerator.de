#!/bin/sh
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR
virtualenv-python3.2 -p /usr/bin/python3 .
source bin/activate
pip install -r requirements.txt