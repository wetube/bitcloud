#include "bitcloud.h"


int main (int argc, char **argv)
{
  sqlite3 *np; /* the nodepool db */
  int rc;
  
  rc = sqlite3_open ("nodepool", &np);
  if (rc) {
    fprintf(stderr, "Can't open nodepool: %s\n", sqlite3_errmsg(np));
    sqlite3_close (np);
    exit (1);
  }

  
  return 0;
}


int auth (void *user_data
          ,int event_code,
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
