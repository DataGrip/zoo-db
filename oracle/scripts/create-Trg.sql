create sequence Trg_Seq
    nocache
    order
/

create table Trg_Event
(
    Id number(9) not null
        constraint Trg_Event_pk
            primary key,
    Name varchar(80),
    Created date default sysdate not null,
    Modified date
)
/

create table Trg_Archived_Event
(
    Id number(9) not null
        constraint Trg_Archived_Event_pk
            primary key,
    Name varchar(80),
    Created date not null,
    Modified date,
    Archived date default sysdate not null
)
/

create trigger Trg_Event_T01
    before insert
    on Trg_Event
begin
    null;
end;
/

create trigger Trg_Event_T02
    before insert
    on Trg_Event
    for each row
begin
    if :new.Id is null then
        begin
            select Trg_Seq.nextval
                into :new.Id
                from dual;
        end;
    end if;
end;
/

create trigger Trg_Event_T03
    after insert
    on Trg_Event
    for each row
begin
    null;
end;
/

create trigger Trg_Event_T04
    after insert
    on Trg_Event
begin
    null;
end;
/

create trigger Trg_Event_T05
    before update
    on Trg_Event
begin
    null;
end;
/

create trigger Trg_Event_T06
    before update
    on Trg_Event
    for each row
begin
    null;
end;
/

create trigger Trg_Event_T07
    after update
    on Trg_Event
    for each row
begin
    null;
end;
/

create trigger Trg_Event_T08
    after update
    on Trg_Event
begin
    null;
end;
/

create trigger Trg_Event_T09
    before delete
    on Trg_Event
begin
    null;
end;
/

create trigger Trg_Event_T10
    before delete
    on Trg_Event
    for each row
begin
    null;
end;
/

create trigger Trg_Event_T11
    after delete
    on Trg_Event
    for each row
begin
    null;
end;
/

create trigger Trg_Event_T12
    after delete
    on Trg_Event
begin
    null;
end;
/

