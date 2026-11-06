-- Switches the current PDB to the extended data types (MAX_STRING_SIZE = EXTENDED),
-- so VARCHAR2, NVARCHAR2 and RAW columns can be up to 32767 bytes long.
-- The CDB root and other PDBs are not affected.
--
-- ATTENTION: this change is irreversible.
--
-- Run this script being logged in as SYS with the SYSDBA role,
-- with the session already switched to the PDB.
-- The script closes and reopens the current PDB, but doesn't switch the container.
--
-- The scripts utl32k.sql and utlrp.sql are called from the Oracle home
-- ('?' means $ORACLE_HOME in SQL*Plus), so this script should be run
-- by SQL*Plus on the database server itself (inside the container).


-- Check that the session is in a PDB:
-- CON_ID is 0 in a non-CDB, 1 in the CDB root, 2 in the seed, and 3+ in a PDB.
declare
    con_id   number        := to_number(sys_context('userenv', 'con_id'));
    con_name varchar2(128) := sys_context('userenv', 'con_name');
begin
    if sys_context('userenv', 'isdba') != 'TRUE' then
        raise_application_error(-20001, 'The session is not authenticated as SYSDBA');
    end if;
    if con_id < 3 then
        raise_application_error(-20002, 'The current container '||con_name||' is not a PDB');
    end if;
end;
/


-- Reopen the PDB in the UPGRADE mode

alter pluggable database close immediate
/

alter pluggable database open upgrade
/


-- Change the parameter; in a PDB it is stored at the PDB level

alter system set max_string_size = extended scope = both
/


-- Invalidate and recompile the objects that depend on the string lengths.
-- The Oracle scripts may change the WHENEVER settings,
-- so they are restored after every such call.

@?/rdbms/admin/utl32k.sql

whenever oserror exit failure
whenever sqlerror exit sql.sqlcode

-- utl32k.sql turns the GOD mode on ("_oracle_script" = true) and leaves it so.
-- In this mode the next scripts fail on the common role C##_Development
-- with ORA-65040, so turn it off.

alter session set "_oracle_script" = false
/


-- Reopen the PDB in the normal mode

alter pluggable database close immediate
/

alter pluggable database open
/


-- Recompile everything that became invalid

@?/rdbms/admin/utlrp.sql

whenever oserror exit failure
whenever sqlerror exit sql.sqlcode


-- Check the result

declare
    the_value varchar2(30);
begin
    select value
    into the_value
    from v$parameter
    where name = 'max_string_size';
    --
    if the_value != 'EXTENDED' then
        raise_application_error(-20003, 'MAX_STRING_SIZE is '||the_value||' instead of EXTENDED');
    end if;
end;
/
