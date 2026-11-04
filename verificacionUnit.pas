unit verificacionUnit;

interface
    uses tiposUnit, crt;

    function esNumero(input : String): Boolean;
    function enRango(input : String; min : Real; max : Real): Boolean;
    function stringToReal(input : String): Real;
    function realToString(input : Real): String;
    function stringToInteger(input : String): Integer;
    function integerToString(input : Integer): String;

    function completarCeros(dni : tDNI) : tDNI;
    function esDNI(dni : tDNI) : Boolean;
    
    function suprimirEspacios(fullName: String): String;

implementation

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

    function realToString(input : Real): String;
    begin
        Str(input, realToString);
    end;
    
    function integerToString(input : Integer): String;
    begin
        Str(input, integerToString);
    end;

    function completarCeros(dni : tDNI) : tDNI;
    var
        s : tDNI;
    begin
        s := dni;
        while Length(s) < 8 do
        begin
            s := Concat('0', s);
        end;
        completarCeros := s;
    end;

    function esDNI(dni : tDNI) : Boolean;
    begin
        esDNI := (Length(dni) >= 7) and (Length(dni) <= 8);
    end;

    function suprimirEspacios(fullName: String): String;
    var
        i : Cardinal;
        temp : String;
    begin
        temp := fullname;

        if temp[1] = ' ' then
            delete(temp,1,1);

        for i := 1 to SizeOf(fullname) do
        begin
            if temp[i] = ' ' then
                delete(temp,i,1);
        end;

        suprimirEspacios := temp;
    end;
end.