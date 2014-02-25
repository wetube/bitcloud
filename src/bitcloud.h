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


typedef uint32_t BCKey[8]; /* 256bits for keys */
typedef int Bool;
typedef time_t Time;
typedef int32_t BCInteger;
typedef int64_t BCSize;
typedef int BCError;


/*
  Nodepool database structures and functions
  ------------------------------------------
*/

int bc_open_nodepool (const char* filename);

/* general authorization callback function for stlite: */
BCError bc_auth (void *user_data,
               int even_code,
               const char *event_spec,
               const char *event_spec2,
               const char *db_name,
               const char *trigger);

typedef struct BCNode {
  BCKey public_key;
  BCKey signature;
  Time creation_date;
  BCKey proof_of_creation;
  BCInteger net_protocol;
  Time last_online;
  BCSize storage_capacity;
  BCInteger storage_reputation;
  BCInteger bandwidth_reputation;
  BCInteger service_reputation;
  BCInteger availability;
  char address[0]; /* null terminated */
} BCNode;

BCError bc_register_node (BCNode *node);
BCError bc_get_node (BCNode *dest, BCKey public_key);
BCError bc_update_node (BCNode *node);

BCError bc_check_node_ca (BCNode *node);
BCError bc_check_node_creation (BCNode *node);



/*
  Connections structures and functions
  ------------------------------------
*/

BCError bc_prepare_sockets (void);

typedef struct BCConnection {
  BCNode node;
  BCInteger bandwidth_quality;
  BCInteger ping;
  BCInteger storage_quality;
  BCInteger availability;
  BCInteger service_quality;
  char address[0]; /* null terminated */
} BCConnection;

extern BCConnection *bc_Connections;
extern int n_Connections;

BCError bc_node_connect (BCConnection *con, BCKey public_key);

