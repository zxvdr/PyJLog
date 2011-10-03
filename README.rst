========================
Python bindings for JLog
========================

This package contains Python bindings for `JLog
<https://labs.omniti.com/labs/jlog>`_. JLog is a pure C, very simple durable
message queue with multiple subscribers and publishers (both thread and
multi-process safe).

Building and installation
=========================

To build and install this Python package, you will first need to build
and install JLog itself. After you have done this, follow these steps:

First, edit the `include_dirs` and `library_dirs` fields of the
:file:`setup.cfg` file in this directory to point to the directories that
contain the library and header file for your JLog installation.

Second, run this command::

    python setup.py install

If you want to develop this package, instead of this last command do::

    python setup.py build_ext --inplace
    python setupegg.py develop

This will build the C extension inplace and then put this directory on your
``sys.path``. With this setup you only have to run ``python setup.py build_ext
--inplace`` each time you change the ``.pyx`` files.

Performance
===========

Roughly 175,000 writes per second, and 700,000 reads per second.
