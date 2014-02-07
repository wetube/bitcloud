#include <stdlib.h>
/* glibc includes: */
#include <sys/socket.h>
#include <time.h>
/* external libs includes: */
#include <openssl/ssl.h>
#include <sqlite3.h>

typedef int bool;
typedef int CA; /* temporal assignment, it should be public CA key */

typedef struct Node {
  struct sockaddr * address;
  bool is_gateway;
  size_t max_storage;
  size_t used_storage;
  CA *gateways;
} Node;

typedef struct User {
} User;

typedef struct Publisher {
} Publisher;


typedef struct Nodepool {
  sqlite3 *db;
  time_t last_sync;
  
} Nodepool;
