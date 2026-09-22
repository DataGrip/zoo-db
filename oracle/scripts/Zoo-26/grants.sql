-- Grants the read-only access to the Tourismus role.
-- Run this script being logged in as the owner of a Zoo schema.
--
-- The role name depends on the installation type: in a multitenant database
-- the role is common and therefore carries the C## prefix, while in a classic
-- one it has no prefix. USERENV.CON_ID tells these cases apart:
-- it is 0 in a non-CDB, 1 in CDB$ROOT, and 3 or greater in a PDB
-- (and it is null on Oracle 11, where this attribute doesn't exist yet).
declare
    con_id    constant string(40)  := sys_context('userenv', 'con_id');
    role_name constant string(128) := case when con_id is null or con_id = '0'
                                           then 'Tourismus'
                                           else 'C##_Tourismus'
                                      end;
    cmd string(200);
begin
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
