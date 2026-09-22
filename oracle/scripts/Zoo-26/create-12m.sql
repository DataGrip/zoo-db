-- Initializes the database and creates ALL.
-- This script must be run only once, being logged in as SYS with the SYSDBA role.

whenever oserror exit failure
whenever sqlerror exit sql.sqlcode


-- Init the common roles and accounts.
-- All of them are named with the C## prefix, so they are created in a regular
-- way: CONTAINER = ALL makes Oracle propagate them into every PDB.
-- The GOD mode must NOT be used here: under "_ORACLE_SCRIPT" the common DDL
-- is not propagated to the PDBs at all, and the objects get flagged
-- as ORACLE_MAINTAINED.

@@init-database-m.sql

@@init-tourismus-m.sql


-- Init the CDB schema.
-- Unlike the common roles and accounts above, Zoo_26_M still needs
-- the GOD mode -- this script turns it on and off by itself.

@@init-schema-m.sql



-- Init the PDB schema

alter session set container = ORCLPDB1
/

@@init-database-p.sql

@@init-schema-p.sql


-- The empty schemas are now created.
-- In order to create objects inside the created schemas,
-- we should log in every of them as their owners.
-- Setting CURRENT_SCHEMA is not enough here: it doesn't change
-- the privilege domain, and the USER_* views (used by make-11.sql
-- to check that the schema is empty) still refer to the session user.


-- Create objects in the CDB schema

connect Zoo_26_M/zoo@//localhost:1521/ORCLCDB

@@make-11.sql


-- Create objects in the PDB schema

connect Zoo_26_P/zoo@//localhost:1521/ORCLPDB1

@@make-11.sql

