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
# and test -f cannot detect corrupt archive
intellij-remove-prev-archive:
  file.absent:
    - name: {{ archive_file }}
    - require:
      - file: intellij-install-dir

intellij-download-archive:
  cmd.run:
    - name: curl {{ intellij.dl_opts }} -o '{{ archive_file }}' '{{ intellij.source_url }}'
    - unless: test -f '{{ intellij.intellij_realcmd }}'
    - require:
      - intellij-remove-prev-archive

intellij-unpacked-dir:
  file.directory:
    - name: {{ intellij.intellij_real_home }}
    - user: root
    - group: root
    - mode: 755
    - makedirs: True
    - force: True
    - require:
      - cmd: intellij-download-archive

intellij-unpack-archive:
  archive.extracted:
    - name: {{ intellij.intellij_real_home }}
    - source: file://{{ archive_file }}
    {%- if intellij.source_hash %}
    - source_hash: {{ intellij.source_hash }}
    {%- endif %}
    - archive_format: {{ intellij.archive_type }}
  {% if grains['saltversioninfo'] < [2016, 11, 0] %}
    - tar_options: {{ intellij.unpack_opts }}
    - if_missing: {{ intellij.intellij_realcmd }}
  {% else %}
    - options: {{ intellij.unpack_opts }}
  {% endif %}
    - enforce_toplevel: False
    - require:
      - cmd: intellij-download-archive

intellij-update-home-symlink:
  file.symlink:
    - name: {{ intellij.intellij_home }}
    - target: {{ intellij.intellij_real_home }}
    - force: True
    - require:
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
    - require:
      - archive: intellij-unpack-archive

intellij-remove-archive:
  file.absent:
    - name: {{ archive_file }}
    - require:
      - archive: intellij-unpack-archive

{%- if intellij.source_hash %}
intellij-remove-archive-hashfile:
  file.absent:
    - name: {{ archive_file }}.sha256
    - require:
      - archive: intellij-unpack-archive
{%- endif %}

{%- endif %}
