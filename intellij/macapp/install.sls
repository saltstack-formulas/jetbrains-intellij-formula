# -*- coding: utf-8 -*-
# vim: ft=sls

  {%- if grains.os_family == 'MacOS' %}

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import intellij with context %}

intellij-macos-app-install-curl:
  file.directory:
    - name: {{ intellij.dir.tmp }}
    - makedirs: True
    - clean: True
  pkg.installed:
    - name: curl
  cmd.run:
    - name: curl -Lo {{ intellij.dir.tmp }}/intellij-{{ intellij.version }} "{{ intellij.pkg.macapp.source }}"
    - unless:
      - test -f {{ intellij.dir.tmp }}/intellij-{{ intellij.version }}
      - test -d {{ intellij.dir.path }}/{{ intellij.pkg.name }}{{ '' if not intellij.edition else ' %sE'|format(intellij.edition) }}  # noqa 204
    - require:
      - file: intellij-macos-app-install-curl
      - pkg: intellij-macos-app-install-curl
    - retry: {{ intellij.retry_option|json }}

      # Check the hash sum. If check fails remove
      # the file to trigger fresh download on rerun
intellij-macos-app-install-checksum:
  module.run:
    - onlyif: {{ intellij.pkg.macapp.source_hash not in (None, '')  }}
    - unless:
      - test -d {{ intellij.dir.path }}/{{ intellij.pkg.name }}{{ '' if not intellij.edition else ' %sE'|format(intellij.edition) }}  # noqa 204
    - name: file.check_hash
    - path: {{ intellij.dir.tmp }}/intellij-{{ intellij.version }}
    - file_hash: {{ intellij.pkg.macapp.source_hash }}
    - require:
      - cmd: intellij-macos-app-install-curl
    - require_in:
      - macpackage: intellij-macos-app-install-macpackage
  file.absent:
    - name: {{ intellij.dir.tmp }}/intellij-{{ intellij.version }}
    - onfail:
      - module: intellij-macos-app-install-checksum

intellij-macos-app-install-macpackage:
  macpackage.installed:
    - name: {{ intellij.dir.tmp }}/intellij-{{ intellij.version }}
    - store: True
    - dmg: True
    - app: True
    - force: True
    - allow_untrusted: True
    - onchanges:
      - cmd: intellij-macos-app-install-curl
  file.managed:
    - name: /tmp/mac_shortcut.sh.jinja
    - source: salt://intellij/files/mac_shortcut.sh.jinja
    - mode: 755
    - template: jinja
    - context:
      appname: {{ intellij.dir.path }}/{{ intellij.pkg.name }}
      edition: {{ '' if not intellij.edition else ' %sE'|format(intellij.edition) }}
      user: {{ intellij.identity.user }}
      homes: {{ intellij.dir.homes }}
    - require:
      - macpackage: intellij-macos-app-install-macpackage
    - onchanges:
      - macpackage: intellij-macos-app-install-macpackage
  cmd.run:
    - name: /tmp/mac_shortcut.sh.jinja
    - runas: {{ intellij.identity.user }}
    - require:
      - file: intellij-macos-app-install-macpackage

    {%- else %}

intellij-macos-app-install-unavailable:
  test.show_notification:
    - text: |
        The intellij macpackage is only available on MacOS

    {%- endif %}
