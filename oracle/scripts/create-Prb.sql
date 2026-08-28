-- PROBLEM WITH CLUSTER COLUMNS --

-- 1 - columns with same names and same positions

create cluster Prb_Shaft (X number(4), Y number(4))
    size 64
/

create index Prb_Shaft_i
    on cluster Prb_Shaft
/

create table Prb_Shaft
(
    X number(4),
    Y number(4),
    Z number(4),
    Note varchar(60)
) cluster Prb_Shaft (X, Y)
/


-- 2 - columns with different names but same positions

create cluster Prb_Field (Location_Nr number(5))
    size 40
/

create index Prb_Field_i
    on cluster Prb_Field
/

create table Prb_Field
(
    Loc_Nr number(5),
    Loc_Name varchar(26)
) cluster Prb_Field (Loc_Nr)
/


-- 3 - columns with same names but different positions

create cluster Prb_Goods (Year decimal(4), Month decimal(2))
    size 100
/

create index Prb_Goods_i
    on cluster Prb_Goods
/

create table Prb_Goods
(
    Goods_Id number(6) not null,
    Composition number(3) not null,
    Year decimal(4) not null,
    Month decimal(2) not null,
    Debit number(10,6),
    Outlay number(10,6),
    constraint Prb_Goods_pk
        primary key (Goods_Id, Composition, Year, Month)
) cluster Prb_Goods (Year, Month)
/


-- 4 - columns with non-clustered table with the same name

create cluster Prb_Coincident (C1 char, C2 char)
    size 16
/

create table Prb_Coincident
(
    C2 char(2),
    C3 char(3)
)
/

