-- Creates schemas for DataGrip Static Tests.
-- Run this script being logged in as SYS with the role SYSDBA.


-- Zoo_26 is the schema where all objects are placed.
-- This schema user itself must not have too high privileges.

create user Zoo_26 identified by zoo -- this password should be changed on the real system
    default tablespace Users
    quota unlimited on users
/

grant connect, resource, debug connect session, debug any procedure
    to Zoo_26
/
grant Zoo_Development
    to Zoo_26
/

