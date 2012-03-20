========================
Python bindings for JLog
========================

This package contains Python bindings for `JLog
<https://labs.omniti.com/labs/jlog>`_. JLog is a pure C, very simple durable
message queue with multiple subscribers and publishers (both thread and
multi-process safe).

Dependancies
============

- JLog (http://labs.omniti.com/labs/jlog)

Install
=======

Run this command::

    python setup.py install

Performance
===========

Roughly 175,000 writes per second, and 700,000 reads per second.
