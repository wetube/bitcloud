#include <assert.h>
#include <bitcloud.h>

int main (int argc, char **argv)
{

  assert (bc_open_nodepool("nodepool") == BC_OK);
  bc_log (BC_OK, "Starting tests...");
  bc_log (BC_OK, "Tests finished.");

  return 0;
}
