unit verificacionUnit;

interface
uses tiposUnit;

function esNumero(input : String): Boolean;
function enRango(input : String; min : Real; max : Real): Boolean;
function stringToReal(input : String): Real;
function realToString(input : Real): String;
function stringToInteger(input : String): Integer;
function integerToString(input : Integer): String;
function esDNI(var dni : tDNI):Boolean;

implementation

    {Si queres entender este codigo investiga como funciona Val(), una funcion de pascal}
    function esNumero(input : String): Boolean;
    var
        code : Integer;
        temp : Real;
    begin
        Val(input,temp,code);
        if code = 0 then
            esNumero := true
        else
            esNumero := false;
    end;

    function enRango(input : String; min : Real; max : Real): Boolean;
    var
        numberInput : Real;
    begin
        enRango := true;
        if esNumero(input) then
        begin
            numberInput := stringToReal(input);
            if (numberInput < min) or (numberInput > max) then
                enRango := false;
        end
        else
            enRango := false;
    end;

    function stringToReal(input : String): Real;
    var
        code, i : Integer;
        temp : Real;
    begin
        Val(input,temp,code);
        if code = 0 then
            stringToReal := temp
        else
        begin
            for i := 1 to Length(input) do
            begin
                if input[i] = ',' then
                    input[i] := '.';
            end;
            Val(input,temp,code);
            if code = 0 then
                stringToReal := temp
            else
                stringToReal := 0.0;
        end;
    end;

    function stringToInteger(input : String): Integer;
    var
        code, i : Integer;
        temp : Integer;
    begin
        Val(input,temp,code);
        if code = 0 then
            stringToInteger := temp
        else
        begin
            for i := 1 to Length(input) do
            begin
                if input[i] = ',' then
                    input[i] := '.';
            end;
            Val(input,temp,code);
            if code = 0 then
                stringToInteger := temp
            else
                stringToInteger := 0;
        end;
    end;

    {Si queres entender este codigo investiga como funciona Str(), una funcion de pascal}
    function realToString(input : Real): String;
    begin
        Str(input, realToString);
    end;
    
    function integerToString(input : Integer): String;
    begin
        Str(input, integerToString);
    end;

    function esDNI(var dni : tDNI):Boolean;
    var
        i : cardinal;
    begin
        for i := 1 to length(dni) do
        begin
            if (ord(dni[i]) < 48) or (ord(dni[i]) > 57) then
            begin
                esDNI := false; 
            end 
            else
                esDNI := True;  
        end;    
    end;

end.