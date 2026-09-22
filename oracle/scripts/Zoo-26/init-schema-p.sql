-- Creates schemas for DataGrip Static Tests.
-- Run this script being logged in as SYS with the role SYSDBA.


-- Zoo_26_P is the schema in a PDB database
-- This schema user itself must not have too high privileges.

create user Zoo_26_P identified by zoo -- this password should be changed on the real system
    default tablespace Users
    quota unlimited on users
/

grant connect, resource, debug connect session, debug any procedure
    to Zoo_26_P
/
grant C##_Development
    to Zoo_26_P
/

