create materialized view Plenty_Digit
    refresh complete 
as
select cast(level - 1 as decimal(1)) as Digit
from dual
connect by level <= 10
/

create materialized view Plenty_Numbers_100
    refresh complete 
as
select cast(level - 1 as number(2)) as Num
from dual
connect by level <= 100
/

create materialized view Plenty_Numbers_1000
    refresh complete
as
select cast(level - 1 as number(3)) as Num
from dual
connect by level <= 1000
/

create materialized view Plenty_Numbers_1000000
    refresh complete
as
select cast(N1.Num * 1000 + N2.Num as number(6)) as Num
from Plenty_Numbers_1000 N1 cross join Plenty_Numbers_1000 N2
/


