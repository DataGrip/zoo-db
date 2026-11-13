-- Grants the read-only access to the Tourismus role.
-- Run this script being logged in as the owner of a Zoo schema.
--
-- The role name depends on the installation type: in a multitenant database
-- the role is common and therefore carries the C## prefix, while in a classic
-- one it has no prefix. USERENV.CON_ID tells these cases apart:
-- it is 0 in a non-CDB, 1 in CDB$ROOT, and 3 or greater in a PDB.
-- On Oracle 11 this attribute doesn't exist yet, and asking for it fails
-- with ORA-02003; this error means a classic database as well.
declare
    invalid_userenv_parameter exception;
    pragma exception_init (invalid_userenv_parameter, -2003);
    con_id    string(40);
    role_name string(128);
    cmd       string(200);
begin
    begin
        con_id := sys_context('userenv', 'con_id');
    exception
        when invalid_userenv_parameter then
            con_id := null;
    end;
    --
    if con_id is null or con_id = '0' then
        role_name := 'Tourismus';
    else
        role_name := 'C##_Tourismus';
    end if;
    --
    for r in ( select object_name
               from user_objects
               where object_type in ('MATERIALIZED VIEW','VIEW','SEQUENCE') )
        loop
            cmd := 'grant select on '||r.object_name||' to '||role_name;
            execute immediate cmd;
        end loop;
    for r in ( select table_name
               from user_tables
               where nested = 'NO' )
        loop
            cmd := 'grant select on '||r.table_name||' to '||role_name;
            execute immediate cmd;
        end loop;
    for r in ( select object_name
               from user_objects
               where object_type in ('PACKAGE','PROCEDURE','FUNCTION') )
        loop
            cmd := 'grant execute on '||r.object_name||' to '||role_name;
            execute immediate cmd;
        end loop;
end;
/
