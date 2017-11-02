{% from "intellij/map.jinja" import intellij with context %}

{% if grains.os not in ('MacOS', 'Windows') %}

  {% if grains.os_family not in ('Arch') %}

# Add intelliJhome to alternatives system
intellij-home-alt-install:
  alternatives.install:
    - name: intellijhome
    - link: {{ intellij.symhome }}
    - path: {{ intellij.alt.realhome }}
    - priority: {{ intellij.alt.priority }}

intellij-home-alt-set:
  alternatives.set:
    - name: intellijhome
    - path: {{ intellij.alt.realhome }}
    - onchanges:
      - alternatives: intellij-home-alt-install

# Add intelli to alternatives system
intellij-alt-install:
  alternatives.install:
    - name: intellij
    - link: {{ intellij.symlink }}
    - path: {{ intellij.alt.realcmd }}
    - priority: {{ intellij.alt.priority }}
    - require:
      - alternatives: intellij-home-alt-install
      - alternatives: intellij-home-alt-set

intellij-alt-set:
  alternatives.set:
    - name: intellij
    - path: {{ intellij.alt.realcmd }}
    - onchanges:
      - alternatives: intellij-alt-install

  {% endif %}

{% endif %}
