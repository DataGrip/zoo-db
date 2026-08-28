create cluster Bur_Face_Cluster (Id number(9))
    size 256
    index
/

create index Bur_Face_Cluster_i
    on cluster Bur_Face_Cluster
/

create sequence Bur_Face_seq
    start with 1001
    nocache order
/

create table Bur_Face
(
    Id number(9) not null
        constraint Bur_Face_pk
            primary key,
    Display_Name varchar(80) not null,
    Note varchar(80),
    Status decimal(1) default 0
        constraint Bur_Face_Status_ch
            check (Status between -1 and 9),
    Created date default sysdate not null,
    Modified date
)   cluster Bur_Face_Cluster (Id)
/

comment on table Bur_Face is 'The base entity of an organisation or a person'
/

create table Bur_Org
(
    Id number(9) not null
        constraint Bur_Org_Face_fk
            references Bur_Face
                on delete cascade
        constraint Bur_Org_pk primary key,
    Brand_Name varchar(80),
    Legal_Name varchar(80),
    constraint Bur_Org_Name_ch
        check (Brand_Name is not null or Legal_Name is not null)
)   cluster Bur_Face_Cluster (Id)
/

comment on table Bur_Org is 'Organization'
/

create table Bur_Person
(
    Id number(9) not null
        constraint Bur_Person_Face_fk
            references Bur_Face
                on delete cascade
        constraint Bur_Person_pk primary key,
    F_Name varchar(26),
    L_Name varchar(26),
    Born date
        constraint Bur_Person_Born_ch
            check (trunc(Born) = Born),
    Sex char(1)
        constraint Bur_Person_Sex_ch
            check (Sex in ('F','M')),
    constraint Bur_Person_Name_ch 
        check (F_Name is not null or L_Name is not null)
)   cluster Bur_Face_Cluster (Id)
/

comment on table Bur_Person is 'Person'
/

create trigger Bur_Face_tbi
    before insert on Bur_Face
    for each row
    when (new.Id is null)
begin
    select Bur_Face_seq.nextval
    into :new.Id
    from dual;
end;
/

create view Bur_Org_Brief as
select Id,
       Display_Name,
       Brand_Name,
       Legal_Name,
       Note,
       Status,
       Created,
       Modified
from Bur_Face
     natural join Bur_Org
where Status >= 0
/

comment on table Bur_Org_Brief is
'Organization, all brief attributes.
Scope: all organizations.'
/

create view Bur_Person_Brief as
select Id,
       Display_Name,
       F_Name,
       L_Name,
       Born,
       Sex,
       Note,
       Status,
       Created,
       Modified
from Bur_Face
     natural join Bur_Person
where Status >= 0
/

comment on table Bur_Person_Brief is
'Person, all brief attributes.
Scope: all people.'
/

