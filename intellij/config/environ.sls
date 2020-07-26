# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import intellij as i with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

    {%- if i.pkg.use_upstream_macapp %}
        {%- set sls_package_install = tplroot ~ '.macapp.install' %}
    {%- else %}
        {%- set sls_package_install = tplroot ~ '.archive.install' %}
    {%- endif %}

include:
  - {{ sls_package_install }}

i-config-file-file-managed-environ_file:
  file.managed:
    - name: {{ i.environ_file }}
    - source: {{ files_switch(['environ.sh.jinja'],
                              lookup='i-config-file-file-managed-environ_file'
                 )
              }}
    - mode: 644
    - user: {{ i.identity.rootuser }}
    - group: {{ i.identity.rootgroup }}
    - makedirs: True
    - template: jinja
    - context:
              {%- if i.pkg.use_upstream_macapp %}
        path: '{{ i.dir.path }}/{{ i.pkg.name }}{{ '' if 'edition' not in i else ' %sE'|format(i.edition) }}.app/Contents/MacOS'  # noqa 204
              {%- else %}
        path: {{ i.dir.path }}/bin
              {%- endif %}
        environ: {{ i.environ|json }}
    - require:
      - sls: {{ sls_package_install }}
