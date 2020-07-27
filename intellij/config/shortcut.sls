# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import intellij with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

{%- if intellij.linux.install_desktop_file %}
    {%- if intellij.pkg.use_upstream_macapp %}
        {%- set sls_package_install = tplroot ~ '.macapp.install' %}
    {%- else %}
        {%- set sls_package_install = tplroot ~ '.archive.install' %}
    {%- endif %}

include:
  - {{ sls_package_install }}

intellij-config-file-file-managed-desktop-shortcut_file:
  file.managed:
    - name: {{ intellij.linux.desktop_file }}
    - source: {{ files_switch(['shortcut.desktop.jinja'],
                              lookup='intellij-config-file-file-managed-desktop-shortcut_file'
                 )
              }}
    - mode: 644
    - user: {{ intellij.identity.user }}
    - makedirs: True
    - template: jinja
    - context:
      command: {{ intellij.command|json }}
                        {%- if grains.os == 'MacOS' %}
      edition: {{ '' if 'edition' not in intellij else intellij.edition|json }}
      appname: {{ intellij.dir.path }}/{{ intellij.pkg.name }}
                        {%- else %}
      edition: ''
      appname: {{ intellij.dir.path }}
    - onlyif: test -f "{{ intellij.dir.path }}/{{ intellij.command }}"
                        {%- endif %}
    - require:
      - sls: {{ sls_package_install }}

{%- endif %}
