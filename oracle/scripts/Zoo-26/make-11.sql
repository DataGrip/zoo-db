-- Creates schema objects.
-- We should be logged in to the schema in the regular (not GOD) mode
-- with NO high privileges; here we're creating only schema objects.

-- Check no GOD mode.
-- The GOD mode parameter itself ("_ORACLE_SCRIPT") can be read via X$ tables only,
-- which are not accessible to a regular schema owner; so instead we check
-- that this session has no administrative privileges at all.
-- Note: the schema owner is granted DEBUG ANY PROCEDURE, so it's not a stopper.
declare
    admin_role varchar2(30);
    admin_priv varchar2(40);
begin
    if sys_context('userenv', 'isdba') = 'TRUE' then
        raise_application_error(-20001, 'The session is authenticated as SYSDBA');
    end if;
    --
    begin
        select role
        into admin_role
        from session_roles
        where role in ('DBA', 'PDB_DBA', 'SYSDBA', 'SYSOPER')
          and rownum = 1;
        --
        raise_application_error(-20002, 'The session has the administrative role '||admin_role);
        --
    exception
        when no_data_found then
            null; -- no administrative role is enabled
    end;
    --
    begin
        select privilege
        into admin_priv
        from session_privs
        where privilege like '%ANY%'
          and privilege not like 'DEBUG %'
          and rownum = 1;
        --
        raise_application_error(-20003, 'The session has the privilege '||admin_priv);
        --
    exception
        when no_data_found then
            null; -- no ANY privilege is enabled
    end;
end;
/

-- Check the current schema name starts with ZOO.
-- The session user must be the schema owner itself, because the checks
-- and the grants below rely on the USER_* views, which always refer
-- to the session user and ignore the CURRENT_SCHEMA setting.
declare
    the_user   varchar2(128) := sys_context('userenv', 'session_user');
    the_schema varchar2(128) := sys_context('userenv', 'current_schema');
begin
    if the_schema not like 'ZOO%' then
        raise_application_error(-20004, 'The current schema '||the_schema||' is not a Zoo schema');
    end if;
    if the_user != the_schema then
        raise_application_error(-20005, 'The session user '||the_user||' is not the owner of the current schema '||the_schema);
    end if;
end;
/

-- Check the schema is empty
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

