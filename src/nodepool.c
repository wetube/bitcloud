#include <stdio.h>
#include "bitcloud.h"

#include "nodepool_sql.h"

/*
 Opens the nodepool db.
 If it doesn't exist, it creates all the necessary tables.

 Returns 1 in case of error, 0 if ok.
*/

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
    nodepool_sql[nodepool_sql_len] = 0; /* <- because xxd doesn't end the string in NULL */
    rc = sqlite3_exec (np,(const char*)nodepool_sql,NULL,NULL,&err);
    if (rc != SQLITE_OK) {
      fprintf (stderr, "FATAl: %s.\n", err);
      sqlite3_free (err);
      sqlite3_close (np);
      remove (filename);
      return (1);
    }
    fprintf(stderr, "DONE.\n");
  }

  return 0;
}



/* general authorization callback function for sqlite */

BCError bc_auth (void *user_data,
                 int event_code,
                 const char *event_spec,
                 const char *event_spec2,
                 const char *db_name,
                 const char *trigger)
{
  switch (event_code) {
    default:
      return SQLITE_DENY;
    }
  return SQLITE_DENY;
}

BCError bc_register_node (BCNode *node)
{
  if (!node) return BC_BAD_DATA;


  return 0;
}
