{% from "intellij/map.jinja" import intellij with context %}

# Cleanup first
intellij-remove-prev-archive:
  file.absent:
    - name: '{{ intellij.tmpdir }}/{{ intellij.dl.archive_name }}'
    - require_in:
      - intellij-extract-dirs

intellij-extract-dirs:
  file.directory:
    - names:
      - '{{ intellij.tmpdir }}'
      - '{{ intellij.jetbrains.home }}'
{% if grains.os not in ('MacOS', 'Windows',) %}
      - '{{ intellij.jetbrains.realhome }}'
    - user: root
    - group: root
    - mode: 755
{% endif %}
    - makedirs: True
    - clean: True
    - require_in:
      - intellij-download-archive

intellij-download-archive:
  cmd.run:
    - name: curl {{ intellij.dl.opts }} -o '{{ intellij.tmpdir }}/{{ intellij.dl.archive_name }}' {{ intellij.dl.source_url }}
      {% if grains['saltversioninfo'] >= [2017, 7, 0] %}
    - retry:
        attempts: {{ intellij.dl.retries }}
        interval: {{ intellij.dl.interval }}
      {% endif %}

{%- if intellij.dl.src_hashsum %}
   # Check local archive using hashstring for older Salt / MacOS.
   # (see https://github.com/saltstack/salt/pull/41914).
  {%- if grains['saltversioninfo'] <= [2016, 11, 6] or grains.os in ('MacOS',) %}
intellij-check-archive-hash:
   module.run:
     - name: file.check_hash
     - path: '{{ intellij.tmpdir }}/{{ intellij.dl.archive_name }}'
     - file_hash: {{ intellij.dl.src_hashsum }}
     - onchanges:
       - cmd: intellij-download-archive
     - require_in:
       - archive: intellij-package-install
  {%- endif %}
{%- endif %}

intellij-package-install:
{% if grains.os == 'MacOS' %}
  macpackage.installed:
    - name: '{{ intellij.tmpdir }}/{{ intellij.dl.archive_name }}'
    - store: True
    - dmg: True
    - app: True
    - force: True
    - allow_untrusted: True
{% else %}
  # Linux
  archive.extracted:
    - source: 'file://{{ intellij.tmpdir }}/{{ intellij.dl.archive_name }}'
    - name: '{{ intellij.jetbrains.realhome }}'
    - archive_format: {{ intellij.dl.archive_type }}
       {% if grains['saltversioninfo'] < [2016, 11, 0] %}
    - tar_options: {{ intellij.dl.unpack_opts }}
    - if_missing: '{{ intellij.jetbrains.realcmd }}'
       {% else %}
    - options: {{ intellij.dl.unpack_opts }}
       {% endif %}
       {% if grains['saltversioninfo'] >= [2016, 11, 0] %}
    - enforce_toplevel: False
       {% endif %}
       {%- if intellij.dl.src_hashurl and grains['saltversioninfo'] > [2016, 11, 6] %}
    - source_hash: {{ intellij.dl.src_hashurl }}
       {%- endif %}
{% endif %} 
    - onchanges:
      - cmd: intellij-download-archive
    - require_in:
      - intellij-remove-archive

intellij-remove-archive:
  file.absent:
    - name: '{{ intellij.tmpdir }}'
    - onchanges:
{%- if grains.os in ('Windows',) %}
      - pkg: intellij-package-install
{%- elif grains.os in ('MacOS',) %}
      - macpackage: intellij-package-install
{% else %}
      #Unix
      - archive: intellij-package-install

{% endif %}
