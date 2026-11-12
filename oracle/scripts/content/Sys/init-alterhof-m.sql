-- Creates the additional PDB named ALTERHOF and unplugs it.
-- The status of such a PDB in DBA_PDBS is UNPLUGGED, the only operation
-- that can be performed on it is DROP PLUGGABLE DATABASE.
-- It is needed to test how the introspector deals with an unplugged PDB.
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
    pdb_dir := substr(seed_dir, 1, instr(seed_dir, '/', -1, 2)) || 'ALTERHOF/';
    --
    cmd := 'create pluggable database ALTERHOF'
        || ' admin user Alterhof_Admin identified by zoo'
        || ' file_name_convert = (''' || seed_dir || ''', ''' || pdb_dir || ''')';
    --
    dbms_output.put_line(cmd);
    execute immediate cmd;
end;
/


-- A PDB that has never been opened cannot be unplugged,
-- so open it once (it changes the status from NEW to NORMAL) and close it back.

alter pluggable database ALTERHOF open read write
/

alter pluggable database ALTERHOF close immediate
/


-- Unplug the PDB; the manifest file must not exist yet.
-- The manifest is placed into the directory of the PDB, that is found the same way as above.

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
    pdb_dir := substr(seed_dir, 1, instr(seed_dir, '/', -1, 2)) || 'ALTERHOF/';
    --
    cmd := 'alter pluggable database ALTERHOF'
        || ' unplug into ''' || pdb_dir || 'alterhof.xml''';
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
    where pdb_name = 'ALTERHOF';
    --
    if the_status != 'UNPLUGGED' then
        raise_application_error(-20005, 'The status of the PDB ALTERHOF is '||the_status||' instead of UNPLUGGED');
    end if;
end;
/
