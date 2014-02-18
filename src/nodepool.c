#include <stdio.h>
#include "bitcloud.h"

#include "nodepool_sql.h"

int bc_open_nodepool (const char* filename)
{
  sqlite3 *np; /* the nodepool db */
  int rc;
  char *err;
  
  rc = sqlite3_open_v2(filename, &np, SQLITE_OPEN_READWRITE, NULL);
  if (rc) { /* file doesn't exist yet or is readonly */
    sqlite3_close (np);
    fprintf(stderr, "Trying to create a new nodepool... ");
    rc = sqlite3_open(filename, &np);
    if (rc) {
      fprintf(stderr, "ERROR: %s\n", sqlite3_errmsg(np));
      sqlite3_close (np);
      return (1);
    }
    /* Create all the tables in the nodepool.sql file: */
    rc = sqlite3_exec (np,(const char*)nodepool_sql,NULL,NULL,&err);
    if (rc != SQLITE_OK) {
      fprintf (stderr, "FATAl: %s.\n", err);
      sqlite3_free (err);
      sqlite3_close (np);
      return (1);
    }  
    fprintf(stderr, "DONE.\n");
  }

  return 0;
}
