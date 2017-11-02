{% from "intellij/map.jinja" import intellij with context %}

{% if grains.os not in ('MacOS', 'Windows') %}

intellij-home-symlink:
  file.symlink:
    - name: '{{ intellij.jetbrains.home }}/intellij'
    - target: '{{ intellij.jetbrains.realhome }}'
    - onlyif: test -d {{ intellij.jetbrains.realhome }}
    - force: True

# Update system profile with PATH
intellij-config:
  file.managed:
    - name: /etc/profile.d/intellij.sh
    - source: salt://intellij/files/intellij.sh
    - template: jinja
    - mode: 644
    - user: root
    - group: root
    - context:
      home: '{{ intellij.jetbrains.home }}/intellij'

  # Debian alternatives
  {% if grains.os_family not in ('Arch') %}

# Add intelliJhome to alternatives system
intellij-home-alt-install:
  alternatives.install:
    - name: intellijhome
    - link: '{{ intellij.jetbrains.home }}/intellij'
    - path: '{{ intellij.jetbrains.realhome }}'
    - priority: {{ intellij.linux.altpriority }}

intellij-home-alt-set:
  alternatives.set:
    - name: intellijhome
    - path: {{ intellij.jetbrains.realhome }}
    - onchanges:
      - alternatives: intellij-home-alt-install

# Add intelli to alternatives system
intellij-alt-install:
  alternatives.install:
    - name: intellij
    - link: {{ intellij.linux.symlink }}
    - path: {{ intellij.jetbrains.realcmd }}
    - priority: {{ intellij.linux.altpriority }}
    - require:
      - alternatives: intellij-home-alt-install
      - alternatives: intellij-home-alt-set

intellij-alt-set:
  alternatives.set:
    - name: intellij
    - path: {{ intellij.jetbrains.realcmd }}
    - onchanges:
      - alternatives: intellij-alt-install

  {% endif %}

{% endif %}
