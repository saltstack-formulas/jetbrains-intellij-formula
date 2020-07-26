# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import intellij with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

{%- if 'config' in intellij and intellij.config and intellij.config_file %}
    {%- if intellij.pkg.use_upstream_macapp %}
        {%- set sls_package_install = tplroot ~ '.macapp.install' %}
    {%- else %}
        {%- set sls_package_install = tplroot ~ '.archive.install' %}
    {%- endif %}

include:
  - {{ sls_package_install }}

intellij-config-file-managed-config_file:
  file.managed:
    - name: {{ intellij.config_file }}
    - source: {{ files_switch(['file.default.jinja'],
                              lookup='intellij-config-file-file-managed-config_file'
                 )
              }}
    - mode: 640
    - user: {{ intellij.identity.rootuser }}
    - group: {{ intellij.identity.rootgroup }}
    - makedirs: True
    - template: jinja
    - context:
      path: {{ intellij.config.path }}
      config: {{ intellij.config|json }}
    - require:
      - sls: {{ sls_package_install }}

{%- endif %}
