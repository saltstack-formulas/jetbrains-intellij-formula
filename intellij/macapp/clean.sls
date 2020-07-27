# -*- coding: utf-8 -*-
# vim: ft=sls

    {%- if grains.os_family == 'MacOS' %}

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import intellij with context %}

intellij-macos-app-clean-files:
  file.absent:
    - names:
      - {{ intellij.dir.tmp }}
                  {%- if grains.os == 'MacOS' %}
      - {{ intellij.dir.path }}/{{ intellij.pkg.name }}*{{ intellij.edition }}*.app
                  {%- else %}
      - {{ intellij.dir.path }}
                  {%- endif %}

    {%- else %}

intellij-macos-app-clean-unavailable:
  test.show_notification:
    - text: |
        The intellij macpackage is only available on MacOS

    {%- endif %}
