# Change working directory so relative paths (and template lookup) work again
import os, sys
os.chdir(os.path.dirname(__file__))
sys.path.insert(0, '.')

import satzgenerator
application = satzgenerator.default_app()
