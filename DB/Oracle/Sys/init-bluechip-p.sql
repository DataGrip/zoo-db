-- Creates the schema with editions (Edition-Based Redefinition) in the PDB BLUECHIP.
-- Run this script being logged in as SYS with the role SYSDBA,
-- with the session already switched to the PDB BLUECHIP.


-- Zoo_26_Q is the schema where all objects are placed.
-- This schema user itself must not have too high privileges.

create user Zoo_26_Q identified by zoo -- this password should be changed on the real system
    default tablespace Users
    quota unlimited on users
/

grant connect, resource, debug connect session, debug any procedure
    to Zoo_26_Q
/
grant C##_Development
    to Zoo_26_Q
/


-- Enable editions for this schema.
-- ATTENTION: this change is irreversible.
--
-- The editions are enabled for all editionable kinds of objects except
-- TYPE and TYPE BODY: a table is never editioned, and a non-editioned object
-- cannot depend on an editioned one (ORA-38818), but the Zoo schema has
-- a table with columns of the user-defined types.
--
-- PACKAGE BODY cannot be listed here (ORA-00922),
-- a package body follows its package specification.

alter user Zoo_26_Q
    enable editions for view, synonym, procedure, function, package, trigger, library
/


-- Check the result

declare
    cnt number;
begin
    select count(*)
    into cnt
    from dba_editioned_types
    where schema = 'ZOO_26_Q'
      and object_type = 'VIEW';
    --
    if cnt = 0 then
        raise_application_error(-20008, 'Editions are not enabled for views of the schema ZOO_26_Q');
    end if;
    --
    select count(*)
    into cnt
    from dba_editioned_types
    where schema = 'ZOO_26_Q'
      and object_type in ('TYPE', 'TYPE BODY');
    --
    if cnt > 0 then
        raise_application_error(-20009, 'Editions are unexpectedly enabled for types of the schema ZOO_26_Q');
    end if;
end;
/
