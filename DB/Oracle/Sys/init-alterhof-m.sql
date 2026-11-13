-- Creates the additional PDB named ALTERHOF and unplugs it.
-- The status of such a PDB in DBA_PDBS is UNPLUGGED, the only operation
-- that can be performed on it is DROP PLUGGABLE DATABASE.
-- It is needed to test how the introspector deals with an unplugged PDB.
--
-- Run this script being logged in as SYS in the CDB root with the role SYSDBA.
--
-- The paths to the data files are hardcoded, they are the paths of our docker image:
-- the seed files are in /opt/oracle/oradata/ORCLCDB/pdbseed/, and the files
-- of the new PDB are placed into a sibling directory.


create pluggable database ALTERHOF
    admin user Alterhof_Admin identified by zoo
    file_name_convert = ('/opt/oracle/oradata/ORCLCDB/pdbseed/',
                         '/opt/oracle/oradata/ORCLCDB/ALTERHOF/')
/


-- A PDB that has never been opened cannot be unplugged,
-- so open it once (it changes the status from NEW to NORMAL) and close it back.

alter pluggable database ALTERHOF open read write
/

alter pluggable database ALTERHOF close immediate
/


-- Unplug the PDB; the manifest file must not exist yet.
-- The manifest is placed into the directory of the PDB.

alter pluggable database ALTERHOF
    unplug into '/opt/oracle/oradata/ORCLCDB/ALTERHOF/alterhof.xml'
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
