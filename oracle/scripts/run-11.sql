-- The entry point for Oracle 11.2 non-CDB.
--
-- This is the only file mounted into the directory the container's setup
-- runner scans, so it is the only script that runner starts. Everything else
-- is mounted at /Zoo-26, outside of that directory, and is started from here
-- in the order that create-11.sql itself defines.
--
-- The path below must be absolute. Inside Zoo-26/ the scripts refer
-- to each other by a bare name, so there '@@' works as intended.

@/Zoo-26/create-11.sql


-- Tell the health check that the setup is over.
-- create-11.sql exits SQL*Plus on the first error, so this is reached
-- only when every script of the chain has succeeded.
spool /tmp/zoo-26-setup-complete.log
prompt Setup complete.
spool off
