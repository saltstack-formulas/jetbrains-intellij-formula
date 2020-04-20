# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import intellij with context %}

intellij-package-archive-clean-file-absent:
  file.absent:
    - names:
      - {{ intellij.pkg.archive.name }}
      - /usr/local/jetbrains/intellij-{{ intellij.edition }}-*
