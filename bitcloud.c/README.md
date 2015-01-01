Requirements
============

Current requirements:

- GCC and GNU make.
- sqlite3-dev
- xxd
- pkg-config
- libuv-dev

Tested on Debian 7, Does not compile on Mac OSX 10.9.

Building the PoC
====================

To compile, just:

`make`

Test
-----

`make tests`

This will create a nodepool in the "tests" directory and run tests.

Clean
-----

`make clean`

This will remove all compiled files, the nodepool, and tests.

Nodepool
========

To generate the nodepool, run:

`./bitcloud`

Every time nodepool.sql is modified, the last nodepool is deleted, so
make backup copies in case that the content in the actual nodepool is
important to preserve.

The generated nodepool can be open by sqlite3 or a client of it:

`# sqlite3 nodepool`

`.schema`

`.help`

To see the logs from the command line:

`sqlite3 nodepool "select * from logs"`
