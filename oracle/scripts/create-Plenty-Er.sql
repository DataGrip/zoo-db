create package Plenty_Eratosthenes as

    type Bin_Array_999999 is varray (999999) of binary_integer;

    Sieve Bin_Array_999999;

    procedure Revive_Old;
        pragma restrict_references (Revive_Old, WNDS);

    function Is_Prime (X binary_integer) return binary_integer;
        pragma restrict_references (Is_Prime, RNDS, WNDS, WNPS);

end Plenty_Eratosthenes;
/

create package body Plenty_Eratosthenes as

    procedure Revive_Old is
        d binary_integer := 2;
        k binary_integer;
    begin
        select 0
        bulk collect into Sieve
        from dual
        connect by level <= 999999;
    while d < 1000
        loop
            if (Sieve(d) = 0) then
                k := d + d;
                while k < 1000000
                    loop
                        Sieve(k) := 1;
                        k := k + d;
                    end loop;
            end if;
            d := d + 1;
        end loop;
    end;

    function Is_Prime (X binary_integer) return binary_integer is
    begin
        if X > 1 and X < 1000000 then
            return 1 - Sieve(X);
        else
            return 0;
        end if;
    end;

end Plenty_Eratosthenes;
/

create table Plenty_Prime
(
    Num number(6) not null
        constraint Plenty_Prime_pk primary key
)
    storage (freelist groups 1 freelists 1)
/


begin
    Plenty_Eratosthenes.Revive_Old;
    insert into Plenty_Prime (Num)
        select Num
        from Plenty_Numbers_1000000
        where Num between 2 and 999999
          and Plenty_Eratosthenes.Is_Prime(Num) = 1;
end;
/

commit
/