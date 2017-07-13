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

``intellij.env``
------------

Full support for linux alternatives system.
Places a intellij profile in /etc/profile.d - this way the PATH is set correctly for all system users.


Please see the pillar.example for configuration.

Tested on Ubuntu 16.04, and Fedora 25
