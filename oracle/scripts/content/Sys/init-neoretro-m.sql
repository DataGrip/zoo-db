-- Creates the additional PDB named NEORETRO and leaves it never opened.
-- Such a PDB stays mounted, and its status in DBA_PDBS is NEW.
-- It is needed to test how the introspector deals with a PDB that is not open.
--
-- ATTENTION: don't open this PDB. The first opening (it's possible in the READ WRITE mode only)
-- completes the integration of the PDB into the CDB and changes the status to NORMAL forever.
--
-- Run this script being logged in as SYS in the CDB root with the role SYSDBA.
--
-- The paths are not hardcoded: different Oracle docker images keep their data
-- files in different places. The directory of the seed files is taken from
-- V$DATAFILE, and the files of the new PDB are placed into a sibling directory.
-- That's why the commands with paths are built and performed in PL/SQL blocks,
-- every such command is also printed (when SERVEROUTPUT is on).


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
    pdb_dir := substr(seed_dir, 1, instr(seed_dir, '/', -1, 2)) || 'NEORETRO/';
    --
    cmd := 'create pluggable database NEORETRO'
        || ' admin user Neoretro_Admin identified by zoo'
        || ' file_name_convert = (''' || seed_dir || ''', ''' || pdb_dir || ''')';
    --
    dbms_output.put_line(cmd);
    execute immediate cmd;
end;
/


-- Check the result

declare
    the_status varchar2(10);
begin
    select status
    into the_status
    from dba_pdbs
    where pdb_name = 'NEORETRO';
    --
    if the_status != 'NEW' then
        raise_application_error(-20004, 'The status of the PDB NEORETRO is '||the_status||' instead of NEW');
    end if;
end;
/
