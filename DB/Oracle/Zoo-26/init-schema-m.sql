-- Creates schemas for DataGrip Static Tests.
-- Run this script being logged in as SYS with the role SYSDBA.
--
-- Zoo_26_M has no C## prefix, and a local user cannot be created in CDB$ROOT
-- (ORA-65049), so this script needs the GOD mode and enters it by itself.
-- Note the side effects: such a user is not propagated into the PDBs
-- (which is exactly what we want here) and is flagged as ORACLE_MAINTAINED.


-- Entering the GOD mode
alter session set "_ORACLE_SCRIPT" = true
/


-- Zoo_26_M is the schema in the CDB database
-- This schema user itself must not have too high privileges.

create user Zoo_26_M identified by zoo -- this password should be changed on the real system
    default tablespace Users
    quota unlimited on users
/

grant connect, resource, debug connect session, debug any procedure
    to Zoo_26_M
/
grant C##_Development
    to Zoo_26_M
/


-- Now leaving the GOD mode
alter session set "_ORACLE_SCRIPT" = false
/
