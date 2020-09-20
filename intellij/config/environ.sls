# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import intellij with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

    {%- if intellij.pkg.use_upstream_macapp %}
        {%- set sls_package_install = tplroot ~ '.macapp.install' %}
    {%- else %}
        {%- set sls_package_install = tplroot ~ '.archive.install' %}
    {%- endif %}
    {%- if grains.os != 'Windows' %}

include:
  - {{ sls_package_install }}

intellij-config-file-file-managed-environ_file:
  file.managed:
    - name: {{ intellij.environ_file }}
    - source: {{ files_switch(['environ.sh.jinja'],
                              lookup='intellij-config-file-file-managed-environ_file'
                 )
              }}
    - mode: 644
    - user: {{ intellij.identity.rootuser }}
    - group: {{ intellij.identity.rootgroup }}
    - makedirs: True
    - template: jinja
    - context:
      environ: {{ intellij.environ|json }}
                      {%- if intellij.pkg.use_upstream_macapp %}
      edition:  {{ '' if not intellij.edition else ' %sE'|format(intellij.edition) }}.app/Contents/MacOS
      appname: {{ intellij.dir.path }}/{{ intellij.pkg.name }}
                      {%- else %}
      edition: ''
      appname: {{ intellij.dir.path }}/bin
                      {%- endif %}
    - require:
      - sls: {{ sls_package_install }}

    {%- endif %}
