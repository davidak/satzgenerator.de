#!/usr/bin/env python
# -*- coding: utf-8 -*-

from distutils.core import setup

setup(name='Satzgenerator',
      version='3.0',
      description='satzgenerator.de',
      author='davidak',
      author_email='post@davidak.de',
      url='https://satzgenerator.de',
      license='GPLv3',
      packages=['satzgenerator'],
      package_data={'satzgenerator': ['views/*.tpl', 'style/*', 'style/patterns/*']},
      platforms='any',
     )
