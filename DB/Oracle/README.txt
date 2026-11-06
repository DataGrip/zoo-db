This directory contains SQL scripts for preparing Oracle databases
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

The scripts are split into three parts:

    ./create-*.sql — startup scripts, one for each version and type
                     of Oracle installation;
    ./Sys/         — scripts that change system objects: set up the database,
                     create roles, users and (empty) schemas;
    ./Zoo-26/      — scripts that create objects inside the Zoo schema,
                     and grant access to them.

A startup script should be performed being logged in as SYS with the SYSDBA
option. Only the startup scripts should contain commands to connect or switch
users (or containers), other script files must not switch the current user.

The scripts from ./Sys/ are performed as SYS. The scripts from ./Zoo-26/ are
performed being logged in as the owner of the Zoo schema in the regular mode,
with no administrative privileges (make-11.sql checks it).

The startup scripts include other scripts with '@@' and a path relative
to this directory, for example '@@Sys/init-database-c.sql'.
Inside a subdirectory, the scripts refer to each other by a bare name,
because SQL*Plus resolves '@@' relative to the directory of the calling script.

