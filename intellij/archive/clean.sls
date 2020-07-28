# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import intellij with context %}

intellij-package-archive-clean-file-absent:
  file.absent:
    - names:
      - {{ intellij.dir.tmp }}
                  {%- if grains.os == 'MacOS' %}
      - {{ intellij.dir.path }}/{{ intellij.pkg.name }}*{{ intellij.edition }}*.app
                  {%- else %}
      - {{ intellij.dir.path }}
                  {%- endif %}
