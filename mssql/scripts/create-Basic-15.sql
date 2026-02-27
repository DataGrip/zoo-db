use Menagerie
go


-- Table with indices
create table Zoo.Basic_15_Indices
(
    Id int,
    F2 int,
    F3 int,
    F4 int,
    F5 int,
    F6 int,
    index Basic_15_Indices_F345_p67_i (F2, F3, F4) include (F5, F6)
)
go


-- Table with advanced indices
create table Zoo.Basic_15_IndicesPlus
(
    Id int,
    F2 float,
    S3 varchar(26),
    constraint Basic_15_IndicesPlus_pk primary key (Id) with (optimize_for_sequential_key = ON),
    index Basic_15_IndicesPlus_F2_i (F2) where F2 >= 0 and F2 <= 100,
    index Basic_15_IndicesPlus_S2_i (S3) where S3 >= 'A' and S3 <= 'Z@'
)
go



