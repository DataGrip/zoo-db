This directory contains SQL script for preparing Oracle databases
and creating test schemas.


Test Schemas
============

Every database has a schema ZOO with all objects and options
which are supported by our DataGrip (database model and introspector).
Schema names:
    - ZOO_26    — in the classic database
    - ZOO_26_M  — in the multitenant CDB
    - ZOO_26_P  — in the multitenant PDB
Number 26 is the year when this schema was originated;
we'll be able to create another Zoo schema if we decide
that the current one is too wrong.
However, right now we don't plan to create a new schema every year,
we're going to use and extend this schema next several yeras.

Several users which should be used in tests. The introspector should
log in as one of these several users and introspect the Zoo schema.
The usernames depend on the Oracle installation type, because Oracle
requires adding the strange prefix 'C##' for their "common" user accounts.
    — [C##_]Tourist_A — has regular permissions
    — [C##_]Tourist_C — has the role "SELECT_CATALOG_ROLE"
    — [C##_]Tourist_D — has the permission "SELECT ANY DICTIONARY"
    — [C##_]Tourist_S — has both of the two previous (deprecated)


Naming Convention
=================


Files Naming
------------

Name example: <what>-<ver><t>-<sa>.sql
Where:   what — what this script does (create, init, make, grant, zap, etc.)
         ver  — version of the DBMS this script is applicable to
         t    — optional suffix determining the database type:
                        c - classic (non-CDB)
                        m - multitenant, CDB
                        p - multitenant, PDB
                        w - autonomous database in the Cloud (w because the Web)
         sa   — optional subject area

Don't use dots inside file names.


Files
-----

There is one startup file for each version and type of Oracle installation,
it's named 'create-*.sql'. This script should be performed being logged in
as SYS with the SYSDBA option. Only this file should contain commands to
connect or switch users, other script files must not switch the current user.

