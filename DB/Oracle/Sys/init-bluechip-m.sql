-- Creates the additional PDB named BLUECHIP and opens it.
-- This PDB is intended for the schema with editions (Edition-Based Redefinition),
-- the schema itself is created by the script init-bluechip-p.sql.
--
-- Run this script being logged in as SYS in the CDB root with the role SYSDBA.
--
-- The paths to the data files are hardcoded, they are the paths of our docker image:
-- the seed files are in /opt/oracle/oradata/ORCLCDB/pdbseed/, and the files
-- of the new PDB are placed into a sibling directory.


-- The seed has no tablespace for user data, so the tablespace Users is created here.

create pluggable database BLUECHIP
    admin user Bluechip_Admin identified by zoo
    default tablespace Users
        datafile '/opt/oracle/oradata/ORCLCDB/BLUECHIP/users01.dbf'
        size 16m autoextend on next 16m
    file_name_convert = ('/opt/oracle/oradata/ORCLCDB/pdbseed/',
                         '/opt/oracle/oradata/ORCLCDB/BLUECHIP/')
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
