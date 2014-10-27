#### Validation of blank nodepool database

After a new iteration of the code appears to compile and run, project best practice dictates that the ``nodepool``
DB next be tested to ensure it was actually generated properly.

** After test instance has executed and appears to have generated a blank ``nodepool`` DB, open SQLite command prompt 
with ``# sqlite3 nodepool.db`` (or replace the nodepool.db with whatever filename the nodepool was given).
** You should see a ``sqlite>`` command prompt.  Type ``.tables`` at the prompt and press enter.
** You should see a list of tables that matches the ``nodepool.sql`` schema.  
** You may also type ``.schema`` to have a complete schema printed.  This should match ``nodepool.sql``
** Type ``.exit`` and press enter to exit the SQLite command-line interface.

**You may use the SQLite command-line interface, in combination with the API, to output and query the nodepool 
database as part of the project's test-driven development lifecycle.**

