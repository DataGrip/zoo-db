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

-- Some commands are built and performed in PL/SQL blocks,
-- these blocks print the commands they perform; make it visible.

set serveroutput on


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


-- Create the additional PDB that is never opened (its status stays NEW).
-- The session is still in the CDB root here.

@@Sys/init-neoretro-m.sql

-- Create one more additional PDB and unplug it (its status is UNPLUGGED).

@@Sys/init-alterhof-m.sql

-- Create and open the PDB for the schema with editions.

@@Sys/init-bluechip-m.sql



-- Init the PDB schema

alter session set container = ORCLPDB1
/

-- Only the PDB gets the extended data types (long VARCHAR2 etc.), the CDB root keeps the standard ones.
-- This is done first, while the PDB is still empty, so utl32k.sql has less work.

@@Sys/extend-12p.sql

-- The Oracle scripts called from there may change the SQL*Plus settings
-- or close the log file, so turn the logging on again.

spool /tmp/zoo-26-setup.log append
set echo on
set serveroutput on

@@Sys/init-database-p.sql

@@Sys/init-schema-p.sql


-- Init the schema with editions in the PDB BLUECHIP

alter session set container = BLUECHIP
/

@@Sys/init-database-p.sql

@@Sys/init-bluechip-p.sql


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


-- Create objects in the schema with editions in the PDB BLUECHIP

connect Zoo_26_Q/zoo@//localhost:1521/BLUECHIP.localdomain

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
