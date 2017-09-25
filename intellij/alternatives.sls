{%- from 'intellij/settings.sls' import intellij with context %}

#Note: alternatives state is unsupported by Archlinux & derivatives.

# Add intelliJhome to alternatives system
intellij-home-alt-install:
  alternatives.install:
    - name: intellijhome
    - link: {{ intellij.intellij_home }}
    - path: {{ intellij.real_home }}
    - priority: {{ intellij.alt_priority }}

intellij-home-alt-set:
  alternatives.set:
    - name: intellijhome
    - path: {{ intellij.real_home }}
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
      - alternatives: intellij-home-alt-install
      - alternatives: intellij-home-alt-set

intellij-alt-set:
  alternatives.set:
    - name: intellij
    - path: {{ intellij.realcmd }}
    - onchanges:
      - alternatives: intellij-alt-install

