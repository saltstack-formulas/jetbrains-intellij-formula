========
jetbrains intellij
========

Formula for latest IntelliJ IDE from Jetbrains. Supports both 'Community' (default), and 'Ultimate' editions.

.. note::

    See the full `Salt Formulas installation and usage instructions
    <http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_.
    See pillar.example and defaults.yaml for configurable parameters. Tested on Linux (Ubuntu, Fedora, Arch, and Suse), MacOS. Not verified on Windows OS.
    
Available states
================

.. contents::
    :local:

``intellij``
------------
Downloads the archive from Jetbrains website, unpacks locally and installs the IDE on the Operating System.

.. note::

This formula automatically installs latest Jetbrains release. This behaviour may be overridden by pillars.

``intellij.developer``
------------
Create Desktop shortcuts. Optionally get preferences file from url/share and save into 'user' (pillar) home directory.


``intellij.linuxenv``
------------
On Linux, the PATH is set for all system users by adding software profile to /etc/profile.d/ directory. Full support for debian alternatives in supported Linux distributions (i.e. not Archlinux).

.. note::

Enable Debian alternatives by setting nonzero 'altpriority' pillar value; otherwise feature is disabled.

