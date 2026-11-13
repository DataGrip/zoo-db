-- Creates the additional PDB named NEORETRO and leaves it never opened.
-- Such a PDB stays mounted, and its status in DBA_PDBS is NEW.
-- It is needed to test how the introspector deals with a PDB that is not open.
--
-- ATTENTION: don't open this PDB. The first opening (it's possible in the READ WRITE mode only)
-- completes the integration of the PDB into the CDB and changes the status to NORMAL forever.
--
-- Run this script being logged in as SYS in the CDB root with the role SYSDBA.
--
-- The paths to the data files are hardcoded, they are the paths of our docker image:
-- the seed files are in /opt/oracle/oradata/ORCLCDB/pdbseed/, and the files
-- of the new PDB are placed into a sibling directory.


create pluggable database NEORETRO
    admin user Neoretro_Admin identified by zoo
    file_name_convert = ('/opt/oracle/oradata/ORCLCDB/pdbseed/',
                         '/opt/oracle/oradata/ORCLCDB/NEORETRO/')
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
