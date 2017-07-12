{%- from 'intellij/settings.sls' import intellij with context %}

{#- require a source_url - there may be no default download location for Intellij #}

{%- if intellij.source_url is defined %}

  {%- set archive_file = intellij.prefix + '/' + intellij.source_url.split('/') | last %}

intellij-install-dir:
  file.directory:
    - name: {{ intellij.prefix }}
    - user: root
    - group: root
    - mode: 755
    - makedirs: True

# curl fails (rc=23) if file exists
{{ archive_file }}:
  file.absent:
    - require_in:
      - intellij-download-archive

intellij-download-archive:
  cmd.run:
    - name: curl {{ intellij.dl_opts }} -o '{{ archive_file }}' '{{ intellij.source_url }}'
    - unless: test -f '{{ archive_file }}'
    - unless: test -d '{{ intellij.intellij_realcmd }}'
    - require:
      - intellij-install-dir

intellij-unpacked-dir:
  file.directory:
    - name: {{ intellij.intellij_real_home }}
    - user: root
    - group: root
    - mode: 755
    - makedirs: True
    - ifexists: {{ archive_file }}
    - require:
      - intellij-download-archive

intellij-unpack-archive:
  archive.extracted:
    - name: {{ intellij.intellij_real_home }}
    - source: file://{{ archive_file }}
    {%- if intellij.source_hash %}
    - source_hash: {{ intellij.source_hash }}
    {%- endif %}
    - archive_format: {{ intellij.archive_type }}
    - options: {{ intellij.unpack_opts }}
    - enforce_toplevel: False
    - clean: True
    - user: root
    - group: root
    - require:
      - intellij-download-archive
      - intellij-unpacked-dir

intellij-update-home-symlink:
  file.symlink:
    - name: {{ intellij.intellij_home }}
    - target: {{ intellij.intellij_real_home }}
    - force: True
    - require:
      - intellij-unpack-archive
      - intellij-desktop-entry

#### Example requiring 'user' definition in pillar ##
intellij-desktop-entry:
  file.managed:
    - source: salt://intellij/files/intellij.desktop
    - name: /home/{{ pillar['user'] }}/Desktop/intellij.desktop
    - user: {{ pillar['user'] }}
    - group: {{ pillar['user'] }}
    - mode: 755

intellij-remove-archive:
  file.absent:
    - name: {{ archive_file }}
    - require:
      - intellij-update-home-symlink

{%- if intellij.source_hash %}
intellij-remove-archive-hashfile:
  file.absent:
    - name: {{ archive_file }}.sha256
    - require:
      - intellij-update-home-symlink
{%- endif %}

include:
- .env

{%- endif %}
