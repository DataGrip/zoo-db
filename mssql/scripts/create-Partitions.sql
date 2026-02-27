-- Partitions

create partition function Partition_Fun_11_Left (int)
as range left for values (1, 100, 1000);

create partition function Partition_Fun_12_Right (int)
as range right for values (1, 100, 1000);

create partition function Partition_Fun_21_Bit (bit)
as range right for values (0, 1);

create partition function Partition_Fun_22_Tinyint (tinyint)
as range right for values (1, 100, 200);

create partition function Partition_Fun_23_Smallint (smallint)
as range right for values (1, 1000, 5000);

create partition function Partition_Fun_24_Int (int)
as range right for values (1, 1000000, 5000000);

create partition function Partition_Fun_25_Bigint (bigint)
as range right for values (1, 1000000000000, 5000000000000);

create partition function Partition_Fun_26_Float (float)
as range right for values (0.01, 2.71828, 3.1415);


create partition function Partition_Fun_31_DateTime (datetime)
as range right for values (
  '19910101', '19920101', '20000101',
  '20030501', '20030601', '20030701', '20030801',
  '20030901', '20031001', '20031101', '20201231'
);




