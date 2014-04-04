#ifndef _BITCLOUD_H
#define _BITCLOUD_H

/* #include "libuv/include/uv.h"*/
/* #include <nss.h> */
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
  BC_CORRUPT_DATA,
  /* DApps errors: */
  BC_DAPP_BAD_LIBRARY,
  BC_DAPP_NOT_INSTALLED,
  BC_DAPP_BAD_TABLE_RULES,
  BC_DAPP_ID_CONFLICT,
  BC_DAPP_BAD_REPOSITORY_SIGNATURE
} BCError;

/* log an error to the logs table and (optionally) prints a msg: */
void bc_log (BCError error, char *msg, ...);

typedef uint32_t BCKey[8]; /* 256bits for keys */
typedef uint32_t BCID[5];  /* 160bits for the node Id */
typedef int Bool;
typedef time_t BCTime;
typedef int32_t BCInt;
typedef int64_t BCSize;


/*
  Nodepool database structures and functions
  ==========================================
*/

BCError  bc_open_nodepool (const char* filename);

extern sqlite3 *nodepool;

/* general authorization callback function for sqlite: */
BCError bc_auth (void *user_data,
                 int even_code,
                 const char *event_spec,
                 const char *event_spec2,
                 const char *db_name,
                 const char *trigger);


typedef struct BCRecord {
  BCInt table_id;
  union { /* the id, needed to identify the record */
    BCKey key;
    BCInt number;
  } id;
  struct {
    BCSize length;
    void *data;
  } *cells;
} BCRecord;


/* The three main functions of the nodepool section, most of the
   actions happen here, as each table has a different way to insert
   data. These functions dispatch the data received to the DApp functions
   using what is defined in the table_rules in nodepool.sql */

BCError bc_insert (BCRecord *record);
BCError bc_update (BCRecord *record);
BCError bc_delete (BCRecord *record);


BCError bc_deserialize (void *data, BCRecord **dest);
BCError bc_serialize (BCRecord *record, void **dest);


/*
  Dapps functions
  ===============
*/

/* Run all the Dapps that are specified in "Dapps" table with the "run"
   attribute set to true. Dynamic libraries for the Dapps must be in the
   "dapps" directory, except if they are compiled static. */
BCError bc_run_all_dapps (void);

/* load in memory and run or stop a specific Dapp defined in the DApps
   table: */
BCError bc_run_dapp (BCInt id);
BCError bc_stop_dapp (BCInt id);

BCError bc_update_repositories (BCInt id);

/* this downloads the DApp from the repository referenced by its ID, which is
   a ZIP file that contains the shared libraries, the sql file and auxiliary
   files specific to the DApp: */
BCError bc_download_app (BCInt id);

/* install a particual Dapp. The DApp will contain a sqlfile with an INSERT
   command for a new row in "DApps" table, plus all the tables needed for the
   Dapp with their respective "table_rules" row, plus all dynamic libraries
   needed all in a bundled zip file. */
BCError bc_install_dapp (char *zipfile);

/* stops the Dapp specified by the id and delete all the tables owned by the
   DApp */
BCError bc_uninstall_dapp (BCInt id);



/*
  Sync structures and functions
  =============================
*/

BCError bc_prepare_sockets (void);

typedef struct BCNode {
  BCID id;
  char *address;        /* the sockaddr */
  BCInt port;
  struct BCNode *next;  /* the neighboor */
} BCNode;

typedef struct BCConnection {
  BCNode node;
  BCInt bandwidth_quality;
  BCInt ping;
  BCInt storage_quality;
  BCInt availability;
  BCInt service_quality;
  char address[0]; /* null terminated */
} BCConnection;

extern BCConnection *bc_Connections;
extern int n_Connections;

BCError bc_find_proximity (BCID * dest);



#endif /* _BITCLOUD_H */
