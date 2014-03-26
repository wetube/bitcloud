#ifndef _BITCLOUD_H
#define _BITCLOUD_H

#include <uv.h>
#include <nss.h>
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
typedef uint32_t BCID[5];  /* 160bits for the node Id */
typedef int Bool;
typedef time_t BCTime;
typedef int32_t BCInteger;
typedef int64_t BCSize;


/*
  Nodepool database structures and functions
*/

BCError  bc_open_nodepool (const char* filename);

/* general authorization callback function for sqlite: */
BCError bc_auth (void *user_data,
                 int even_code,
                 const char *event_spec,
                 const char *event_spec2,
                 const char *db_name,
                 const char *trigger);

BCError bc_insert (int table, void **cells);
BCError bc_update (int table, void *row_id, void **new_cells);
BCError bc_delete (int table, void *row_id);


/*
  Connections structures and functions
*/

BCError bc_prepare_sockets (void);

typedef struct BCNode {
  BCID id;
  char *address;        /* the sockaddr */
  BCInteger port;
  struct BCNode *next;  /* the neighboor */
} BCNode;

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

int bc_find_proximity (BCID * dest);

/*
  Kademlia structures and functions
*/

typedef enum BCKMessage {
  BC_DHT_PING=0,
  BC_DHT_STORE,
  BC_DHT_FIND_NODE,
  BC_DHT_FIND_VALUE
} BCKMessage;

typedef struct BCKBucket {
  BCNode *nodes;             /* list of nodes for this bucket */
  struct BCKBucket *next;    /* next kbucket */
  BCInteger total_nodes;
  double k_min_range;
  double k_max_range;
} BCKBucket;

typedef struct BCKTable {
  BCKBucket *bucket;
  BCNode *queue;
} BCKTable;

typedef void bc_dht_callback(void *closure, BCKMessage event,
                             unsigned char *info_hash,
                             void *data, BCInteger data_len);

BCKTable bc_dht_init(BCInteger s, BCID *id);
int bc_dht_bootstrap(BCKTable *table);
int bc_dht_free(BCKTable *table);

int bc_dht_search(BCKey *key, BCID *id, bc_dht_callback *cb);
int bc_dht_insert(BCKey *key, BCID *id, char *buf, BCInteger size);

int bc_dht_insert_node(BCID *id);
int bc_dht_ping_node(BCID *id);

BCNode bc_dht_get_nodes(BCKTable *table);
/*
 * The value returned by this function estimates the expense of a message
 * sent from sender to receiver and must be calculates without time delay.
 */
int bc_cost(BCID *sender, BCID *receiver);

#endif /* _BITCLOUD_H */
