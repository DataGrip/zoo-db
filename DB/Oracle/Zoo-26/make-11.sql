-- Check the schema is empty.
declare
    dummy number;
begin
    select 1
    into dummy
    from user_objects
    where rownum = 1;
    --
    raise_application_error(-20000, 'Schema is not empty');
    --
exception
    when no_data_found then
        null; -- Schema is empty.
end;
/


@@make-11-Bur.sql
@@make-11-Typ-1.sql
@@make-11-Typ-2.sql
@@make-11-Pro.sql
@@make-11-Prb.sql
@@make-11-Trg.sql
@@make-11-Plenty.sql

