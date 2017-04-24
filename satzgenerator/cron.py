#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# jeden Tag 4 Uhr
import site
site.addsitedir('/home/davidak/websites/satzgenerator/lib/python2.7/site-packages')

from satzgenerator import cron
cron()