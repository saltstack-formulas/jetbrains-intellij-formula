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

{% if intellij.user != 'undefined' %}
  {% if intellij.settings_url != 'undefined' %}
intellij-get-settings-file-from-url:
  cmd.run:
    - name: curl {{ intellij.dl_opts }} -o /home/{{ intellij.home }}/my-intellij-settings.jar '{{ intellij.settings_url }}'
    - if_missing: /home/{{ intellij.home }}/my-intellij-settings.jar
  {% elif intellij.settings_path != 'undefined' %}
intellij-get-settings-file-from-path:
  file.managed:
    - name: /home/{{ intellij.home }}/my-intellij-settings.jar
    - source: {{ intellij.settings_path }}
    - mode: 644
    - user: {{ intellij.user }}
      {% if salt['grains.get']('os_family') == 'Suse' or salt['grains.get']('os') == 'SUSE' %}
    - group: users
      {% else %}
    - group: {{ intellij.user }}
      {% endif %}
  {% endif %}
{% endif %}

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

