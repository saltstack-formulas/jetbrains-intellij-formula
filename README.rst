========
intellij
========

Formula to set up and configure Jetbrains IntelliJ IDEA from a tarball archive sourced via URL.

.. note::

    See the full `Salt Formulas installation and usage instructions
    <http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_.
    
Available states
================

.. contents::
    :local:

``intellij``
------------

Downloads the tarball from the intellij:source_url configured as either a pillar or grain and will not do anything
if source_url is omitted. Then unpacks the archive into intellij:prefix (defaults to /usr/share/java/intellij).

.. note::

Jetbrains do rolling releases of intellij community edition so 'intellij' pillars need to be updated regularly, unless you maintain your own mirror.


``intellij.env``
------------
Places a intellij profile in /etc/profile.d - this way the PATH is set correctly for all system users.
Optionally download preferences from a central location, saving in /home/'default_user'.


``intellij.alternatives``
------------
Full support for linux alternatives system. This state is not applicable for Archlinux and derivatives.


Please see the pillar.example for configuration.

Tested on Ubuntu 16.04, and Fedora 25
