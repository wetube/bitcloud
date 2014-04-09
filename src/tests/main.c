#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <assert.h>
#include <bitcloud.h>

#include "logs.c"
#include "serialization.c"

int main (int argc, char **argv)
{

  assert (bc_open_nodepool("nodepool") == BC_OK);
  bc_log (BC_OK, "Starting tests...");
  logs ();
  serialization ();
  bc_log (BC_OK, "Tests finished.");

  return 0;
}
