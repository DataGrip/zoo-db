-- Initializes the database and creates ALL.
-- This script must be run only once, being logged in as SYS with the SYSDBA role.

whenever oserror exit failure
whenever sqlerror exit sql.sqlcode

@@init-database.sql

@@init-schema.sql


-- The empty schema is now created.
-- In order to create objects inside the created schema,
-- we should log in as the owner of the schema.

connect Zoo_26/zoo

@@make-11.sql
