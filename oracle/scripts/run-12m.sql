-- The entry point for Oracle 12.2 multitenant.
-- See run-11.sql for how this indirection works.

@/Zoo-26/create-12m.sql


-- Tell the health check that the setup is over.
-- create-12m.sql exits SQL*Plus on the first error, so this is reached
-- only when every script of the chain has succeeded.
spool /tmp/zoo-26-setup-complete.log
prompt Setup complete.
spool off
