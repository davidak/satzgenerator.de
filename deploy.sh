#!/bin/sh
# using Python 2.7
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR
virtualenv -p /usr/bin/python .
source bin/activate
pip install -r requirements.txt
deactivate