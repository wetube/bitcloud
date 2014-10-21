#include <stdio.h>
#include <stdlib.h>
#include "bc_sockets.h"

int main (int argc, char **argv)
{

  if (bc_open_nodepool("nodepool")) return 1;
  
  return 0;
}
