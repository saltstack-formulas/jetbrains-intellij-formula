# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import intellij with context %}
{%- from tplroot ~ "/files/macros.jinja" import format_kwargs with context %}

intellij-package-archive-install:
             {%- if grains.os == 'Windows' %}
  chocolatey.installed:
    - force: False
             {%- else %}
  pkg.installed:
             {%- endif %}
    - names: {{ intellij.pkg.deps|json }}
    - require_in:
      - file: intellij-package-archive-install

             {%- if intellij.flavour|lower == 'windows' %}

  file.managed:
    - name: {{ intellij.dir.tmp }}/intellij.exe
    - source: {{ intellij.pkg.archive.source }}
    - makedirs: True
    - source_hash: {{ intellij.pkg.archive.source_hash }}
    - force: True
  cmd.run:
    - name: {{ intellij.dir.tmp }}/intellij.exe
    - require:
      - file: intellij-package-archive-install

             {%- else %}

  file.directory:
    - unless: {{ grains.os == 'MacOS' }}
    - name: {{ intellij.dir.path }}
    - mode: 755
    - makedirs: True
    - clean: True
    - require_in:
      - archive: intellij-package-archive-install
                {%- if grains.os != 'Windows' %}
    - user: {{ intellij.identity.rootuser }}
    - group: {{ intellij.identity.rootgroup }}
    - recurse:
        - user
        - group
                {%- endif %}
  archive.extracted:
    {{- format_kwargs(intellij.pkg.archive) }}
    - retry: {{ intellij.retry_option|json }}
                {%- if grains.os != 'Windows' %}
    - user: {{ intellij.identity.rootuser }}
    - group: {{ intellij.identity.rootgroup }}
    - recurse:
        - user
        - group
                {%- endif %}
    - require:
      - file: intellij-package-archive-install
             {%- endif %}

    {%- if grains.kernel|lower == 'linux' and intellij.linux.altpriority|int == 0 %}

intellij-archive-install-file-symlink-intellij:
  file.symlink:
    - name: /usr/local/bin/intellij
    - target: {{ intellij.dir.path }}/{{ intellij.command }}
    - force: True
    - onlyif: {{ grains.kernel|lower != 'windows' }}
    - require:
      - archive: intellij-package-archive-install

    {%- elif intellij.flavour|lower == 'windowszip' %}

intellij-archive-install-file-shortcut-intellij:
  file.shortcut:
    - name: C:\Users\{{ intellij.identity.rootuser }}\Desktop\{{ intellij.dirname }}.lnk
    - target: {{ intellij.dir.archive }}\{{ intellij.dirname }}\{{ intellij.command }}
    - working_dir: {{ intellij.dir.archive }}\{{ intellij.dirname }}\bin
    - icon_location: {{ intellij.dir.archive }}\{{ intellij.dirname }}\bin\idea.ico
    - makedirs: True
    - force: True
    - user: {{ intellij.identity.rootuser }}
    - require:
      - archive: intellij-package-archive-install

    {%- endif %}
