# -*- coding: utf-8 -*-
# vim: ft=sls;ts=2;sw=2 et :
#!jinja|yaml

{% from "phpmyadmin/map.jinja" import phpmyadmin with context %}
{% set mysql_root_password = salt['pillar.get']('mysql:server:root_password', salt['grains.get']('server_id')) %}

phpmyadmin_debconf_utils:
  pkg.installed:
    - name: debconf-utils

phpmyadmin_debconf:
  debconf.set:
    - name: phpmyadmin
    - data:
       'phpmyadmin/dbconfig-install': {'type': 'boolean', 'value': '{{ phpmyadmin.dbconfig-install }}'}
       'phpmyadmin/setup-password': {'type': 'password', 'value', '{{ phpmyadmin.setup_password }}'}
       'phpmyadmin/password-confirm': {'type': 'password', 'value', '{{ phpmyadmin.setup_password }}'}
       'phpmyadmin/mysql/admin-pass': {'type': 'password', 'value', ' '}
       'phpmyadmin/mysql/app-pass': {'type': 'password', 'value', ' '}
       'phpmyadmin/reconfigure-webserver': {'type': 'multiselect', 'value': '{{ phpmyadmin.webserver }}' }
    - require_in:
      - pkg: phpmyadmin
    - require:
      - pkg: phpmyadmin_debconf_utils

phpmyadmin:
  pkg.installed:
    - name: phpmyadmin
    - require:
      - debconf: phpmyadmin_debconf



