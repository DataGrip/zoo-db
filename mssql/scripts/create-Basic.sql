use Menagerie
go


-- The basic stuff
create sequence Zoo.Basic_01_Sequence
    start with 1
    increment by 1
    no cache
go

create table Zoo.Basic_01_Table
(
    Id int primary key default (next value for Zoo.Basic_01_Sequence),
    Name varchar(26) unique not null,
    Note varchar(80)
)
go

exec sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Unique identifier, should be always positive',
     @level0type = N'Schema', @level0name = 'Zoo',
     @level1type = N'Table', @level1name = 'Basic_01_Table',
     @level2type = N'Column', @level2name = 'Id'
go

exec sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Name of the row',
     @level0type = N'Schema', @level0name = 'Zoo',
     @level1type = N'Table', @level1name = 'Basic_01_Table',
     @level2type = N'Column', @level2name = 'Name'
go

exec sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Additional text notes or comments',
     @level0type = N'Schema', @level0name = 'Zoo',
     @level1type = N'Table', @level1name = 'Basic_01_Table',
     @level2type = N'Column', @level2name = 'Note'
go

create function Zoo.Basic_01_FormatName(@Id int, @Name varchar(26))
    returns varchar(50)
as
begin
    return concat(@Name, ' [', cast(@Id as varchar(10)), ']');
end;
go

create view Zoo.Basic_01_View
as
select Id,
       Name,
       Zoo.Basic_01_FormatName(Id, Name) as Name_with_Id,
       Note,
       len(Note) as Note_Length
from Zoo.Basic_01_Table T
go

exec sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Unique identifier, expected to be always positive',
     @level0type = N'Schema', @level0name = 'Zoo',
     @level1type = N'View', @level1name = 'Basic_01_View',
     @level2type = N'Column', @level2name = 'Id'
go

exec sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Name of the row',
     @level0type = N'Schema', @level0name = 'Zoo',
     @level1type = N'View', @level1name = 'Basic_01_View',
     @level2type = N'Column', @level2name = 'Name'
go

exec sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Formatted name with identifier in brackets',
     @level0type = N'Schema', @level0name = 'Zoo',
     @level1type = N'View', @level1name = 'Basic_01_View',
     @level2type = N'Column', @level2name = 'Name_with_Id'
go

exec sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Additional text notes or comments',
     @level0type = N'Schema', @level0name = 'Zoo',
     @level1type = N'View', @level1name = 'Basic_01_View',
     @level2type = N'Column', @level2name = 'Note'
go

exec sp_addextendedproperty
     @name = N'MS_Description',
     @value = N'Length of the Note column content in characters',
     @level0type = N'Schema', @level0name = 'Zoo',
     @level1type = N'View', @level1name = 'Basic_01_View',
     @level2type = N'Column', @level2name = 'Note_Length'
go

begin transaction
    insert into Zoo.Basic_01_Table (Name, Note)
        values ('One', 'Just the first row'),
               ('Two', 'It is the second row')
commit;
go

create procedure Zoo.Basic_01_Up @Name varchar(26),
                                 @Note varchar(80),
                                 @NewId int output
as
begin
    insert into Zoo.Basic_01_Table (Name, Note)
    values (@Name, @Note);
    select @NewId = scope_identity();
end;
go

begin transaction
    declare @id int;
    exec Zoo.Basic_01_Up @Name = 'Three', @Note = 'One more record', @NewId = @id out;
    print @id;
commit
go



-- Table with columns of different numeric types
create table Zoo.Basic_02_Numeric_Types
(
    [bit]         bit      default 0,
    [tinyint]     tinyint  default 42,
    [smallint]    smallint default 1984,
    [int]         int      default 123456789,
    [bigint]      bigint   default 1234567890,
    [decimal(1)]  decimal(1),  -- 5 bytes
    [decimal(9)]  decimal(9),
    [decimal(10)] decimal(10), -- 9 bytes
    [decimal(19)] decimal(19),
    [decimal(20)] decimal(20), -- 13 bytes
    [decimal(28)] decimal(28),
    [decimal(29)] decimal(29), -- 17 bytes
    [decimal(38)] decimal(38), -- 17 bytes
    [smallmoney]  smallmoney,
    [money]       money,
    [real]        real,
    [float(25)]   float(25)    -- 8 bytes
)
-- Table with columns of different text types
create table Zoo.Basic_03_Text_Types
(
    [char]          char         default 'A',
    [char(8)]       char(8)      default 'XyZ',
    [varchar(8)]    varchar(8)   default 'A word',
    [varchar(max)]  varchar(max),
    [text]          text,
    [nchar]         nchar        default N'Я',
    [nchar(15)]     nchar(15)    default N'Größenmaßstäbe',
    [nvarchar(15)]  nvarchar(15) default N'Fußgängerübergänge',
    [nvarchar(max)] nvarchar(max),
    [ntext]         ntext
)
-- Table with columns of different calendar types
create table Zoo.Basic_04_Calendar_Types
(
    [date]           date          default getdate(),
    [time]           time          default getdate(),
    [smalldatetime]  smalldatetime default sysdatetime(),
    [datetime]       datetime      default sysdatetime(),
    [datetime2]      datetime2     default sysdatetime(),
    [datetimeoffset] datetimeoffset,
    [timestamp]      timestamp
)
-- Table with columns of other/unsorted types
create table Zoo.Basic_05_Other_Types
(
    [uniqueidentifier] uniqueidentifier,
    [xml]              xml
)
go

-- View with all columns
create view Zoo.Basic_09_All_Types
as
select *
from Zoo.Basic_02_Numeric_Types,
     Zoo.Basic_03_Text_Types,
     Zoo.Basic_04_Calendar_Types,
     Zoo.Basic_05_Other_Types
go


-- Table with indices
create table Zoo.Basic_11_Indices
(
    F1 int,
    F2 int,
    F3 int,
    F4 int,
    F5 int,
    F6 int,
    F7 int,
    F8 int,
    F9 int,
    index Basic_11_Indices_F1_i (F1) with (fillfactor = 66),
    index Basic_11_Indices_F2_i (F2 desc),
    index Basic_11_Indices_F234_i (F2, F3 desc, F4),
    constraint Basic_11_Indices_pk primary key nonclustered (F1, F2, F3, F4),
    constraint Basic_11_Indices_ui unique (F9, F8, F7, F6) with fillfactor = 42
)
go


-- Table with basic primary key and a basic indices
create table Zoo.Basic_21_Key
(
    C0 char,
    F1 int not null,
    F2 int not null,
    F3 int not null,
    F4 int not null,
    F5 int,
    F6 int,
    F7 int,
    F8 varchar(15),
    X1 varchar(15),
    constraint Basic_21_Key_pk primary key (F1, F2),
    constraint Basic_21_Key_ak unique (F3, F4)
)
create index Basic_21_Key_i1 on Zoo.Basic_21_Key (F5, F6, F7) include (F8)
go

-- Table with non-primary cluster key and primary non-clustered key
create table Zoo.Basic_22_C
(
    C0 char,
    F1 int not null,
    F2 int not null,
    F3 int not null,
    F4 int not null,
    F5 int,
    F6 int,
    F7 int,
    X1 varchar(15)
)
create clustered index Basic_22_C_cluster on Zoo.Basic_22_C (F1, F2)
alter table Zoo.Basic_22_C
    add constraint Basic_22_C_pk primary key (F3, F4)
create index Basic_22_C_i1 on Zoo.Basic_22_C (F5, F6, F7)
go

-- Table with a serial column and foreign keys to tables 11 and 12
create table Zoo.Basic_23_ForeignKeys
(
    Id   int identity
        constraint Basic_23_ForeignKeys_pk primary key,
    A    int,
    B    int,
    C    int,
    D    int,
    E    int,
    F    int,
    Note varchar(80),
    constraint Basic_23_fk_11_a foreign key (A, B) references Zoo.Basic_21_Key,
    constraint Basic_23_fk_11_b foreign key (C, D) references Zoo.Basic_21_Key (F3, F4),
    constraint Basic_23_fk_12 foreign key (E, F) references Zoo.Basic_22_C
)
go


-- Custom types
create type Zoo.Basic_41_ISO_2 from char(2)
create type Zoo.Basic_41_ISO_3 from char(3)
go

create type Zoo.Basic_42_PersonName as table
(
    First varchar(26),
    Last varchar(26)
)
go

create type Zoo.Basic_42_Compound as table
(
    Nr tinyint,
    Code Zoo.Basic_41_ISO_2
)
go

create table Zoo.Basic_43_TableWithCustomTypes
(
    F1 int,
    F2 Zoo.Basic_41_ISO_2 not null,
    F3 Zoo.Basic_41_ISO_3
)
go

create view Zoo.Basic_43_ViewWithCustomTypes
as
select T.*
from Zoo.Basic_43_TableWithCustomTypes T
go


create table Zoo.Basic_51_TableWithTriggers
(
    Id int not null primary key,
    Name varchar(26),
    Note varchar(100),
    Version int default 0
)
go

create trigger Zoo.Basic_51_TableWithTriggers_1
    on Zoo.Basic_51_TableWithTriggers
    after insert
    not for replication
as
begin
    update Basic_51_TableWithTriggers
    set Version = 1
    where Id in (select Id from inserted)
end
go

create trigger Zoo.Basic_51_TableWithTriggers_2
    on Zoo.Basic_51_TableWithTriggers
    after update
    not for replication
as
begin
    update Basic_51_TableWithTriggers
    set Version = Version + 1
    where Id in (select Id from inserted)
end
go

create trigger Zoo.Basic_51_TableWithTriggers_3
    on Zoo.Basic_51_TableWithTriggers
    after delete
    not for replication
as
begin
    select 42
end
go

create trigger Zoo.Basic_51_TableWithTriggers_4_IUD
    on Zoo.Basic_51_TableWithTriggers
    after insert, update, delete
    not for replication
as
begin
    select 74
end
go


create synonym Zoo.Basic_Synonym_1_for_Table for Zoo.Basic_01_Table
create synonym Zoo.Basic_Synonym_2_for_View for Zoo.Basic_01_View
go
