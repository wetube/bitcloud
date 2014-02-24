#include <sqlite3.h>
#include <stdint.h>
#include <stdarg.h>
#include <time.h>

/* Error codes: */
#define BC_OK 0
#define BC_DB_ERROR 1
#define BC_BAD_DATA 2
#define BC_INCORRECT_SIGNATURE 3
#define BC_NOT_FOUND 4
#define BC_SERVER_ERROR 5


typedef uint32_t Key[8]; /* 256bits for keys */
typedef int Bool;
typedef time_t Time;
typedef int32_t Integer;
typedef int64_t Size;
typedef int Error;


/*
  Nodepool database structures and functions
  ------------------------------------------
*/

int bc_open_nodepool (const char* filename);

/* general authorization callback function for stlite: */
Error bc_auth (void *user_data,
               int even_code,
               const char *event_spec,
               const char *event_spec2,
               const char *db_name,
               const char *trigger);

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

Error bc_register_node (BCNode *node);
Error bc_get_node (BCNode *dest, Key public_key);
Error bc_update_node (BCNode *node);

Error bc_check_node_ca (BCNode *node);
Error bc_check_node_creation (BCNode *node);



/*
  Connections structures and functions
  ------------------------------------
*/

Error bc_prepare_sockets (void);

typedef struct BCConnection {
  BCNode node;
  Integer bandwidth_quality;
  Integer ping;
  Integer storage_quality;
  Integer availability;
  Integer service_quality;
  char address[0]; /* null terminated */
} BCConnection;

extern BCConnection *bc_Connections;
extern int n_Connections;

Error bc_node_connect (BCConnection *con, Key public_key);

