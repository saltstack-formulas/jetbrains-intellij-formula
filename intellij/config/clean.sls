# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import intellij with context %}

   {%- if intellij.pkg.use_upstream_macapp %}
       {%- set sls_package_clean = tplroot ~ '.macapp.clean' %}
   {%- else %}
       {%- set sls_package_clean = tplroot ~ '.archive.clean' %}
   {%- endif %}

include:
  - {{ sls_package_clean }}

intellij-config-clean-file-absent:
  file.absent:
    - names:
      - {{ intellij.config_file }}
      - {{ intellij.environ_file }}
      - {{ intellij.linux.desktop_file }}
    - require:
      - sls: {{ sls_package_clean }}
