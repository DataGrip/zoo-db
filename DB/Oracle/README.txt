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
    - ZOO_26_Q  — in the additional multitenant PDB named BLUECHIP,
                  this schema has editions enabled (see below)
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


Additional PDBs
===============

Besides the main PDB with the Zoo schema, the multitenant database has
several additional PDBs. They contain nothing useful, they are needed
to test how the introspector deals with PDBs in unusual states.
    - NEORETRO — created but never opened; it stays mounted,
                 and its status in DBA_PDBS is NEW
    - ALTERHOF — created, opened once, closed and unplugged;
                 its status in DBA_PDBS is UNPLUGGED

Don't open NEORETRO: the first opening changes its status to NORMAL forever.

One more additional PDB is a regular open one:
    - BLUECHIP — contains the schema ZOO_26_Q with editions enabled
                 (Edition-Based Redefinition)
The editions are enabled for all editionable kinds of objects except types,
because the Zoo schema has a table with columns of user-defined types,
and a table cannot depend on an editioned object. The schema is created
by the script ./Sys/init-bluechip-p.sql, that is performed inside this PDB.

Every such PDB is created by its own script ./Sys/init-<pdb name>-m.sql,
that also checks the resulting status. The paths to the data files are not
hardcoded, because different Oracle docker images keep the files in different
places: every script takes the directory of the seed files from V$DATAFILE
and places the files of its PDB into a sibling directory.


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

A startup script should be performed by SQL*Plus on the machine where
the Oracle server is running (for a dockerized Oracle it's the container
with the server; see below why), being logged in as SYS with the SYSDBA
option. Only the startup scripts should contain commands to connect or switch
users (or containers), other script files must not switch the current user.

The scripts from ./Sys/ are performed as SYS. The scripts from ./Zoo-26/ are
performed being logged in as the owner of the Zoo schema in the regular mode,
with no administrative privileges (make-11.sql checks it).

The startup scripts include other scripts with '@@' and a path relative
to this directory, for example '@@Sys/init-database-c.sql'.
Inside a subdirectory, the scripts refer to each other by a bare name,
because SQL*Plus resolves '@@' relative to the directory of the calling script.

The scripts from ./Sys/ may also call the Oracle administrative scripts
from '$ORACLE_HOME/rdbms/admin', using the '@?' syntax, for example
'@?/rdbms/admin/utl32k.sql' ('?' means $ORACLE_HOME in SQL*Plus).
SQL*Plus resolves '?' on the machine where SQL*Plus itself runs, and the
startup scripts connect to the database via 'localhost:1521'. That's why
the startup scripts should be performed on the Oracle server machine.
