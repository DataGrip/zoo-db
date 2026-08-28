create type Typ_Words as varray (1000) of varchar(26)
/

create type Typ_Strings as table of varchar(80)
/


create or replace type Typ_Person_Name as object
(
    F_Name varchar(26),
    M_Name varchar(26),
    L_Name varchar(26),
    member function Full_Name return varchar
)
/

create or replace type body Typ_Person_Name
is
    member function Full_Name return varchar(82) is
    begin
        return F_Name || ' ' || M_Name || ' ' || L_Name;
    end;
end;
/

create type Typ_Person as object (Staff_Id number(6), Name Typ_Person_Name, Gender char(1))
/

create type Typ_Personnel as table of Typ_Person
/


create table Typ_Custom_Types
(
    Id number(9) not null
        constraint Typ_Custom_Types_pk primary key,
    Words Typ_Words,
    Strings Typ_Strings,
    Personnel Typ_Personnel
)
    nested table Strings store as Typ_Custom_Types_Strings return as locator
    nested table Personnel store as Typ_Custom_Types_Personnel return as locator
/
