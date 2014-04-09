
void serialization (void)
{
  static sqlite3_stmt *stmt = NULL, *stmt2 = NULL;
  char *var, *value, *var1, *value1;

  var = "testvar";
  value = "testvalue";
  var1 = "bad";
  value1 = "bad";

  assert (!bc_sql (&stmt,
                   "INSERT INTO config VALUES (?,?)",
                   "SS", var, value));
  assert (!bc_sql (&stmt2,
                   "SELECT * FROM config", ""));
  assert (!bc_get_row (stmt2, "SS", &var1, &value1));
  assert (!strcmp (var, var1));
  assert (!strcmp (value, value1));
  free (var1); free (value1);
}
