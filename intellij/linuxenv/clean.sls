# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import intellij with context %}
{%- from tplroot ~ "/files/macros.jinja" import format_kwargs with context %}

    {% if grains.kernel|lower == 'linux' %}

intellij-linuxenv-home-file-absent:
  file.absent:
    - names:
      - /opt/intellij
      - {{ intellij.pkg.archive.name }}

        {% if intellij.linux.altpriority|int > 0 and grains.os_family not in ('Arch',) %}

intellij-linuxenv-home-alternatives-clean:
  alternatives.remove:
    - name: intellijhome
    - path: {{ intellij.pkg.archive.name }}

intellij-linuxenv-executable-alternatives-set:
  alternatives.remove:
    - name: intellij
    - path: {{ intellij.pkg.archive.name }}/intellij

        {%- else %}

intellij-linuxenv-alternatives-clean-unapplicable:
  test.show_notification:
    - text: |
        Linux alternatives are turned off (intellij.linux.altpriority=0),
        or not applicable on {{ grains.os or grains.os_family }} OS.
        {% endif %}
    {% endif %}
