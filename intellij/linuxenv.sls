{% from "intellij/map.jinja" import intellij with context %}

{% if grains.os not in ('MacOS', 'Windows',) %}

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

  # Linux alternatives
  {% if intellij.linux.altpriority > 0 and grains.os_family not in ('Arch',) %}

# Add intelliJhome to alternatives system
intellij-home-alt-install:
  alternatives.install:
    - name: intellij-home
    - link: '{{ intellij.jetbrains.home }}/intellij'
    - path: '{{ intellij.jetbrains.realhome }}'
    - priority: {{ intellij.linux.altpriority }}

intellij-home-alt-set:
  alternatives.set:
    - name: intellij-home
    - path: {{ intellij.jetbrains.realhome }}
    - onchanges:
      - alternatives: intellij-home-alt-install

# Add to alternatives system
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

  {% if intellij.linux.install_desktop_file %}
intellij-global-desktop-file:
  file.managed:
    - name: {{ intellij.linux.desktop_file }}
    - source: salt://intellij/files/intellij.desktop
    - template: jinja
    - context:
      home: {{ intellij.jetbrains.realhome }}
      command: {{ intellij.command }}
      edition: {{ intellij.jetbrains.edition }}
    - onlyif: test -f {{ intellij.jetbrains.realhome }}/{{ intellij.command }}
  {% endif %}

{% endif %}
