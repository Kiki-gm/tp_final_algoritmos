unit verificacionUnit;

interface

function isNumber(input : String): Boolean;
function stringToNumber(input : String): Real;
function numberToString(input : Real): String;

implementation

    function isNumber(input : String): Boolean;
    var
        code : Integer;
        temp : Real;
    begin
        Val(input,temp,code);
        if code = 0 then
            isNumber := true
        else
            isNumber := false;
    end;

    function stringToNumber(input : String): Real;
    var
        code, i : Integer;
        temp : Real;
    begin
        Val(input,temp,code);
        if code = 0 then
            stringToNumber := temp
        else
        begin
            for i := 1 to Length(input) do
            begin
                if input[i] = ',' then
                    input[i] := '.';
            end;
            Val(input,temp,code);
            if code = 0 then
                stringToNumber := temp
            else
                stringToNumber := 0.0;
        end;
    end;

    function numberToString(input : Real): String;
    begin
        Str(input, numberToString);
    end;
end.