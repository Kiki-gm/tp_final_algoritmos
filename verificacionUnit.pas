unit verificacionUnit;

interface
    uses tiposUnit, crt;

    function esNumero(input : String): Boolean;
    function enRango(input : String; min : Real; max : Real): Boolean;
    function stringToReal(input : String): Real;
    function realToString(input : Real): String;
    function stringToInteger(input : String): Integer;
    function integerToString(input : Integer): String;

    function numeroConCeros(n, digitos : Integer) : String;
    function diasDelMes(m, a : Integer) : Integer;

    function completarCeros(dni : tDNI) : tDNI;
    function esDNI(dni : tDNI) : Boolean;
    
    function suprimirEspacios(fullName: String): String;

    procedure verificarNombre(fullname : tApellidoYNombres; var campo : boolean);
    procedure verificarDireccion(address : tDireccion; var campo : boolean);
    procedure verificarFechaNac(birthDate: tFecha; var campo : boolean);
    procedure verificarCel(phoneNum : tCelular; var campo : boolean);
    procedure verificarEmail(mail : tEmail; var campo : boolean);
    
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

    function numeroConCeros(n, digitos : Integer) : String;
    var
        s : String;
    begin
        Str(n, s);
        while Length(s) < digitos do
            s := '0' + s;
        numeroConCeros := s;
    end;

    function diasDelMes(m, a : Integer) : Integer;
    begin
        case m of
            1, 3, 5, 7, 8, 10, 12: diasDelMes := 31;
            4, 6, 9, 11:           diasDelMes := 30;
        else
            if ((a mod 4 = 0) and (a mod 100 <> 0)) or (a mod 400 = 0) then
                diasDelMes := 29
            else
                diasDelMes := 28;
        end;
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

    procedure verificarNombre(fullname : tApellidoYNombres; var campo : boolean);
    var
        i : integer;
    begin
        campo := true;

        for i := 1 to length(fullname) do 
        begin
            //Si hay más de un espacio vacío consecutivo, o uno a los bordes, falso.
            if (fullname[i] = ' ') and (i <> Length(fullname)) then 
            begin
                if fullname[i+1] = ' ' then
                    campo := False; 
                if (i = 1) then 
                    campo := False;
            end 
            else if ((fullname[i]) = ' ') then
                campo := False;  

            //Si un ' o un - se repite consecutivamente, o uno al inicio o al final; o bien el caracter no es ni una letra ni ' o -, falso.
            if ((fullname[i] < 'a') or (fullname[i] > 'z')) and ((fullname[i] < 'A') or (fullname[i] > 'Z')) then                             
            begin
                if ((ord(fullname[i]) = 39) or (fullname[i] = '-')) then
                begin
                    if ((ord(fullname[i]) = 39) or (fullname[i] = '-')) and (i < Length(fullname)) then 
                    begin
                        if (ord(fullname[i+1]) = 39) or (fullname[i+1] = '-') or (fullname[i+1] = ' ') then
                            campo := False;
                        if (i > 1) and (fullname[i] = '-') then 
                            if ((fullname[i-1] < 'a') or (fullname[i-1] > 'z')) and ((fullname[i-1] < 'A') or (fullname[i-1] > 'Z')) then
                              campo := False;
                        if (i = 1) then 
                            campo := False;
                    end 
                    else if (ord(fullname[i]) = 39) or (fullname[i] = '-') then
                            campo := False;   
                end
                else if fullname[i] <> ' ' then
                    campo := False;
            end;
        end;

        if suprimirEspacios(fullname) = fullname then
            campo := False;
    end;

    procedure verificarDireccion(address : tDireccion; var campo : boolean); //Esta es media rara. Habría que verla en conjunto.
    var
        i : integer;
    begin
        campo := True;  
        
        for i := 1 to length(address) do
        begin
            //Que no se pasen de atrevidos con los espacios
            if (address[i] = ' ') and (i <> Length(address)) then 
            begin
                if address[i+1] = ' ' then
                    campo := False; 
                if (i = 1) then 
                    campo := False;
            end 
            else if (address[i]) = ' ' then
                campo := False;  

            //Si no es una letra...
            if ((address[i] < 'a') or (address[i] > 'z')) and ((address[i] < 'A') or (address[i] > 'Z')) then                             
                begin
                    //Pero es una ', - o una ", que no haya más de una consecutiva, y que no hayan ' ni - a los extremos
                    if ((ord(address[i]) = 39) or (address[i] = '-') or (address[i] = '"')) then
                    begin
                        if ((ord(address[i]) = 39) or (address[i] = '-') or (address[i] = '"')) and (i < Length(address)) then 
                        begin
                            if (i = 1) and (not (address[i] = '"')) then 
                                campo := False;
                            if (ord(address[i+1]) = 39) or (address[i+1] = '-') or (address[i+1] = '"') then
                                campo := False; 
                            if  (address[i] = '-') and ((address[i+1] = ' ') or (address[i-1] = ' ')) then
                                campo := False; 
                            if  (address[i] = '"') and ((address[i+1] <> ' ') and (address[i-1] <> ' ')) then
                                campo := False; 
                        end 
                        else if ((ord(address[i]) = 39) or (address[i] = '-') or (address[i] = '"')) and (i = Length(address)) then
                        begin

                                campo := False;
                        end;   
                    end
                    
                    //Pero es un número, que no esté precedido por nada que no sea ", -, un espacio, u otro número, y que sólo esté seguido por un número o un espacio.
                    else if (address[i] >= '1') and (address[i] <= '9') then
                    begin
                        if (i > 1) then
                        begin
                            if (not (address[i-1] >= '1')) and (not (address[i-1] <= '9')) and ((address[i-1] <> ' ') or (address[i-1] <> '"') or (address[i-1] <> '-')) then 
                                campo := False;
                        end; 
                        
                        if i < length(address) then
                        begin
                            if (not (address[i+1] >= '1')) and (not (address[i+1] <= '9')) and ((address[i+1] <> ' ')) then
                                campo := False; 
                        end;
                    end 

                    else if address[i] <> ' ' then
                        campo := False;
            end;  
        end; 
    end;

    procedure verificarFechaNac(birthDate: tFecha; var campo : boolean); //Acá no hay mucho para hacer, porque su entrada necesariamente es correcta.
    begin
        campo := True;  
    end;
    
    procedure verificarCel(phoneNum : tCelular; var campo : boolean);
    begin
        campo := True;
        if length(phoneNum) > 21 then //Incluendo prefijos y no sé qué no sé cuánto, este debería ser el largo máximo en el mundo.
            campo := False;
    end;

    {1. Evitar repeticion de @ y la existencia de @ al final. 
     2. Evitar uso de espacios
     3. hacer que sea necesario tener una @, seguida de algun tipo de sufijo, como gmail.com, hotmail.com., yahoo.com 
    }
    procedure verificarEmail(mail : tEmail; var campo : boolean);
    var 
        temp1, temp2, i : integer;
        temp3 : String;
    begin
        campo := True;

        for i := 1 to Length(mail) do 
        begin
            //Si hay más de un espacio vacío consecutivo, o uno a los bordes, falso.
            if (mail[i] = ' ') and (i <> length(mail)) then 
            begin
                if mail[i+1] = ' ' then
                    campo := False; 
                if (i = 1) then 
                    campo := False;
            end 
            else if (mail[i]) = ' ' then
                    campo := False; 
            
            {Si hay más de una @ consecutiva, o una a los bordes, falso.
            Además, busqué los sufijos de email más comunes del mundo. Si el sufijo usado no es uno de ellos, falso. 
            Evidentemente, hay formas más sofisticadas de hacer esto.}
            if (mail[i] = '@') and (i <> Length(mail)) then 
            begin
                if mail[i+1] = '@' then
                begin
                    campo := False; 
                end
                else if (i = 1) then 
                begin
                    campo := False;
                end
                else
                begin
                    temp1 := i+1;
                    temp2 := length(mail) - i+1;
                    temp3 := copy(mail,temp1,temp2);

                    if (temp3 <> 'gmail.com') and (temp3 <> 'hotmail.com') and (temp3 <> 'yahoo.com') then
                    begin
                        campo := False;  
                    end;   
                end;   
            end 
            else if (mail[i]) = '@' then
            begin
                    campo := False;  
            end;
        end;
    end;
end.