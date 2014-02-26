#include <sqlite3.h>
#include <stdint.h>
#include <stdarg.h>
#include <time.h>

/* Error codes: */
typedef enum BCError {
  BC_OK=0,
  BC_DB_ERROR,
  BC_BAD_DATA,
  BC_BAD_SIGNATURE,
  BC_NOT_FOUND,
  BC_SERVER_ERROR,
  BC_NO_CONNECTION,
  BC_DROP_CONNECTION,
  BC_BAD_DNS,
  BC_BAD_ROUTE,
  BC_UNEXPECTED_END,
  BC_CORRUPT_DATA
} BCError;

typedef uint32_t BCKey[8]; /* 256bits for keys */
typedef int Bool;
typedef time_t BCTime;
typedef int32_t BCInteger;
typedef int64_t BCSize;


/*
  Nodepool database structures and functions
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
  BCTime creation_date;
  BCKey proof_of_creation;
  BCInteger net_protocol;
  BCTime last_online;
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
BCError bc_node_disconnect (BCConnection *con);


/*
  Filesystem structures
*/

typedef struct BCFolder {
} BCFolder;


/*
  User structures and functions
*/
typedef struct BCUser {
  BCKey public_key;
  struct BCPublisher *publisher;
  BCKey publisher_signature;
  char *nickname;
  BCTime revocation_date;
  BCSize storage_quota;
  BCSize bandwidth_quota;
  BCSize files_quota;
  BCSize folder_quota;
  BCFolder *root_folder;
} BCUser;


/*
  Publisher structures and functions
*/

typedef struct BCPublisher {
  BCKey public_key;
  BCTime creation_date;
  BCKey proof_of_creation;
  char *nickname;
  Bool public_metadata;
  Bool public_files;
  Bool trust_all_users;
  BCUser *users;
  BCInteger n_users;
} BCPublisher;


BCError bc_register_publisher (BCPublisher *publisher);
BCError bc_get_publisher (BCPublisher *dest, BCKey public_key);
BCError bc_update_publisher (BCPublisher *publisher);

BCError bc_check_publisher_ca (BCPublisher *publisher);
BCError bc_check_publisher_creation (BCPublisher *publisher);

BCError bc_get_users (BCUser **dest, BCPublisher *publisher);
BCError bc_get_user (BCUser *dest, BCKey user_key);
