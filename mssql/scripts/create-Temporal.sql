use Menagerie
go


create table Zoo.Tempo_A
(
    Id int primary key,
    Note varchar(40),
    Period_Begin datetime2 generated always as row start not null,
    Period_End datetime2 generated always as row end not null,
    period for system_time (Period_Begin, Period_End)
)
with
(
    system_versioning = on (history_table = Zoo.Tempo_A_History)
)
go

create table Zoo.Tempo_B
(
    Id int primary key,
    Note varchar(40),
    Period_Begin datetime2 generated always as row start hidden not null,
    Period_End datetime2 generated always as row end hidden not null,
    period for system_time (Period_Begin, Period_End)
)
with
(
    system_versioning = on (history_table = Zoo.Tempo_B_History)
)
go

create table Zoo.Tempo_C
(
    Id int,
    Note varchar(40),
    Period_C_Begin datetime2 generated always as row start hidden,
    Period_C_End datetime2 generated always as row end hidden,
    period for system_time (Period_C_Begin, Period_C_End)
)
go

create table Zoo.Tempo_D
(
    Id int primary key,
    Name varchar(26) not null,
    Note varchar(40),
    Period_D_Begin datetime2 generated always as row start hidden,
    Period_D_End datetime2 generated always as row end hidden,
    period for system_time (Period_D_Begin, Period_D_End)
)
with
(
    system_versioning = on
)
go

