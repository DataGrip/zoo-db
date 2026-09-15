create table Typ_Basic_Types
(
    "char"             char,
    "char(1)"          char(1),
    "char(1 byte)"     char(1 byte),
    "char(1 char)"     char(1 char),
    "char(10)"         char(10),
    "char(10 byte)"    char(10 byte),
    "char(10 char)"    char(10 char),
    "varchar(1)"       varchar(1),
    "varchar(1 byte)"  varchar(1 byte),
    "varchar(1 char)"  varchar(1 char),
    "varchar(10)"      varchar(10),
    "varchar(10 byte)" varchar(10 byte),
    "varchar(10 char)" varchar(10 char),
    "nchar"            nchar,
    "nchar(1)"         nchar(1),
    "nchar(10)"        nchar(10),
    "nvarchar2(1)"     nvarchar2(1),
    "nvarchar2(10)"    nvarchar2(10),
    "number"           number,
    "number(1)"        number(1),
    "number(15,3)"     number(15, 3),
    "number(6,-3)"     number(6, -3),
    "number(38)"       number(38),
    "float"            float,
    "float(1)"         float(1),
    "float(126)"       float(126),
    "binary_float"     binary_float,
    "binary_double"    binary_double,
    "raw(1)"           raw(1),
    "raw(2000)"        raw(2000),
    "rowid"            rowid,
    "urowid"           urowid
)
/

create table Typ_Calendar_Types
(
    "date"                           date,
    "timestamp(0)"                   timestamp(0),
    "timestamp(3)"                   timestamp(3),
    "timestamp(9)"                   timestamp(9),
    "timestamp(0) with time zone"    timestamp(0) with time zone,
    "timestamp(3) with time zone"    timestamp(3) with time zone,
    "timestamp(9) with time zone"    timestamp(9) with time zone,
    "timestamp with local time zone" timestamp with local time zone,
    "interval year(4) to month"      interval year(4) to month,
    "interval day(5) to second(4)"   interval day(5) to second(4)
)
/

create table Typ_Lob_Types
(
    "clob"  clob,
    "nclob" nclob,
    "blob"  blob,
    "bfile" bfile,
    "long"  long
)
/

create table Typ_X_Types
(
    "xmltype"     xmltype,
    "uritype"     uritype,
    "dburitype"   dburitype,
    "xdburitype"  xdburitype,
    "httpuritype" httpuritype,
    "anytype"     anytype,
    "anydata"     anydata,
    "anydataset"  anydataset
)
/
