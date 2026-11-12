-- Creates the additional PDB named BLUECHIP and opens it.
-- This PDB is intended for the schema with editions (Edition-Based Redefinition),
-- the schema itself is created by the script init-bluechip-p.sql.
--
-- Run this script being logged in as SYS in the CDB root with the role SYSDBA.
--
-- The paths are not hardcoded: different Oracle docker images keep their data
-- files in different places. The directory of the seed files is taken from
-- V$DATAFILE, and the files of the new PDB are placed into a sibling directory.
-- That's why the commands with paths are built and performed in PL/SQL blocks,
-- every such command is also printed (when SERVEROUTPUT is on).


-- The seed has no tablespace for user data, so the tablespace Users is created here.

declare
    seed_file varchar2(513);
    seed_dir  varchar2(513);
    pdb_dir   varchar2(513);
    cmd       varchar2(2000);
begin
    -- for example: /opt/oracle/oradata/ORCLCDB/pdbseed/system01.dbf
    select name
    into seed_file
    from v$datafile
    where con_id = 2
      and rownum = 1;
    --
    -- the seed directory, with the trailing slash
    seed_dir := substr(seed_file, 1, instr(seed_file, '/', -1));
    -- the sibling directory: cut the last directory name off and add the new one
    pdb_dir := substr(seed_dir, 1, instr(seed_dir, '/', -1, 2)) || 'BLUECHIP/';
    --
    cmd := 'create pluggable database BLUECHIP'
        || ' admin user Bluechip_Admin identified by zoo'
        || ' default tablespace Users'
        || ' datafile ''' || pdb_dir || 'users01.dbf'''
        || ' size 16m autoextend on next 16m'
        || ' file_name_convert = (''' || seed_dir || ''', ''' || pdb_dir || ''')';
    --
    dbms_output.put_line(cmd);
    execute immediate cmd;
end;
/

alter pluggable database BLUECHIP open read write
/

-- Make the PDB be opened automatically when the CDB starts

alter pluggable database BLUECHIP save state
/

-- Register the service of the new PDB in the listener right now,
-- because the startup script connects to this PDB via the listener.

alter system register
/


-- Check the result

declare
    the_status varchar2(10);
    the_mode   varchar2(10);
begin
    select status
    into the_status
    from dba_pdbs
    where pdb_name = 'BLUECHIP';
    --
    if the_status != 'NORMAL' then
        raise_application_error(-20006, 'The status of the PDB BLUECHIP is '||the_status||' instead of NORMAL');
    end if;
    --
    select open_mode
    into the_mode
    from v$pdbs
    where name = 'BLUECHIP';
    --
    if the_mode != 'READ WRITE' then
        raise_application_error(-20007, 'The open mode of the PDB BLUECHIP is '||the_mode||' instead of READ WRITE');
    end if;
end;
/
