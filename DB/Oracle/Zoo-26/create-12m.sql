-- Initializes the database and creates ALL.
-- This script must be run only once, being logged in as SYS with the SYSDBA role.

whenever oserror exit failure
whenever sqlerror exit sql.sqlcode


-- Entering the GOD mode
alter session set "_ORACLE_SCRIPT" = true
/


-- Init the common roles and accounts

@@init-database-m.sql

@@init-tourismus-m.sql


-- Init the CDB schema

@@init-schema-m.sql


-- Now leaving the GOD mode
alter session set "_ORACLE_SCRIPT" = false
/



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

