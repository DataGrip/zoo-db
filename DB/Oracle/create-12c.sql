-- Initializes the database and creates ALL.
-- This script must be run only once, being logged in as SYS with the SYSDBA role.

whenever oserror exit failure
whenever sqlerror exit sql.sqlcode

@@Sys/init-database-c.sql

@@Sys/init-tourismus-c.sql

@@Sys/init-schema-c.sql


-- The empty schema is now created.
-- In order to create objects inside the created schema,
-- we should log in as the owner of the schema.

connect Zoo_26/zoo

@@Zoo-26/make-11.sql

@@Zoo-26/grants.sql


exit
