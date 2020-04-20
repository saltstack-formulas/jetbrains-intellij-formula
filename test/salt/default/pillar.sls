# -*- coding: utf-8 -*-
# vim: ft=yaml
---
intellij:
  edition: C       # community
  flavour: linuxWithoutJBR
  environ:
    a: b
  identity:
    user: root
  linux:
    altpriority: 10000
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
