#include <stdio.h>
#include <stdlib.h>
#include "bitcloud.h"


int main (int argc, char **argv)
{

  if (bc_open_nodepool("nodepool")) return 1;
  
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
