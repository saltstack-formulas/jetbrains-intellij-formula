# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import intellij with context %}

intellij-package-archive-clean-file-absent:
  file.absent:
    - names:
            {%- if grains.os == 'MacOS' %}
      - {{ intellij.config.path }}/{{ intellij.pkg.name }}*{{ intellij.edition }}
            {%- else %}
      - {{ intellij.config.path }}
            {%- endif %}
      - /usr/local/jetbrains/intellij-*
