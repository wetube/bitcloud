/*  This contains all Bitcloud networking code, leveraging UV library.
*/

#include "libuv/include/uv.h"   // make sure it is there
#include "bitcloud.h"

// socket structure 

typedef struct bc_socket {
  char *address;        /* the sockaddr */
  int port;
  bc_error status;
  // what else?
} bc_socket;

// function prototypes/declarations

bc_socket bc_prepare_sockets (void);

bc_error bc_open_sockets (bc_socket *cur_sock); // and initiate listening

bc_error bc_close_sockets (bc_socket *cur_sock);

bc_error bc_sockets_connect (bc_socket *cur_sock); // reach out to another node

// not sure if these two will be needed

bc_error bc_sockets_transmit (bc_socket *cur_sock);

bc_error bc_sockets_receive (bc_socket *cur_sock);
