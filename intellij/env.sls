{%- from 'intellij/settings.sls' import intellij with context %}

# Update system profile with PATH
intellij-config:
  file.managed:
    - name: /etc/profile.d/intellij.sh
    - source: salt://intellij/intellij.sh
    - template: jinja
    - mode: 644
    - user: root
    - group: root
    - context:
      intellij.home: {{ intellij.intellij_home }}

# Add intelli-jhome to alternatives system
intellij-home-alt-install:
  alternatives.install:
    - name: intellij-home
    - link: {{ intellij.intellij_home }}
    - path: {{ intellij.intellij_real_home }}
    - priority: 30
    - require:
      - intellij-unpack-archive
      - intellij-update-home-symlink

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
    - priority: 30
    - onlyif: test -d {{ intellij.intellij_real_home }} && test -L {{ intellij.intellij_home }}
    - require:
      - intellij-home-alt-install
      - intellij-home-alt-set

intellij-alt-set:
  alternatives.set:
    - name: intellij
    - path: {{ intellij.intellij_realcmd }}
    - require:
      - intellij-home-alt-install
      - intellij-alt-install

# source PATH with JAVA_HOME
intellij-source-file:
  cmd.run:
    - name: source /etc/profile
    - cwd: /root

