unit verificacionUnit;

interface
    uses tiposUnit, crt;

    function esLetra(c : Char) : Boolean;
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
    function esPatente(patente : tPatente) : Boolean;

    function suprimirEspacios(fullName: String): String;

    function obtenerTextoCobertura(cov : tipoCobertura) : String;

    procedure verificarNombre(fullname : tApellidoYNombres; var valid : boolean; var error : String);
    procedure verificarDireccion(address : tDireccion; var valid : boolean; var error : String);
    procedure verificarCel(phoneNum : tCelular; var valid : boolean; var error : String);
    procedure verificarEmail(mail : tEmail; var valid : boolean; var error : String);

    procedure verificarMarca(brand : tMarca; var valid : boolean; var error : String);
    procedure verificarModelo(model : tModelo; var valid : boolean; var error : String);
    procedure verificarYearVehicle(yearVehicle : Word; var valid : boolean; var error : String);
    
implementation

    function esLetra(c : Char) : Boolean;
    begin           { Si esta entre A y Z}         { Si esta entre a y z}
        esLetra := ((c < #91) and (c > #64)) or ((c < #123) and (c > #96));
    end;

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

    function esPatente(patente : tPatente) : Boolean;
    begin
        esPatente := true;
        if (Length(patente) < 6) or (Length(patente) > 7) then
            esPatente := false
        else
        begin
            if Length(patente) = 6 then
            begin
                if not esLetra(patente[1]) then esPatente := false;
                if not esLetra(patente[2]) then esPatente := false;
                if not esLetra(patente[3]) then esPatente := false;
                if not esNumero(patente[4]) then esPatente := false;
                if not esNumero(patente[5]) then esPatente := false;
                if not esNumero(patente[6]) then esPatente := false;
            end
            else
            begin
                if not esLetra(patente[1]) then esPatente := false;
                if not esLetra(patente[2]) then esPatente := false;
                if not esNumero(patente[3]) then esPatente := false;
                if not esNumero(patente[4]) then esPatente := false;
                if not esNumero(patente[5]) then esPatente := false;
                if not esLetra(patente[6]) then esPatente := false;
                if not esLetra(patente[7]) then esPatente := false;
            end;
        end;
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

    function obtenerTextoCobertura(cov : tipoCobertura) : String;
    begin
        case cov of
            responsabilidadCivil: obtenerTextoCobertura := 'Responsabilidad civil';
            incendioYRoboTotal: obtenerTextoCobertura := 'Incendio y robo total';
            incendioYRoboTotalYParcial: obtenerTextoCobertura := 'Incendio y robo total y parcial';
            terceroCompleto: obtenerTextoCobertura := 'Terceros completo';
            todoRiesgo: obtenerTextoCobertura := 'Todo riesgo';
        end;
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
        temp : String;
    begin
        temp := fullname;

        while (Length(temp) > 0) and (Ord(temp[1]) <= 32) do
            delete(temp,1,1);
        
        while (Length(temp) > 0) and (Ord(temp[Length(temp)]) <= 32) do
            delete(temp,Length(temp),1);

        suprimirEspacios := temp;
    end;

    procedure verificarNombre(fullname : tApellidoYNombres; var valid : boolean; var error : String);
    var
        i : integer;
        spaceFound : Boolean;

        function esCaracterNombre(c : Char) : Boolean;
        begin                        { ' }
            esCaracterNombre := ((c = #39) or (c = '-') or (c = '`') or (c = '^'));
        end;

    begin
        valid := true;
        spaceFound := false;

        if Length(fullname) < 2 then
        begin
            valid := false;
            error := 'Nombre ingresado muy corto';
        end
        else
        begin
            for i := 1 to Length(fullname) do 
            begin              
                if esCaracterNombre(fullname[i]) then
                begin
                    if (i = 1) or (i = Length(fullname)) then
                    begin
                        valid := false;
                        error := 'Caracteres especiales sin letras precedentes o consecuentes';
                    end
                    else
                    begin
                        if (esCaracterNombre(fullname[i+1])) or (esCaracterNombre(fullname[i-1])) then
                        begin
                            valid := false;
                            error := 'Doble caracter junto';
                        end;
                    end;
                end
                else if (fullname[i] = ' ') then
                begin
                    spaceFound := true;
                    if (i <= 2)  then
                    begin
                        valid := false;
                        error := 'Nombre ingresado no valido';
                    end
                    else if (i < length(fullname)) and (fullname[i+1] = ' ') then
                    begin
                        valid := false;
                        error := 'Doble espacio junto';
                    end;
                    if (i >= (Length(fullname) - 1)) then
                    begin
                        valid := false;
                        error := 'Apellido ingresado no valido';
                    end;
                end
                else if not esLetra(fullname[i]) then
                begin
                    valid := false;
                    error := 'Caracter ingresado no valido';
                end;
            end;
            
            if not spaceFound then
            begin
                valid := false;
                error := 'Falta nombre o apellido';
            end;
        end;
    end;

    procedure verificarDireccion(address : tDireccion; var valid : boolean; var error : String); //Esta es media rara. Habría que verla en conjunto.
    var
        i : integer;
        spaceFound : Boolean;

        function esCaracterDireccion(c : Char) : Boolean;
        begin
            esCaracterDireccion := ((c = #39) or (c = '-') or (c = '`') or (c = '^') or (c = '"') or (c = ' '));
        end;

    begin
        valid := true;
        spaceFound := false;

        for i := 1 to length(address) do
        begin
            //Que no se pasen de atrevidos con los espacios y los caracteres especiales.
            if esCaracterDireccion(address[i]) then
            begin
                if (i = 1) or (i = Length(address)) and (not (address[i] = #39)) and (not (address[i] = '"')) then //' y " pueden llegar a usaarse en ciertos lugares, por lo que tienen derechos extra.
                begin
                    valid := false;
                    error := 'Caracteres especiales sin letras precedentes o consecuentes';
                end
                else
                begin
                    if (esCaracterDireccion(address[i+1])) or (esCaracterDireccion(address[i-1])) and (not (address[i] = ' ')) then
                    begin
                        valid := false;
                        error := 'Doble caracter junto';
                    end;
                end;
            end
            else if (address[i] = ' ') then
                begin
                    spaceFound := true;
                    if (i = 1) or (i >= (Length(address) - 1)) then
                    begin
                        valid := false;
                        error := 'Direccion ingresada no valida';
                    end;
                end;

            //Si no es una letra...
            if not esLetra(address[i]) then                             
                begin
                    //Pero es una ', - o una ", que no haya más de una consecutiva, y que no hayan ' ni - a los extremos
                    if (address[i] = #39) or (address[i] = '-') or (address[i] = '"') then
                    begin
                        if (address[i] = #39) or (address[i] = '-') or (address[i] = '"') and (i < Length(address)) then 
                        begin
                            if (i = 1) and (not (address[i] = '"')) then 
                                valid := False;
                                error := 'Uso incorrecto de caracteres especiales';
                            if (ord(address[i+1]) = 39) or (address[i+1] = '-') or (address[i+1] = '"') then
                                valid := False; 
                                error := 'Uso incorrecto de caracteres especiales';
                            if  (address[i] = '-') and ((address[i+1] = ' ') or (address[i-1] = ' ')) then
                                valid := False; 
                                error := 'Uso incorrecto de caracteres especiales';
                            if  (address[i] = '"') and ((address[i+1] <> ' ') and (address[i-1] <> ' ')) then
                                valid := False; 
                                error := 'Uso incorrecto de caracteres especiales';
                        end 
                        else if ((ord(address[i]) = 39) or (address[i] = '-') or (address[i] = '"')) and (i = Length(address)) then
                        begin
                                valid := False;
                                error := 'Uso incorrecto de caracteres especiales';
                        end;   
                    end
                    
                    //Pero es un número, que no esté precedido por nada que no sea ", -, un espacio, u otro número, y que sólo esté seguido por un número o un espacio.
                    else if esNumero(address[i]) then
                    begin
                        if (i > 1) then
                        begin
                            if (not esNumero(address[i-1])) and ((address[i-1] <> ' ')) then 
                                valid := False;
                                error := 'Direccion ingresada no valida';
                        end; 
                        
                        if i < length(address) then
                        begin
                            if (not esNumero(address[i+1])) and ((address[i+1] <> ' ')) then
                                valid := False; 
                                error := 'Direccion ingresada no valida';
                        end;
                    end 

                    else if address[i] <> ' ' then
                    begin
                        valid := False;
                        error := 'Direccion ingresada no valida';
                    end;
            end;  
        end; 
    end;

    procedure verificarCel(phoneNum : tCelular; var valid : boolean; var error : String);
    begin
        valid := True;
        if (Length(phoneNum) > 21) or (Length(phoneNum) < 8) then
        begin
            valid := False; //Incluendo prefijos y no sé qué no sé cuánto, este debería ser el largo máximo en el mundo.
            error := 'Numero ingresado no valido';
        end; 
    end;

    procedure verificarEmail(mail : tEmail; var valid : boolean; var error : String);
    var 
        i : integer;
        temp : String;
        atFound : Boolean;
    begin
        valid := True;
        atFound := false;

        for i := 1 to Length(mail) do 
        begin
            if mail[i] = ' ' then
            begin
                valid := false;
                error := 'No se permiten espacios en los correos electronicos';
            end;
            
            if (mail[i] = '@') then
                atFound := true;

            {Si hay más de una @ consecutiva, o una a los bordes, falso.
            Además, busqué los sufijos de email más comunes del mundo. Si el sufijo usado no es uno de ellos, falso. 
            Evidentemente, hay formas más sofisticadas de hacer esto.}
            if (mail[i] = '@') and (i <> Length(mail)) then 
            begin
                if mail[i+1] = '@' then
                begin
                    valid := False;
                    error := 'Doble @'; 
                end
                else if (i = 1) then 
                begin
                    valid := False;
                    error := 'No hay caracteres antes del @';
                end
                else
                begin
                    temp := copy(mail,(i+1),(Length(mail) - i));

                    if (temp <> 'gmail.com') and 
                       (temp <> 'hotmail.com') and
                       (temp <> 'yahoo.com') then
                    begin
                        valid := False;
                        error := 'Dominio ingresado no valido';  
                    end;   
                end;   
            end 
            else if (mail[i]) = '@' then
            begin
                valid := False;  
                error := 'Dominio no ingresado';
            end;
        end;

        if not atFound then
        begin
            valid := false;
            error := 'Falta @';
        end;
    end;

    procedure verificarMarca(brand : tMarca; var valid : boolean; var error : String);
    var temp : String;
    begin
        valid := true;
        temp := LowerCase(brand);

        if (temp <> 'fiat') and
           (temp <> 'peugeot') and
           (temp <> 'citroen') and
           (temp <> 'jeep') and
           (temp <> 'toyota') and
           (temp <> 'chevrolet') and
           (temp <> 'volkswagen') and
           (temp <> 'hyundai') and
           (temp <> 'kia') and
           (temp <> 'nissan') and
           (temp <> 'renault') and
           (temp <> 'suzuki') and
           (temp <> 'ford') and
           (temp <> 'honda') and
           (temp <> 'mazda') and
           (temp <> 'changan') then
        begin
            valid := false;
            error := 'Marca no registrada';
        end;
    end;

    procedure verificarModelo(model : tModelo; var valid : boolean; var error : String);
    var i : Word;
    begin
        valid := true;

        if Length(model) < 2 then
        begin
            valid := false;
            error := 'Nombre de modelo muy corto';
        end
        else
        begin
            for i := 1 to Length(model) do
            begin
                if (not esNumero(model[i])) and (not esLetra(model[i])) then
                begin
                    valid := false;
                    error := 'El modelo ingresado lleva caracteres especiales';
                end;
            end;
        end;
    end;

    procedure verificarYearVehicle(yearVehicle : Word; var valid : boolean; var error : String);
    begin
        valid := true;

        if yearVehicle <= 1800 then
        begin
            valid := false;
            error := 'Año ingresado no valido'
        end;
    end;
end.