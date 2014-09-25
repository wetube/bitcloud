/* About the comments: right now we are writing here the documentation and ideas as
   we prototype. When we write the real documentation, most of the comments here will
   be deleted and moved to the docs. */

#ifndef _BITCLOUD_H
#define _BITCLOUD_H

/* #include "libuv/include/uv.h"*/
/* #include <nss.h> */
#include <sqlite3.h>

#include <stdint.h>
#include <stdarg.h>
#include <time.h>

/* Error codes: */
typedef enum bc_error {
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
  BC_DAPP_BAD_REPO_SIG,
  /* attempt to write to a non serializable table: */
  BC_TABLE_NOT_SERIALIZABLE,
  /* NON ERRORS: */
  BC_ROW, /* a new row is ready to read */
  BC_DONE, /* done steeping */
} bc_error;


typedef uint8_t bc_key[256]; /*2048 bits*/
typedef uint8_t bc_signature[256];
typedef uint8_t bc_id[40];  /* 160bits for the node Id */
typedef sqlite3_stmt* bc_stmt; /* statement for the db operations */

/* log an error to the logs table and (optionally) prints a msg: */
void bc_log (bc_error error, const char *msg, ...);
extern int BC_log_to_stdout;
#define BC_MAX_LOG_SIZE 256



/*
  Nodepool database structures and functions
  ==========================================
*/

bc_error  bc_open_nodepool (const char* filename);

extern sqlite3 *nodepool;

/* functions to use SQL inside BC and Dapps: */
/* TODO: documentation */
bc_error bc_sql (bc_stmt *stmt, const char* sql);
bc_error bc_step (bc_stmt stmt);
bc_error bc_reset (bc_stmt stmt);
bc_error bc_finalize (bc_stmt stmt);
bc_error bc_binds (bc_stmt stmt, int position, const char *value);
bc_error bc_bindi (bc_stmt stmt, int position, int value);
int bc_geti (bc_stmt stmt, int column);
char *bc_gets (bc_stmt stmt, int column);

/* exit if there is an important SQL error */
extern int BC_exit_on_sql_error;


/*
  UBJSON
  ======

 We use ubjson specification http://ubjson.org/ for all serialization
 purposes, with some extensions like specified below:
*/

typedef char bc_msgType;

/* standard ubjson: */
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
#define BC_MSG_ID 'Y' /*20 bytes (160bits)  ID*/
#define BC_MSG_SIGNATURE 'G' /* public signature */
#define BC_MSG_KEY 'K' /* public or private encryption key */
#define BC_MSG_DATE 'E' /*date in unix timestamp format*/
#define BC_MSG_BLOB 'B' /* needs size which is 8 bytes length instead of 4 */
#define BC_MSG_TABLE_NAME 'A' /* size of 1byte length and name */
#define BC_MSG_INSERT_ROW 'R' /* size and serialized data between {} */
#define BC_MSG_UPDATE_ROW 'W' /* size and serialized data between {} */
#define BC_MSG_DELETE_ROW 'X' /* size and key between {} */

/* All sizes are 4 bytes length, except for the blob which is 8 bytes, and the table
name which is 1 byte */


/*
  examples of a serialized table:

  A5nodesR{0123...serialized data here...}X{0123...key data...}
   ^1size   ^size of the data               ^size of the key

   A is the marker, 5 the size of the name "nodes", R is the marker commanding to insert a row, { initiates the row, then it comes the count of elements, the elements themselves, and the } to check consistency.

  The serialized data in the example is also ubjson format, each column is a
  value, like:
  
  R{0012Y12345E1411655029S16this is a string}
    ^siz^ID   ^date      ^string

  So there is a size and 3 columns in the example, one of type ID, one of type date and
  the other of type string.

  It is important to take in consideration that numbers are really stored in
  binary format, not in ASCII, but here we show them in ASCII for clarity of understanding.

*/


/*
  CELLS
  =====

  A row is composed by a series of cells, corresponding to the columns in a
  table. Each cell must have a type, typically in correspondence with the type
  of the column.

*/

typedef enum bc_cell_type {
  BC_TYPE_NULL=0,
  BC_TYPE_ID,
  BC_TYPE_KEY,
  BC_TYPE_SIGNATURE,
  BC_TYPE_INTEGER,
  BC_TYPE_REAL,
  BC_TYPE_STRING,
  BC_TYPE_BLOB
} bc_cell_type;

/* A cell in a table: */
typedef struct  bc_cell {
  bc_cell_type type;
  union {
    bc_key key;
    bc_id id;
    bc_signature signature;
    int integer;
    char *string;
    double real;
    struct {
      size_t size;
      uint8_t *data;
    } blob;
  } value;
} bc_cell;

/* A row is a null terminated (the type is BC_TYPE_NULL) array of cells: */
typedef bc_cell *bc_row;


/*
  SERIALIZATION
  =============
*/


bc_error bc_deserialize_row (const char *table_name,
                             uint8_t *origin,
                             size_t size,
                             bc_row *row);
/* the row is initialized by the function, so it should not point to any
   allocated memory or a memory leak may happen.

   // example:
   ... obtain 'origin' and 'size' from the net ...
   bc_row row = NULL;
   if (!bc_deserialize_rows ("nodes", origin, size, &row)) {
     ... do things with the row ...
     free (row);
   }
*/

bc_error bc_serialize_row (const char *table_name, bc_row row, uint8_t **destination);
/* // example:
   ... obtain the row from other means ...
   if (!bc_serialize_row ("nodes", row, &destination)) {
     .... do things with destination ....
     free (destination);
   }
*/

/*
  DATABASE WRITING
  ================
*/

/* The three main functions of the nodepool section, most of the
   actions happen here, as each table has a different way to insert
   data. These functions dispatch the data received to the DApp functions
   using what is defined in the table_rules in nodepool.sql.

   Normally the dispatched functions will use bc_deserialize internally.
 */

bc_error bc_insert (char *table, bc_cell *row);
bc_error bc_update (char *table, bc_cell *row);
bc_error bc_delete (char *table, bc_cell *row);



/*
  Dapps functions
  ===============
*/

/* Run all the Dapps that are specified in "Dapps" table with the "run"
   attribute set to true. Dynamic libraries for the Dapps must be in the
   "dapps" directory, except if they are compiled static. */
bc_error bc_run_all_dapps (void);

/* load in memory and run or stop a specific Dapp defined in the DApps
   table: */
bc_error bc_run_dapp (int id);
bc_error bc_stop_dapp (int id);

bc_error bc_update_repositories (int id);

/* this downloads the DApp from the repository referenced by its ID, which is
   a ZIP file that contains the shared libraries, the sql file and auxiliary
   files specific to the DApp: */
bc_error bc_download_app (int id);

/* install a particual Dapp. The DApp will contain a sqlfile with an INSERT
   command for a new row in "DApps" table, plus all the tables needed for the
   Dapp with their respective "table_rules" row, plus all dynamic libraries
   needed all in a bundled zip file. */
bc_error bc_install_dapp (char *zipfile);

/* stops the Dapp specified by the id and delete all the tables owned by the
   DApp */
bc_error bc_uninstall_dapp (int id);



/*
  Sync structures and functions
  =============================
*/

bc_error bc_prepare_sockets (void);

typedef struct bc_node {
  bc_id id;
  char *address;        /* the sockaddr */
  int port;
  struct bc_node *next;  /* the neighboor */
} bc_node;

typedef struct bc_connection {
  bc_node node;
  int bandwidth_quality;
  int ping;
  int storage_quality;
  int availability;
  int service_quality;
  char address[0]; /* null terminated */
} bc_connection;

extern bc_connection *bc_Connections;
extern int n_Connections;

bc_error bc_find_proximity (bc_id * dest);

/*
 Messagge system
 ===============
*/


typedef struct bc_msg {
  bc_key origin;
  int command;
  uint8_t *data;
} bc_msg;

bc_error bc_send (bc_msg);

/* receives the msg */
bc_error bc_event_loop ();


#endif /* _BITCLOUD_H */
