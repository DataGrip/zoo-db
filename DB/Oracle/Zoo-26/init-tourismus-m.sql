-- Tourist_* are the common users that will be used to access the database from tests.
-- They should be useful in both CDB and PDB databases.
-- This user can only read data, execute procedures and access catalogs.
-- The difference between different Tourist_* users is the privileges what kind of catalogs they could access.

create role Tourismus
    container = all
/

create user Tourist_A
    identified by tour
    container = all
/
create user Tourist_C
    identified by tour
    container = all
/
create user Tourist_D
    identified by tour
    container = all
/


grant connect, debug connect session, debug any procedure
    to Tourist_A, Tourist_C, Tourist_D
    container = all
/

grant Tourismus
    to Tourist_A, Tourist_C, Tourist_D
    container = all
/

grant select_catalog_role
    to Tourist_C
    container = all
/
grant select any dictionary
    to Tourist_D
    container = all
/

