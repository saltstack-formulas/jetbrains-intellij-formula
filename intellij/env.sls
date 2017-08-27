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

{% if intellij.user != 'undefined_user' %}

  {% if intellij.prefs_url != 'undefined' %}
intellij-get-preferences-importfile-from-url:
  cmd.run:
    - name: curl {{ intellij.dl_opts }} -o /home/{{ intellij.user }}/my-preferences.jar '{{ intellij.prefs_url }}'
    - runas: {{ intellij.user }}
    - if_missing: /home/{{ intellij.user }}/my-preferences.jar
  {% elif intellij.prefs_path != 'undefined' %}
intellij-get-preferences-importfile-from-path:
  file.managed:
    - name: /home/{{ intellij.user }}/my-preferences.jar
    - source: {{ intellij.prefs_path }}
    - user: {{ intellij.user }}
   {% if salt['grains.get']('os_family') == 'Suse' or salt['grains.get']('os') == 'SUSE' %}
    - group: users
   {% else %}
    - group: {{ intellij.user }}
   {% endif %}
    - if_missing: /home/{{ intellij.user }}/my-preferences.jar
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
    - name: {{ intellij.intellij_home }}
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
    - onchanges:
      - alternatives: intellij-home-alt-set

intellij-alt-set:
  alternatives.set:
    - name: intellij
    - path: {{ intellij.realcmd }}
    - onchanges:
      - alternatives: intellij-alt-install

