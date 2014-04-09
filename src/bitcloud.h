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
  BC_BAD_SQL,
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
  BC_DAPP_BAD_REPOSITORY_SIGNATURE,
  /* NON ERRORS: */
  BC_NEXT_ROW,
} BCError;


typedef uint32_t BCKey[8]; /* 256bits for keys */
typedef uint32_t BCID[5];  /* 160bits for the node Id */
typedef int BCBool;
typedef time_t BCTime;
typedef unsigned char BCByte;

/* log an error to the logs table and (optionally) prints a msg: */
void bc_log (BCError error, const char *msg, ...);
extern BCBool log_to_stdout;
#define BC_MAX_LOG_SIZE 256


/*
  Nodepool database structures and functions
  ==========================================
*/

BCError  bc_open_nodepool (const char* filename);

extern sqlite3 *nodepool;


BCError bc_sql (sqlite3_stmt **stmt, const char* sql, char *format, ...);
BCError bc_get_row (sqlite3_stmt *stmt, char *format, ...);


/* general authorization callback function for sqlite: */
BCError bc_auth (void *user_data,
                 int even_code,
                 const char *event_spec,
                 const char *event_spec2,
                 const char *db_name,
                 const char *trigger);

/*
 We use ubjson specification http://ubjson.org/ for all serialization
 purposes.
*/

typedef BCByte BCMsgType;

#define BC_MSG_NULL 'Z'
#define BC_MSG_NO_OP 'N'
#define BC_MSG_TRUE 'T'
#define BC_MSG_FALSE 'F'
#define BC_MSG_INT8 'i'
#define BC_MSG_UINT8 'U'
#define BC_MSG_INT16 'I'
#define BC_MSG_INT32 'l'
#define BC_MSG_INT64 'L'
#define BC_MSG_FLOAT32 'd'
#define BC_MSG_FLOAT64 'D'
#define BC_MSG_CHAT 'C'
#define BC_MSG_STRING 'S' /* needs size */
#define BC_MSG_ARRAY_START '[' /* needs size */
#define BC_MSG_ARRAY_END ']' /* consistance check */
#define BC_MSG_OBJECT_START '{'  /* needs size */
#define BC_MSG_OBJECT_END '}' /* consistance check */
/* extensions to ubjson: */
#define BC_MSG_BLOB 'B' /* needs size */
#define BC_MSG_TABLE_ID BC_MSG_INT16
#define BC_MSG_INSERT_ROW 'R' /* needs table id and object */
#define BC_MSG_UPDATE_ROW 'W' /* needs table id and object */
#define BC_MSG_DELETE_ROW 'X' /* needs table id and object */

/*
  bc_deserialize assign data to variables. Ussage example:

  int table_id = <configs table id>;
  void *record = <incoming data>;
  char *var, *value;

  bc_deserialize (table_id, data, &var, &value);
  [ do something with var and value ]

 */
BCError bc_deserialize (int table_id, void *record, ...);
BCError bc_serialize (int table_id, void **destination, ...);


/* The three main functions of the nodepool section, most of the
   actions happen here, as each table has a different way to insert
   data. These functions dispatch the data received to the DApp functions
   using what is defined in the table_rules in nodepool.sql.

   Normally the dispatched functions will use bc_deserialize internally.
 */

BCError bc_insert (void *record);
BCError bc_update (void *record);
BCError bc_delete (void *record);


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
BCError bc_run_dapp (int id);
BCError bc_stop_dapp (int id);

BCError bc_update_repositories (int id);

/* this downloads the DApp from the repository referenced by its ID, which is
   a ZIP file that contains the shared libraries, the sql file and auxiliary
   files specific to the DApp: */
BCError bc_download_app (int id);

/* install a particual Dapp. The DApp will contain a sqlfile with an INSERT
   command for a new row in "DApps" table, plus all the tables needed for the
   Dapp with their respective "table_rules" row, plus all dynamic libraries
   needed all in a bundled zip file. */
BCError bc_install_dapp (char *zipfile);

/* stops the Dapp specified by the id and delete all the tables owned by the
   DApp */
BCError bc_uninstall_dapp (int id);



/*
  Sync structures and functions
  =============================
*/

BCError bc_prepare_sockets (void);

typedef struct BCNode {
  BCID id;
  char *address;        /* the sockaddr */
  int port;
  struct BCNode *next;  /* the neighboor */
} BCNode;

typedef struct BCConnection {
  BCNode node;
  int bandwidth_quality;
  int ping;
  int storage_quality;
  int availability;
  int service_quality;
  char address[0]; /* null terminated */
} BCConnection;

extern BCConnection *bc_Connections;
extern int n_Connections;

BCError bc_find_proximity (BCID * dest);

/*
 Messagge system
 ===============
*/


typedef struct BCMsg {
  BCKey origin;
  int command;
  void *data;
} BCMsg;

BCError bc_send (BCMsg);

/* receives the msg */
BCError bc_event_loop ();


#endif /* _BITCLOUD_H */
