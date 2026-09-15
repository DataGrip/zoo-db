-- Creates schemas for DataGrip Static Tests.
-- Run this script being logged in as SYS with the role SYSDBA.


-- Zoo_26 is the schema where all objects are placed.
-- This schema should not be accessed from tests directly (by logging in), only through the

create user Zoo_26 identified by zoo -- this password should be changed on the real system
    default tablespace Users quota unlimited on users
/

grant connect, resource to Zoo_26
/
grant Zoo_Development to Zoo_26
/


-- Tourist_* are the users that will be used to access the database from tests.
-- This user can only read data, execute procedures and access catalogs.
-- The difference between different Tourist_* users is the privileges what kind of catalogs they could access.

create role Tourismus
/

create user Tourist_A identified by tour  
/
create user Tourist_C identified by tour
/
create user Tourist_D identified by tour
/
create user Tourist_S identified by tour
/


grant connect, debug connect session, debug any procedure
    to Tourist_A, Tourist_C, Tourist_D, Tourist_S
/

grant Tourismus to Tourist_A, Tourist_C, Tourist_D, Tourist_S
/

grant select_catalog_role to Tourist_C, Tourist_S
/
grant select any dictionary to Tourist_D, Tourist_S
/

