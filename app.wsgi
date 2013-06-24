import site
import os, sys
site.addsitedir('/home/davidak/websites/satzgenerator/lib/python2.7/site-packages')

# Change working directory so relative paths (and template lookup) work again
os.chdir(os.path.dirname(__file__))
sys.path.insert(0, '.')

import satzgenerator
application = satzgenerator.default_app()
