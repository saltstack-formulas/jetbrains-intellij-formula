.. _readme:

intellij-formula
================

|img_travis| |img_sr|

.. |img_travis| image:: https://travis-ci.com/saltstack-formulas/intellij-formula.svg?branch=master
   :alt: Travis CI Build Status
   :scale: 100%
   :target: https://travis-ci.com/saltstack-formulas/intellij-formula
.. |img_sr| image:: https://img.shields.io/badge/%20%20%F0%9F%93%A6%F0%9F%9A%80-semantic--release-e10079.svg
   :alt: Semantic Release
   :scale: 100%
   :target: https://github.com/semantic-release/semantic-release

Formula to install Intellij on GNU/Linux and MacOS.

.. contents:: **Table of Contents**
   :depth: 1

General notes
-------------

See the full `SaltStack Formulas installation and usage instructions
<https://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_.

If you are interested in writing or contributing to formulas, please pay attention to the `Writing Formula Section
<https://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html#writing-formulas>`_.

If you want to use this formula, please pay attention to the ``FORMULA`` file and/or ``git tag``,
which contains the currently released version. This formula is versioned according to `Semantic Versioning <http://semver.org/>`_.

See `Formula Versioning Section <https://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html#versioning>`_ for more details.

If you need (non-default) configuration, please pay attention to the ``pillar.example`` file and/or `Special notes`_ section.

Contributing to this repo
-------------------------

**Commit message formatting is significant!!**

Please see `How to contribute <https://github.com/saltstack-formulas/.github/blob/master/CONTRIBUTING.rst>`_ for more details.

Special notes
-------------

None.


Available states
----------------

.. contents::
   :local:

``intellij``
^^^^^^^^^^

*Meta-state (This is a state that includes other states)*.

This installs Intellij package,
manages Intellij configuration file and then
configures the development environment.

``intellij.archive``
^^^^^^^^^^^^^^^^^

This state will install Intellij from archive only.

``intellij.macapp``
^^^^^^^^^^^^^^^^^

This state will install Intellij from source only.

``intellij.config``
^^^^^^^^^^^^^^^^^

This state will configure npmrc and/or environment and has a dependency on ``intellij.install``
via include list.

``intellij.linuxenv``
^^^^^^^^^^^^^^^^^^^^

This state will install some Intellij linux-alternatives on GNU/Linux.

``intellij.clean``
^^^^^^^^^^^^^^^^

*Meta-state (This is a state that includes other states)*.

this state will undo everything performed in the ``intellij`` meta-state in reverse order, i.e.
removes the configuration file and
then uninstalls the package.

``intellij.config.clean``
^^^^^^^^^^^^^^^^^^^^^^^

This state will remove the configuration of Intellij and has a
dependency on ``intellij.package.clean`` via include list.

``intellij.archive.clean``
^^^^^^^^^^^^^^^^^^^^^^^^

This state will remove Intellij package and has a dependency on
``intellij.config.clean`` via include list.

``intellij.macapp.clean``
^^^^^^^^^^^^^^^^^^^^^^^

This state will remove Intellij package and has a dependency on
``intellij.config.clean`` via include list.

``intellij.linuxenv.clean``
^^^^^^^^^^^^^^^^^^^^^^^^^

This state will remove Intellij linux-alternatives on GNU/Linux.


Testing
-------

Linux testing is done with ``kitchen-salt``.

Requirements
^^^^^^^^^^^^

* Ruby
* Docker

.. code-block:: bash

   $ gem install bundler
   $ bundle install
   $ bin/kitchen test [platform]

Where ``[platform]`` is the platform name defined in ``kitchen.yml``,
e.g. ``debian-9-2019-2-py3``.

``bin/kitchen converge``
^^^^^^^^^^^^^^^^^^^^^^^^

Creates the docker instance and runs the ``intellij`` main state, ready for testing.

``bin/kitchen verify``
^^^^^^^^^^^^^^^^^^^^^^

Runs the ``inspec`` tests on the actual instance.

``bin/kitchen destroy``
^^^^^^^^^^^^^^^^^^^^^^^

Removes the docker instance.

``bin/kitchen test``
^^^^^^^^^^^^^^^^^^^^

Runs all of the stages above in one go: i.e. ``destroy`` + ``converge`` + ``verify`` + ``destroy``.

``bin/kitchen login``
^^^^^^^^^^^^^^^^^^^^^

Gives you SSH access to the instance for manual testing.

