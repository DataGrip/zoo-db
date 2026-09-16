-- C##_Tourist_* are the common users that will be used to access the database from tests.
-- They should be useful in both CDB and PDB databases.
-- This user can only read data, execute procedures and access catalogs.
-- The difference between different C##_Tourist_* users is the privileges what kind of catalogs they could access.

create role C##_Tourismus
    container = all
/

create user C##_Tourist_A
    identified by tour
    container = all
/
create user C##_Tourist_C
    identified by tour
    container = all
/
create user C##_Tourist_D
    identified by tour
    container = all
/


grant connect, debug connect session, debug any procedure
    to C##_Tourist_A, C##_Tourist_C, C##_Tourist_D
    container = all
/

grant C##_Tourismus
    to C##_Tourist_A, C##_Tourist_C, C##_Tourist_D
    container = all
/

grant select_catalog_role
    to C##_Tourist_C
    container = all
/
grant select any dictionary
    to C##_Tourist_D
    container = all
/

