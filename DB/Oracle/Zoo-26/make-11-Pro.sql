create package Pro_Small_Pack is

    function Get_Something return positive;
    procedure Do_Something;
    procedure Print_It (str string);
    procedure Print_It (num number);

end Pro_Small_Pack;
/

create package body Pro_Small_Pack is

    function Get_Something return positive is
    begin
        return 42;
    end;

    procedure Do_Something is
        something positive;
    begin
        something := Get_Something;
    end;

    procedure Print_It (str string) is
    begin
        dbms_Output.put_line(str);
    end;

    procedure Print_It (num number) is
    begin
        dbms_Output.put_line(num);
    end;

end Pro_Small_Pack;
/



create type Pro_Small_Type as object
(
    Small_Thing decimal(2),
    member function Get_Something return positive,
    member procedure Do_Something,
    member procedure Print_It (str string),
    member procedure Print_It (num number)
)
/


create function Pro_Get_Something return decimal is
begin
    return 42;
end;
/

create procedure Pro_Do_Something is
begin
    null;
end;
/


create synonym Get_Something for Pro_Get_Something
/

create synonym Do_Something for Pro_Do_Something
/


