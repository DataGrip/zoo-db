-- run this script being logged in the master database
use master
go

create database Menagerie
    on primary (name = 'Menagerie',
                filename = '/var/opt/mssql/data/Menagerie.mdf',
                size = 8192kb,
                filegrowth = 65536kb)
    log on (name = 'Menagerie_log',
            filename = '/var/opt/mssql/data/Menagerie_log.ldf',
            size = 8192kb,
            filegrowth = 65536kb)
go

alter database Menagerie set
    recovery simple
go

create login Curator with password = 'chap', check_policy = OFF
go

use Menagerie
go

create user Curator from login Curator
go

exec sp_addrolemember 'db_ddladmin', 'Curator'
exec sp_addrolemember 'db_datareader', 'Curator'
exec sp_addrolemember 'db_datawriter', 'Curator'
go

exec sp_addextendedproperty @name='Caption', @value=N'Zoopark'
exec sp_addextendedproperty @name='Note', @value=N'A lot of different objects'
exec sp_addextendedproperty @name=N'MS_Description', @value=N'DataGrip Static Tests Database'
go

create schema Zoo authorization Curator
go

alter user Curator with default_schema = Zoo
go

grant showplan to Curator
go
