declare
    cmd string(120);
begin
    for r in ( select object_name
               from user_objects
               where object_type in ('MATERIALIZED VIEW','VIEW','SEQUENCE') )
        loop
            cmd := 'grant select on '||r.object_name||' to Guest, Guest_AC, Guest_AD, Guest_AX';
            execute immediate cmd;
        end loop;
    for r in ( select table_name
               from user_tables
               where nested = 'NO' )
        loop
            cmd := 'grant select on '||r.table_name||' to Guest, Guest_AC, Guest_AD, Guest_AX';
            execute immediate cmd;
        end loop;
    for r in ( select object_name
               from user_objects
               where object_type in ('PACKAGE','PROCEDURE','FUNCTION') )
        loop
            cmd := 'grant execute on '||r.object_name||' to Guest, Guest_AC, Guest_AD, Guest_AX';
            execute immediate cmd;
        end loop;
end;
/
