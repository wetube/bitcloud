#include <stdlib.h>
/* external libs includes: */
#include <openssl/ssl.h>
#include <sqlite3.h>


/* general authorization callback function for stlite: */
int auth (void *user_data
          ,int even_code,
          const char *event_spec,
          const char *event_spec2,
          const char *db_name,
          const char *trigger);

