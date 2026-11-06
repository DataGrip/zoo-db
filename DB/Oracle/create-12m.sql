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

@@Sys/init-database-m.sql

@@Sys/init-tourismus-m.sql


-- Init the CDB schema.
-- Unlike the common roles and accounts above, Zoo_26_M still needs
-- the GOD mode -- this script turns it on and off by itself.

@@Sys/init-schema-m.sql



-- Init the PDB schema

alter session set container = ORCLPDB1
/

-- Only the PDB gets the extended data types (long VARCHAR2 etc.), the CDB root keeps the standard ones.
-- This is done first, while the PDB is still empty, so utl32k.sql has less work.

@@Sys/extend-12p.sql

@@Sys/init-database-p.sql

@@Sys/init-schema-p.sql


-- The empty schemas are now created.
-- In order to create objects inside the created schemas,
-- we should log in every of them as their owners.
-- Setting CURRENT_SCHEMA is not enough here: it doesn't change
-- the privilege domain, and the USER_* views (used by make-11.sql
-- to check that the schema is empty) still refer to the session user.


-- Service names are written in full, with the DB domain:
-- EZConnect doesn't append the domain, and the short names
-- may be not registered in the listener (ORA-12514).
-- The port 1521 is the port inside the container,
-- so this script should be run inside the container.


-- Create objects in the CDB schema

connect Zoo_26_M/zoo@//localhost:1521/ORCLCDB.localdomain

@@Zoo-26/make-11.sql

@@Zoo-26/grants.sql


-- Create objects in the PDB schema

connect Zoo_26_P/zoo@//localhost:1521/ORCLPDB1.localdomain

@@Zoo-26/make-11.sql

@@Zoo-26/grants.sql


exit

