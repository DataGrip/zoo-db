-- run this script being logged in the master database
use master
go

-- DATABASE
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

-- LOGINS
create login Curator
    with password = 'chap',
         check_policy = OFF,
         default_database = Menagerie
go

create login Tourist
    with password = 'tour',
         check_policy = OFF,
         check_expiration = OFF,
         default_database = Menagerie
go


-- ENTER into the database MENAGERIE
use Menagerie
go

exec sp_addextendedproperty @name='Caption', @value=N'Zoopark'
exec sp_addextendedproperty @name='Note', @value=N'A lot of different objects'
exec sp_addextendedproperty @name=N'MS_Description', @value=N'DataGrip Static Tests Database'
go


-- User Curator
create user Curator from login Curator
go

exec sp_addrolemember 'db_ddladmin', 'Curator'
exec sp_addrolemember 'db_datareader', 'Curator'
exec sp_addrolemember 'db_datawriter', 'Curator'
go

create schema Zoo authorization Curator
go

alter user Curator with default_schema = Zoo
go

grant showplan to Curator
go

-- User Tourist
create user Tourist
    from login Tourist
    with default_schema = Zoo
go

exec sp_addrolemember 'db_datareader', 'Tourist'
go

