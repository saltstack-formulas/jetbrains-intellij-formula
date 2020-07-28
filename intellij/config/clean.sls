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
      - /tmp/dummy_list_item
               {%- if intellij.config_file and intellij.config %}
      - {{ intellij.config_file }}
               {%- endif %}
               {%- if intellij.environ_file %}
      - {{ intellij.environ_file }}
               {%- endif %}
               {%- if grains.kernel|lower == 'linux' %}
      - {{ intellij.shortcut.file }}
               {%- elif grains.os == 'MacOS' %}
      - {{ intellij.dir.homes }}/{{ intellij.identity.user }}/Desktop/{{ intellij.pkg.name }}*{{ intellij.edition }}*
               {%- endif %}
    - require:
      - sls: {{ sls_package_clean }}
