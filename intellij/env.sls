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
    - path: {{ intellij.intellij_real_home }}
    - priority: {{ intellij.alt_priority }}

intellij-home-alt-set:
  alternatives.set:
    - name: intellij-home
    - path: {{ intellij.intellij_real_home }}
    - require:
      - intellij-home-alt-install

# Add intelli to alternatives system
intellij-alt-install:
  alternatives.install:
    - name: intellij
    - link: {{ intellij.intellij_symlink }}
    - path: {{ intellij.intellij_realcmd }}
    - priority: {{ intellij.alt_priority }}
    - require:
      - intellij-home-alt-set

intellij-alt-set:
  alternatives.set:
    - name: intellij
    - path: {{ intellij.intellij_realcmd }}
    - require:
      - intellij-alt-install

