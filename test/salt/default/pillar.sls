# -*- coding: utf-8 -*-
# vim: ft=yaml
---
intellij:
  edition: C       # community
  environ:
    a: b
  pkg:
    use_upstream_archive: true
    use_upstream_macapp: false
    deps:
      - curl
      - tar
      - gzip
        {%- if grains.os_family == 'Debian' %}
      - default-jre
        {%- elif grains.os_family == 'RedHat' %}
      - java-11-openjdk-devel
      - java-11-openjdk
        {%- elif grains.os_family == 'Suse' %}
      - java-1_8_0-openjdk-devel
        {%- elif grains.os_family == 'Arch' %}
      - jre-openjdk
        {%- endif %}
  identity:
    user: root
  linux:
    altpriority: 1000
