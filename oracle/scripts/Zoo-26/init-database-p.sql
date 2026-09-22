-- Tunes the PDB database a bit.

grant create cluster,
    create sequence,
    create type,
    create table,
    create view,
    create materialized view,
    create trigger,
    create procedure,
    create operator,
    create indextype,
    create dimension,
    create database link,
    create synonym
    to C##_Development
/


-- Remove the restrictions that are set by default and aro not needed for the tests.

alter profile default
    limit password_life_time unlimited
/

alter profile default
    limit failed_login_attempts unlimited
    password_life_time unlimited
/

alter profile default
    limit password_verify_function null
/

