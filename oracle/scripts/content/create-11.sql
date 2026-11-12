-- Initializes the database and creates ALL.
-- This script must be run only once, being logged in as SYS with the SYSDBA role.

whenever oserror exit failure
whenever sqlerror exit sql.sqlcode


-- Log everything into a file: the text of every command and its result.
-- If something fails, the end of this file shows the failed command and the error.
-- NB: when SQL*Plus is started in the silent mode (with the option -S),
-- it doesn't echo commands, so the log contains the results only.

spool /tmp/zoo-26-setup.log
set trimspool on
set echo on

@@Sys/init-database-c.sql

@@Sys/init-tourismus-c.sql

@@Sys/init-schema-c.sql


-- This script is needed to reduce introspection time
begin
    sys.dbms_stats.gather_dictionary_stats;
    sys.dbms_stats.gather_fixed_objects_stats;
end;
/


-- The empty schema is now created.
-- In order to create objects inside the created schema,
-- we should log in as the owner of the schema.

connect Zoo_26/zoo

@@Zoo-26/make-11.sql

@@Zoo-26/grants.sql


-- Close the log file

spool off


-- Tell the health check that the setup is over.
-- This script exits SQL*Plus on the first error, so this is reached
-- only when every script of the chain has succeeded.

spool /tmp/zoo-26-setup-complete.log
prompt Setup complete.
spool off


exit
