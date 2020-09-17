# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import intellij with context %}

    {%- if grains.kernel|lower in ('linux', 'darwin', 'windows') %}

include:
  - {{ '.macapp' if intellij.pkg.use_upstream_macapp else '.archive' }}
  - .config
  - .linuxenv

    {%- else %}

intellij-not-available-to-install:
  test.show_notification:
    - text: |
        The intellij package is unavailable for {{ salt['grains.get']('finger', grains.os_family) }}

    {%- endif %}
