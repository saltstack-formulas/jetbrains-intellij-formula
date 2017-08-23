{%- from 'intellij/settings.sls' import intellij with context %}

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
      intellij_home: {{ intellij.intellij_home }}

# Add intelliJhome to alternatives system
intellij-home-alt-install:
  alternatives.install:
    - name: intellij-home
    - link: {{ intellij.intellij_home }}
    - path: {{ intellij.real_home }}
    - priority: {{ intellij.alt_priority }}

intellij-home-alt-set:
  alternatives.set:
    - name: intellij-home
    - path: {{ intellij.real_home }}
    - require:
      - alternatives: intellij-home-alt-install
    - onchanges:
      - alternatives: intellij-home-alt-install

# Add intelli to alternatives system
intellij-alt-install:
  alternatives.install:
    - name: intellij
    - link: {{ intellij.symlink }}
    - path: {{ intellij.realcmd }}
    - priority: {{ intellij.alt_priority }}
    - require:
      - alternatives: intellij-home-alt-set
    - onchanges:
      - alternatives: intellij-home-alt-set

intellij-alt-set:
  alternatives.set:
    - name: intellij
    - path: {{ intellij.realcmd }}
    - require:
      - alternatives: intellij-alt-install
    - onchanges:
      - alternatives: intellij-alt-install

