{% from "intellij/map.jinja" import intellij with context %}

{% if intellij.prefs.user not in (None, 'undefined_user') %}

  {% if grains.os == 'MacOS' %}
intellij-desktop-shortcut-clean:
  file.absent:
    - name: '{{ intellij.homes }}/{{ intellij.prefs.user }}/Desktop/IntelliJ IDEA {{ intellij.jetbrains.edition }}E'
    - require_in:
      - file: intellij-desktop-shortcut-add
  {% endif %}

intellij-desktop-shortcut-add:
  {% if grains.os == 'MacOS' %}
  file.managed:
    - name: /tmp/mac_shortcut.sh
    - source: salt://intellij/files/mac_shortcut.sh
    - mode: 755
    - template: jinja
    - context:
      user: {{ intellij.prefs.user }}
      homes: {{ intellij.homes }}
  cmd.run:
    - name: /tmp/mac_shortcut.sh {{ intellij.jetbrains.edition }}
    - runas: {{ intellij.prefs.user }}
    - require:
      - file: intellij-desktop-shortcut-add
   {% else %}
  file.managed:
    - source: salt://intellij/files/intellij.desktop
    - name: {{ intellij.homes }}/{{ intellij.prefs.user }}/Desktop/intellij.desktop
    - user: {{ intellij.prefs.user }}
    - makedirs: True
      {% if salt['grains.get']('os_family') in ('Suse') %} 
    - group: users
      {% else %}
    - group: {{ intellij.prefs.user }}
      {% endif %}
    - mode: 644
    - force: True
    - template: jinja
    - onlyif: test -f {{ intellij.symhome }}/{{ intellij.command }}
    - context:
      home: {{ intellij.symhome }}
      command: {{ intellij.command }}
   {% endif %}


  {% if intellij.prefs.importurl or intellij.prefs.importdir %}

intellij-prefs-importfile:
   {% if intellij.prefs.importdir %}
  file.managed:
    - onlyif: test -f {{ intellij.prefs.importdir }}/{{ intellij.prefs.jarfile }}
    - name: {{ intellij.homes }}/{{ intellij.prefs.user }}/{{ intellij.prefs.jarfile }}
    - source: {{ intellij.prefs.importdir }}/{{ intellij.prefs.jarfile }}
    - user: {{ intellij.prefs.user }}
    - makedirs: True
        {% if salt['grains.get']('os_family') in ('Suse') %}
    - group: users
        {% elif grains.os not in ('MacOS') %}
        #inherit Darwin ownership
    - group: {{ intellij.prefs.user }}
        {% endif %}
    - if_missing: {{ intellij.homes }}/{{ intellij.prefs.user }}/{{ intellij.prefs.jarfile }}
   {% else %}
  cmd.run:
    - name: curl -o {{intellij.homes}}/{{intellij.prefs.user}}/{{intellij.prefs.jarfile}} {{intellij.prefs.importurl}}
    - runas: {{ intellij.prefs.user }}
    - if_missing: {{ intellij.homes }}/{{ intellij.prefs.user }}/{{ intellij.prefs.jarfile }}
   {% endif %}

  {% endif %}

{% endif %}

