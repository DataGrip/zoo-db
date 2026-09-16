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
create user Tourist_S identified by tour  -- deprecated
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

