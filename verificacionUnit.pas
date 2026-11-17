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
    procedure verificarModelo(model : tModelo; brand : tMarca; var valid : boolean; var error : String);
    procedure verificarYearVehicle(yearVehicle : Word; model : String; var valid : boolean; var error : String);

    
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
                        error := 'Caracteres sin letras precedentes o consecuentes';
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
                    if (i <= 2) then
                    begin
                        valid := false;
                        error := 'Nombre ingresado no valido';
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
    begin
        valid := True;  

        for i := 1 to length(address) do
        begin
            //Que no se pasen de atrevidos con los espacios
            if (address[i] = ' ') and (i <> Length(address)) then 
            begin
                if address[i+1] = ' ' then
                    valid := False; 
                if (i = 1) then 
                    valid := False;
            end 
            else if (address[i]) = ' ' then
                valid := False;  

            //Si no es una letra...
            if ((address[i] < 'a') or (address[i] > 'z')) and ((address[i] < 'A') or (address[i] > 'Z')) then                             
                begin
                    //Pero es una ', - o una ", que no haya más de una consecutiva, y que no hayan ' ni - a los extremos
                    if ((ord(address[i]) = 39) or (address[i] = '-') or (address[i] = '"')) then
                    begin
                        if ((ord(address[i]) = 39) or (address[i] = '-') or (address[i] = '"')) and (i < Length(address)) then 
                        begin
                            if (i = 1) and (not (address[i] = '"')) then 
                                valid := False;
                            if (ord(address[i+1]) = 39) or (address[i+1] = '-') or (address[i+1] = '"') then
                                valid := False; 
                            if  (address[i] = '-') and ((address[i+1] = ' ') or (address[i-1] = ' ')) then
                                valid := False; 
                            if  (address[i] = '"') and ((address[i+1] <> ' ') and (address[i-1] <> ' ')) then
                                valid := False; 
                        end 
                        else if ((ord(address[i]) = 39) or (address[i] = '-') or (address[i] = '"')) and (i = Length(address)) then
                        begin

                                valid := False;
                        end;   
                    end
                    
                    //Pero es un número, que no esté precedido por nada que no sea ", -, un espacio, u otro número, y que sólo esté seguido por un número o un espacio.
                    else if esNumero(address[i]) then
                    begin
                        if (i > 1) then
                        begin
                            if (not esNumero(address[i-1])) and ((address[i-1] <> ' ') or (address[i-1] <> '"') or (address[i-1] <> '-')) then 
                                valid := False;
                        end; 
                        
                        if i < length(address) then
                        begin
                            if (not esNumero(address[i+1])) and ((address[i+1] <> ' ')) then
                                valid := False; 
                        end;
                    end 

                    else if address[i] <> ' ' then
                        valid := False;
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

    procedure verificarModelo(model : tModelo; brand : tMarca; var valid : boolean; var error : String);
    var b,m : String;
    begin
        valid := false;
        error := 'Modelo no asegurado';
        b := LowerCase(brand);
        m := LowerCase(model);

        case b of
            'fiat':
            begin
                case m of
                    'cronos': valid := true;
                    'palio': valid := true;
                    'uno': valid := true;
                    'siena': valid := true;
                    'toro': valid := true;
                    'strada': valid := true;
                end;
            end;
            'peugeot':
            begin
                case m of
                    '208': valid := true;
                    '206': valid := true;
                    '207 compact': valid := true;
                    'partner': valid := true;
                    '308': valid := true;
                    '2008': valid := true;
                end;
            end;
            'citroen':
            begin
                case m of
                    'c3': valid := true;
                    'Berlingo': valid := true;
                    'c4 cactus': valid := true;
                    'c4 lounge': valid := true;
                    'c3 aircross': valid := true;
                    'basalt': valid := true;
                end;
            end;
            'jeep':
            begin
                case m of
                    'renegade': valid := true;
                    'compass': valid := true;
                    'commander': valid := true;
                    'grand cherokee': valid := true;
                    'cherokee': valid := true;
                    'wrangler': valid := true;
                end;
            end;
            'toyota':
            begin
                case m of
                    'hilux': valid := true;
                    'corola': valid := true;
                    'etios': valid := true;
                    'yaris': valid := true;
                    'corola cross': valid := true;
                    'yaris cross': valid := true;
                    'sw4': valid := true;
                end;
            end;
            'chevrolet':
            begin
                case m of
                    'corsa': valid := true;
                    'classic': valid := true;
                    'onix': valid := true;
                    'tracker': valid := true;
                    'cruze': valid := true;
                    's10': valid := true;
                    'prisma': valid := true;
                end;
            end;
            'volkswagen':
            begin
                case m of
                    'gol': valid := true;
                    'amarok': valid := true;
                    'suran': valid := true;
                    'polo': valid := true;
                    't-cross': valid := true;
                    'tera': valid := true;
                    'taos': valid := true;
                end;
            end;
            'hyundai':
            begin
                case m of
                    'tucson': valid := true;
                    'creta': valid := true;
                    'hb20': valid := true;
                    'santa fe': valid := true;
                    'i10': valid := true;
                    'grand i10': valid := true;
                    'h1': valid := true;
                end;
            end;
            'kia':
            begin
                case m of
                    'sportage': valid := true;
                    'cerato': valid := true;
                    'k3': valid := true;
                    'rio': valid := true;
                    'seltos': valid := true;
                    'sorento': valid := true;
                end;
            end;
            'nissan':
            begin
                case m of
                    'frontier': valid := true;
                    'kicks': valid := true;
                    'versa': valid := true;
                    'march': valid := true;
                    'note': valid := true;
                    'sentra': valid := true;
                end;
            end;
            'renault':
            begin
                case m of
                    'kangoo': valid := true;
                    'sandero': valid := true;
                    'clio': valid := true;
                    'duster': valid := true;
                    'logan': valid := true;
                    'kardian': valid := true;
                end;
            end;
            'suzuki':
            begin
                case m of
                    'ax 100': valid := true;                // moto
                    'gn 125': valid := true;                // moto
                    'gixxer 150': valid := true;            // moto
                    'fun': valid := true;
                    'vitara': valid := true;
                    'grand vitara': valid := true;
                    'switf': valid := true;
                end;
            end;
            'ford':
            begin
                case m of
                    'ranger': valid := true;
                    'ecosport': valid := true;
                    'ka': valid := true;
                    'fiesta': valid := true;
                    'focus': valid := true;
                    'territory': valid := true;
                end;
            end;
            'honda':
            begin
                case m of
                    'wave 110': valid := true;              // moto
                    'cg 150 titan': valid := true;          // moto
                    'glh 150': valid := true;               // moto
                    'xr 150l': valid := true;               // moto
                    'xr 250 tornado': valid := true;        // moto
                    'hr-v': valid := true;
                    'cr-v': valid := true;
                    'civic': valid := true;
                    'fit': valid := true;
                end;
            end;
            'mazda':
            begin
                case m of   
                    '323': valid := true;
                    '626': valid := true;
                    'b2500': valid := true;
                    'b2900': valid := true;
                    'mx-3': valid := true;
                    'mx-5 miata': valid := true;
                    'mpv': valid := true;
                end;
            end;
            'changan':
            begin
                case m of   
                    'cs55 plus': valid := true;
                    'cs15': valid := true;
                    'cs35 plus': valid := true;
                    'eado plus': valid := true;
                    'hunter': valid := true;
                    'md201': valid := true;
                    'star': valid := true;
                end;
            end;
        end;
    end;

    procedure verificarYearVehicle(yearVehicle : Word; model : String; var valid : boolean; var error : String);
    begin
        valid := false;
        error := 'Año del vehiculo incorrecto/invalido';

        case model of
            'cronos':         if ((yearVehicle <= 2026) and (yearVehicle >= 2018)) then valid := true;
            'palio':          if ((yearVehicle <= 2018) and (yearVehicle >= 1996)) then valid := true;
            'uno':            if ((yearVehicle <= 2021) and (yearVehicle >= 1983)) then valid := true;
            'siena':          if ((yearVehicle <= 2016) and (yearVehicle >= 1996)) then valid := true;
            'toro':           if ((yearVehicle <= 2026) and (yearVehicle >= 2016)) then valid := true;
            'strada':         if ((yearVehicle <= 2026) and (yearVehicle >= 1998)) then valid := true;
            '208':            if ((yearVehicle <= 2026) and (yearVehicle >= 2012)) then valid := true;
            '206':            if ((yearVehicle <= 2012) and (yearVehicle >= 1998)) then valid := true;
            '207 compact':    if ((yearVehicle <= 2016) and (yearVehicle >= 2008)) then valid := true;
            'partner':        if ((yearVehicle <= 2026) and (yearVehicle >= 1996)) then valid := true;
            '308':            if ((yearVehicle <= 2026) and (yearVehicle >= 2007)) then valid := true;
            '2008':           if ((yearVehicle <= 2026) and (yearVehicle >= 2013)) then valid := true;
            'c3':             if ((yearVehicle <= 2026) and (yearVehicle >= 2002)) then valid := true;
            'Berlingo':       if ((yearVehicle <= 2026) and (yearVehicle >= 1996)) then valid := true;
            'c4 cactus':      if ((yearVehicle <= 2024) and (yearVehicle >= 2014)) then valid := true;
            'c4 lounge':      if ((yearVehicle <= 2021) and (yearVehicle >= 2013)) then valid := true;
            'c3 aircross':    if ((yearVehicle <= 2026) and (yearVehicle >= 2010)) then valid := true;
            'basalt':         if ((yearVehicle <= 2026) and (yearVehicle >= 2024)) then valid := true;
            'renegade':       if ((yearVehicle <= 2026) and (yearVehicle >= 2014)) then valid := true;
            'compass':        if ((yearVehicle <= 2026) and (yearVehicle >= 2006)) then valid := true;
            'commander':      if ((yearVehicle <= 2026) and (yearVehicle >= 2021)) then valid := true;
            'grand cherokee': if ((yearVehicle <= 2026) and (yearVehicle >= 1992)) then valid := true;
            'cherokee':       if ((yearVehicle <= 2023) and (yearVehicle >= 1974)) then valid := true;
            'wrangler':       if ((yearVehicle <= 2026) and (yearVehicle >= 1986)) then valid := true;
            'hilux':          if ((yearVehicle <= 2026) and (yearVehicle >= 1968)) then valid := true;
            'corola':         if ((yearVehicle <= 2026) and (yearVehicle >= 1966)) then valid := true;
            'etios':          if ((yearVehicle <= 2023) and (yearVehicle >= 2010)) then valid := true;
            'yaris':          if ((yearVehicle <= 2026) and (yearVehicle >= 1999)) then valid := true;
            'corola cross':   if ((yearVehicle <= 2026) and (yearVehicle >= 2020)) then valid := true;
            'yaris cross':    if ((yearVehicle <= 2026) and (yearVehicle >= 2023)) then valid := true;
            'sw4':            if ((yearVehicle <= 2026) and (yearVehicle >= 1984)) then valid := true;
            'corsa':          if ((yearVehicle <= 2016) and (yearVehicle >= 1993)) then valid := true;
            'classic':        if ((yearVehicle <= 2016) and (yearVehicle >= 1993)) then valid := true;
            'onix':           if ((yearVehicle <= 2026) and (yearVehicle >= 2012)) then valid := true;
            'tracker':        if ((yearVehicle <= 2026) and (yearVehicle >= 2012)) then valid := true;
            'cruze':          if ((yearVehicle <= 2023) and (yearVehicle >= 2008)) then valid := true;
            's10':            if ((yearVehicle <= 2026) and (yearVehicle >= 1981)) then valid := true;
            'prisma':         if ((yearVehicle <= 2019) and (yearVehicle >= 2006)) then valid := true;
            'gol':            if ((yearVehicle <= 2023) and (yearVehicle >= 1980)) then valid := true;
            'amarok':         if ((yearVehicle <= 2026) and (yearVehicle >= 2010)) then valid := true;
            'suran':          if ((yearVehicle <= 2019) and (yearVehicle >= 2006)) then valid := true;
            'polo':           if ((yearVehicle <= 2026) and (yearVehicle >= 1975)) then valid := true;
            't-cross':        if ((yearVehicle <= 2026) and (yearVehicle >= 2018)) then valid := true;
            'tera':           if ((yearVehicle <= 2026) and (yearVehicle >= 2025)) then valid := true;
            'taos':           if ((yearVehicle <= 2026) and (yearVehicle >= 2020)) then valid := true;
            'tucson':         if ((yearVehicle <= 2026) and (yearVehicle >= 2004)) then valid := true;
            'creta':          if ((yearVehicle <= 2026) and (yearVehicle >= 2014)) then valid := true;
            'hb20':           if ((yearVehicle <= 2026) and (yearVehicle >= 2012)) then valid := true;
            'santa fe':       if ((yearVehicle <= 2026) and (yearVehicle >= 2000)) then valid := true;
            'i10':            if ((yearVehicle <= 2026) and (yearVehicle >= 2007)) then valid := true;
            'grand i10':      if ((yearVehicle <= 2026) and (yearVehicle >= 2007)) then valid := true;
            'h1':             if ((yearVehicle <= 2021) and (yearVehicle >= 1997)) then valid := true;
            'sportage':       if ((yearVehicle <= 2026) and (yearVehicle >= 1993)) then valid := true;
            'cerato':         if ((yearVehicle <= 2024) and (yearVehicle >= 2003)) then valid := true;
            'k3':             if ((yearVehicle <= 2026) and (yearVehicle >= 2023)) then valid := true;
            'rio':            if ((yearVehicle <= 2023) and (yearVehicle >= 1999)) then valid := true;
            'seltos':         if ((yearVehicle <= 2026) and (yearVehicle >= 2019)) then valid := true;
            'sorento':        if ((yearVehicle <= 2026) and (yearVehicle >= 2002)) then valid := true;
            'frontier':       if ((yearVehicle <= 2026) and (yearVehicle >= 1997)) then valid := true;
            'kicks':          if ((yearVehicle <= 2026) and (yearVehicle >= 2016)) then valid := true;
            'versa':          if ((yearVehicle <= 2026) and (yearVehicle >= 2006)) then valid := true;
            'march':          if ((yearVehicle <= 2023) and (yearVehicle >= 1982)) then valid := true;
            'note':           if ((yearVehicle <= 2026) and (yearVehicle >= 2004)) then valid := true;
            'sentra':         if ((yearVehicle <= 2026) and (yearVehicle >= 1982)) then valid := true;
            'kangoo':         if ((yearVehicle <= 2026) and (yearVehicle >= 1997)) then valid := true;
            'sandero':        if ((yearVehicle <= 2026) and (yearVehicle >= 2007)) then valid := true;
            'clio':           if ((yearVehicle <= 2026) and (yearVehicle >= 1990)) then valid := true;
            'duster':         if ((yearVehicle <= 2026) and (yearVehicle >= 2010)) then valid := true;
            'logan':          if ((yearVehicle <= 2026) and (yearVehicle >= 2004)) then valid := true;
            'kardian':        if ((yearVehicle <= 2026) and (yearVehicle >= 2023)) then valid := true;
            'ax 100':         if ((yearVehicle <= 2026) and (yearVehicle >= 1984)) then valid := true;    // moto
            'gn 125':         if ((yearVehicle <= 2026) and (yearVehicle >= 1981)) then valid := true;    // moto
            'gixxer 150':     if ((yearVehicle <= 2026) and (yearVehicle >= 2014)) then valid := true;    // moto
            'fun':            if ((yearVehicle <= 2011) and (yearVehicle >= 2003)) then valid := true;
            'vitara':         if ((yearVehicle <= 2026) and (yearVehicle >= 1988)) then valid := true;
            'grand vitara':   if ((yearVehicle <= 2026) and (yearVehicle >= 1988)) then valid := true;
            'switf':          if ((yearVehicle <= 2026) and (yearVehicle >= 1983)) then valid := true;
            'ranger':         if ((yearVehicle <= 2026) and (yearVehicle >= 1983)) then valid := true;
            'ecosport':       if ((yearVehicle <= 2022) and (yearVehicle >= 2003)) then valid := true;
            'ka':             if ((yearVehicle <= 2021) and (yearVehicle >= 1996)) then valid := true;
            'fiesta':         if ((yearVehicle <= 2023) and (yearVehicle >= 1976)) then valid := true;
            'focus':          if ((yearVehicle <= 2025) and (yearVehicle >= 1998)) then valid := true;
            'territory':      if ((yearVehicle <= 2026) and (yearVehicle >= 2018)) then valid := true;
            'wave 110':       if ((yearVehicle <= 2026) and (yearVehicle >= 1995)) then valid := true;    // moto
            'cg 150 titan':   if ((yearVehicle <= 2026) and (yearVehicle >= 1976)) then valid := true;    // moto
            'glh 150':        if ((yearVehicle <= 2026) and (yearVehicle >= 1976)) then valid := true;    // moto
            'xr 150l':        if ((yearVehicle <= 2026) and (yearVehicle >= 2001)) then valid := true;    // moto
            'xr 250 tornado': if ((yearVehicle <= 2026) and (yearVehicle >= 2001)) then valid := true;    // moto
            'hr-v':           if ((yearVehicle <= 2026) and (yearVehicle >= 1998)) then valid := true;
            'cr-v':           if ((yearVehicle <= 2026) and (yearVehicle >= 1995)) then valid := true;
            'civic':          if ((yearVehicle <= 2026) and (yearVehicle >= 1972)) then valid := true;
            'fit':            if ((yearVehicle <= 2026) and (yearVehicle >= 2001)) then valid := true;
            '323':            if ((yearVehicle <= 2003) and (yearVehicle >= 1977)) then valid := true;
            '626':            if ((yearVehicle <= 2002) and (yearVehicle >= 1978)) then valid := true;
            'b2500':          if ((yearVehicle <= 2006) and (yearVehicle >= 1961)) then valid := true;
            'b2900':          if ((yearVehicle <= 2006) and (yearVehicle >= 1961)) then valid := true;
            'mx-3':           if ((yearVehicle <= 1998) and (yearVehicle >= 1991)) then valid := true;
            'mx-5 miata':     if ((yearVehicle <= 2026) and (yearVehicle >= 1989)) then valid := true;
            'mpv':            if ((yearVehicle <= 2016) and (yearVehicle >= 1988)) then valid := true;
            'cs55 plus':      if ((yearVehicle <= 2026) and (yearVehicle >= 2017)) then valid := true;
            'cs15':           if ((yearVehicle <= 2024) and (yearVehicle >= 2016)) then valid := true;
            'cs35 plus':      if ((yearVehicle <= 2026) and (yearVehicle >= 2018)) then valid := true;
            'eado plus':      if ((yearVehicle <= 2026) and (yearVehicle >= 2012)) then valid := true;
            'hunter':         if ((yearVehicle <= 2026) and (yearVehicle >= 2019)) then valid := true;
            'md201':          if ((yearVehicle <= 2026) and (yearVehicle >= 2009)) then valid := true;
            'star':           if ((yearVehicle <= 2026) and (yearVehicle >= 2009)) then valid := true;
        end;
    end;
end.