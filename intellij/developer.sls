{% from "intellij/map.jinja" import intellij with context %}

{% if intellij.prefs.user %}
   {% if grains.os not in ('Windows',) %}

intellij-desktop-shortcut-clean:
  file.absent:
    - name: '{{ intellij.homes }}/{{ intellij.prefs.user }}/Desktop/IntelliJ IDEA {{ intellij.jetbrains.edition }}E'
    - require_in:
      - file: intellij-desktop-shortcut-add
    - onlyif: test "`uname`" = "Darwin"

intellij-desktop-shortcut-add:
  file.managed:
    - name: /tmp/mac_shortcut.sh
    - source: salt://intellij/files/mac_shortcut.sh
    - mode: 755
    - template: jinja
    - context:
      user: {{ intellij.prefs.user }}
      homes: {{ intellij.homes }}
      edition: {{ intellij.jetbrains.edition }}
    - onlyif: test "`uname`" = "Darwin"
  cmd.run:
    - name: /tmp/mac_shortcut.sh {{ intellij.jetbrains.edition }}
    - runas: {{ intellij.prefs.user }}
    - require:
      - file: intellij-desktop-shortcut-add
    - require_in:
      - file: intellij-desktop-shortcut-install
    - onlyif: test "`uname`" = "Darwin"

intellij-desktop-shortcut-install:
  file.managed:
    - source: salt://intellij/files/intellij.desktop
    - name: {{ intellij.homes }}/{{ intellij.prefs.user }}/Desktop/intellij{{ intellij.jetbrains.edition }}E.desktop
    - user: {{ intellij.prefs.user }}
       {% if intellij.prefs.group and grains.os not in ('MacOS',) %}
    - group: {{ intellij.prefs.group }}
       {% endif %}
    - makedirs: True
    - mode: 644
    - force: True
    - template: jinja
    - onlyif: test -f {{ intellij.jetbrains.realcmd }}
    - context:
      home: {{ intellij.jetbrains.realhome }}
      command: {{ intellij.command }}
      edition: {{ intellij.jetbrains.edition }}
   {% endif %}

  {% if intellij.prefs.jarurl or intellij.prefs.jardir %}

intellij-prefs-importfile:
  file.managed:
    - onlyif: test -f {{ intellij.prefs.jardir }}/{{ intellij.prefs.jarfile }}
    - name: {{ intellij.homes }}/{{ intellij.prefs.user }}/{{ intellij.prefs.jarfile }}
    - source: {{ intellij.prefs.jardir }}/{{ intellij.prefs.jarfile }}
    - user: {{ intellij.prefs.user }}
    - makedirs: True
       {% if intellij.prefs.group and grains.os not in ('MacOS',) %}
    - group: {{ intellij.prefs.group }}
       {% endif %}
    - if_missing: {{ intellij.homes }}/{{ intellij.prefs.user }}/{{ intellij.prefs.jarfile }}
  cmd.run:
    - unless: test -f {{ intellij.prefs.jardir }}/{{ intellij.prefs.jarfile }}
    - name: curl -o {{intellij.homes}}/{{intellij.prefs.user}}/{{intellij.prefs.jarfile}} {{intellij.prefs.jarurl}}
    - runas: {{ intellij.prefs.user }}
    - if_missing: {{ intellij.homes }}/{{ intellij.prefs.user }}/{{ intellij.prefs.jarfile }}

  {% endif %}

{% endif %}

