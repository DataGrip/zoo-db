-- Creates schemas for DataGrip Static Tests.
-- Run this script being logged in as SYS with the role SYSDBA.
-- We must be in the GOD mode.


-- Zoo_26_M is the schema in the CDB database
-- This schema user itself must not have too high privileges.

create user Zoo_26_M identified by zoo -- this password should be changed on the real system
    default tablespace Users
    quota unlimited on users
/

grant connect, resource, debug connect session, debug any procedure
    to Zoo_26_M
/
grant Zoo_Development
    to Zoo_26_M
/

