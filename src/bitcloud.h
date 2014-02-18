#include <sqlite3.h>
#include <stdint.h>
#include <stdarg.h>
#include <time.h>

/* general authorization callback function for stlite: */
int bc_auth (void *user_data,
             int even_code,
             const char *event_spec,
             const char *event_spec2,
             const char *db_name,
             const char *trigger);


int bc_open_nodepool (const char* filename);

int bc_insert (const char *table, ...);
int bc_delete (const char *table, ...);


typedef uint32_t Key[8];
typedef int Bool;
typedef time_t Time;
typedef int32_t Integer;
typedef int64_t Size;

typedef struct BCNode {
  Key public_key;
  Key signature;
  Time creation_date;
  Key proof_of_creation;
  Integer net_protocol;
  Time last_online;
  Size storage_capacity;
  Integer storage_reputation;
  Integer bandwidth_reputation;
  Integer service_reputation;
  Integer availability;
  char address[0]; /* null terminated */
} BCNode;

int bc_register_node (BCNode *node);
