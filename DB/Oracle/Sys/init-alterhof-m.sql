-- Creates the additional PDB named ALTERHOF and unplugs it.
-- The status of such a PDB in DBA_PDBS is UNPLUGGED, the only operation
-- that can be performed on it is DROP PLUGGABLE DATABASE.
-- It is needed to test how the introspector deals with an unplugged PDB.
--
-- Run this script being logged in as SYS in the CDB root with the role SYSDBA.
--
-- The paths are hardcoded, they match our Oracle 12.2 multitenant docker image.
-- The actual path to the seed files can be checked with the query:
--     select name from v$datafile where con_id = 2


create pluggable database ALTERHOF
    admin user Alterhof_Admin identified by zoo
    file_name_convert = ('/u02/app/oracle/oradata/ORCL/pdbseed/',
                         '/u02/app/oracle/oradata/ORCL/ALTERHOF/')
/


-- A PDB that has never been opened cannot be unplugged,
-- so open it once (it changes the status from NEW to NORMAL) and close it back.

alter pluggable database ALTERHOF open read write
/

alter pluggable database ALTERHOF close immediate
/


-- Unplug the PDB; the manifest file must not exist yet

alter pluggable database ALTERHOF
    unplug into '/u02/app/oracle/oradata/ORCL/ALTERHOF/alterhof.xml'
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
