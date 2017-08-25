{%- from 'intellij/settings.sls' import intellij with context %}

{#- require a source_url - there may be no default download location for Intellij #}

{%- if intellij.source_url is defined %}

  {%- set archive_file = intellij.prefix ~ '/' ~ intellij.source_url.split('/') | last %}

intellij-install-dir:
  file.directory:
    - name: {{ intellij.prefix }}
    - user: root
    - group: root
    - mode: 755
    - makedirs: True

# curl fails (rc=23) if file exists
# and test -f cannot detect corrupt archive
intellij-remove-prev-archive:
  file.absent:
    - name: {{ archive_file }}
    - require:
      - file: intellij-install-dir

intellij-download-archive:
  cmd.run:
    - name: curl {{ intellij.dl_opts }} -o '{{ archive_file }}' '{{ intellij.source_url }}'
    - unless: test -f '{{ intellij.realcmd }}'
    - require:
      - file: intellij-remove-prev-archive

intellij-unpacked-dir:
  file.directory:
    - name: {{ intellij.real_home }}
    - user: root
    - group: root
    - mode: 755
    - makedirs: True
    - force: True
    - onchanges:
      - cmd: intellij-download-archive

  {% if grains['saltversioninfo'] <= [2016, 11, 6] and intellij.source_hash %}
    # See: https://github.com/saltstack/salt/pull/41914
intellij-check-archive-hash:
  module.run:
    - name: file.check_hash
    - path: {{ archive_file }}
    - file_hash: {{ intellij.source_hash }}
    - onchanges:
      - cmd: intellij-download-archive
    - require_in:
      - archive: intellij-unpack-archive
  {%- endif %}

intellij-unpack-archive:
  archive.extracted:
    - name: {{ intellij.real_home }}
    - source: file://{{ archive_file }}
  {%- if intellij.source_hash and grains['saltversioninfo'] > [2016, 11, 6] %}
    - source_hash: {{ intellij.source_hash }}
  {%- endif %}
  {% if grains['saltversioninfo'] < [2016, 11, 0] %}
    - tar_options: {{ intellij.unpack_opts }}
    - if_missing: {{ intellij.realcmd }}
  {% else %}
    - options: {{ intellij.unpack_opts }}
  {% endif %}
  {% if grains['saltversioninfo'] >= [2016, 11, 0] %}
    - enforce_toplevel: False
  {% endif %}
    - archive_format: {{ intellij.archive_type }}
    - onchanges:
      - cmd: intellij-download-archive

intellij-update-home-symlink:
  file.symlink:
    - name: {{ intellij.intellij_home }}
    - target: {{ intellij.real_home }}
    - force: True
    - onchanges:
      - archive: intellij-unpack-archive

intellij-desktop-entry:
  file.managed:
    - source: salt://intellij/files/intellij.desktop
    - name: /home/{{ pillar['user'] }}/Desktop/intellij.desktop
    - user: {{ pillar['user'] }}
  {% if salt['grains.get']('os_family') == 'Suse' or salt['grains.get']('os') == 'SUSE' %}
    - group: users
  {% else %}
    - group: {{ pillar['user'] }}
  {% endif %}
    - mode: 755
    - force: True
    - onchanges:
      - archive: intellij-unpack-archive

intellij-remove-archive:
  file.absent:
    - names:
      - {{ archive_file }}
      - {{ archive_file }}.sha256
    - onchanges:
      - archive: intellij-unpack-archive

{%- endif %}
