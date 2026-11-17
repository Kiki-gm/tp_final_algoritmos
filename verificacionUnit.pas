unit verificacionUnit;

interface
    uses tiposUnit, crt, polizasUnit;

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

    function valorAseguradoPoliza(poliza : datosPoliza) : Real;
    function valorCuotaPoliza(poliza : datosPoliza) : Real;

    
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
                    'swift': valid := true;
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
            'swift':          if ((yearVehicle <= 2026) and (yearVehicle >= 1983)) then valid := true;
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

    // Aca mati 🤓

    function valorAseguradoPoliza(poliza : datosPoliza) : Real;
    var
        montoBase,multB, multM : Real;
        b : tMarca;
        m : tModelo;
    begin
        b := lowercase(poliza.marca);
        m := lowercase(poliza.modelo);

        case poliza.cobertura of 
            responsabilidadCivil: montoBase := 10000;  
            incendioYRoboTotal: montoBase := 16750;
            incendioYRoboTotalYParcial: montoBase := 19300;
            terceroCompleto: montoBase := 23500;
            todoRiesgo: montoBase := 29150;
        end;

        case b of
            'fiat':
            begin
                multB := 1.2;
                case m of
                    'cronos': multM := 1.05;
                    'palio': multM := 1.15;
                    'uno': multM := 1.1;
                    'siena': multM := 1.075;
                    'toro': multM := 1.1;
                    'strada': multM := 1.0;
                end;
            end;
            'peugeot':
            begin
                multB := 1.1675;
                case m of
                    '208': multM := 1.05;
                    '206': multM := 1.05;
                    '207 compact': multM := 1.075;
                    'partner': multM := 1.1;
                    '308': multM := 1.02;
                    '2008': multM := 1.0999;
                end;
            end;
            'citroen':
            begin
                multB := 1.15;
                case m of
                    'c3': multM := 1.1;
                    'Berlingo': multM := 1.3;
                    'c4 cactus': multM := 1.15;
                    'c4 lounge': multM := 1.2;
                    'c3 aircross': multM := 1.22;
                    'basalt': multM := 1.2;
                end;
            end;
            'jeep':
            begin
                multB := 1.2;
                case m of
                    'renegade': multM := 1.1;
                    'compass': multM := 1.2;
                    'commander': multM := 1.125;
                    'grand cherokee': multM := 1.1;
                    'cherokee': multM := 1.225;
                    'wrangler': multM := 1.2;
                end;
            end;
            'toyota':
            begin
                multB := 1.3;
                case m of
                    'hilux': multM := 1.2;
                    'corola': multM := 1.4;
                    'etios': multM := 1.1;
                    'yaris': multM := 1.15;
                    'corola cross': multM := 1.2;
                    'yaris cross': multM := 1.15;
                    'sw4': multM := 1.075;
                end;
            end;
            'chevrolet':
            begin
                multB := 1.25;
                case m of
                    'corsa': multM := 1.085;
                    'classic': multM := 1.075;
                    'onix': multM := 1.1;
                    'tracker': multM := 1.125;
                    'cruze': multM := 1.1;
                    's10': multM := 1.05;
                    'prisma': multM := 1.2;
                end;
            end;
            'volkswagen':
            begin
                multB := 1.3;
                case m of
                    'gol': multM := 1.15;
                    'amarok': multM := 1.4;
                    'suran': multM := 1.3;
                    'polo': multM := 1.2;
                    't-cross': multM := 1.175;
                    'tera': multM := 1.1;
                    'taos': multM := 1.1;
                end;
            end;
            'hyundai':
            begin
                multB := 1.1;
                case m of
                    'tucson': multM := 1.1;
                    'creta': multM := 1.15;
                    'hb20': multM := 1.01;
                    'santa fe': multM := 1.2;
                    'i10': multM := 1.075;
                    'grand i10': multM := 1.1;
                    'h1': multM := 1.025;
                end;
            end;
            'kia':
            begin
                multB := 1.05;
                case m of
                    'sportage': multM := 1.1;
                    'cerato': multM := 1.0333;
                    'k3': multM := 1.2;
                    'rio': multM := 1.2;
                    'seltos': multM := 1.125;
                    'sorento': multM := 1.1;
                end;
            end;
            'nissan':
            begin
                multB := 1.2;
                case m of
                    'frontier': multM := 1.3;
                    'kicks': multM := 1.2;
                    'versa': multM := 1.15;
                    'march': multM := 1.12;
                    'note': multM := 1.06969;
                    'sentra': multM := 1.1;
                end;
            end;
            'renault':
            begin
                multB := 1.3;
                case m of
                    'kangoo': multM := 1.3;
                    'sandero': multM := 1.15;
                    'clio': multM := 1.275;
                    'duster': multM := 1.25;
                    'logan': multM := 1.1;
                    'kardian': multM := 1.025;
                end;
            end;
            'suzuki':
            begin
                multB := 1.225;
                case m of
                    'ax 100': multM := 1.1;         
                    'gn 125': multM := 1.00001;      
                    'gixxer 150': multM := 1.00002;            
                    'fun': multM := 1.00003;
                    'vitara': multM := 1.09991;
                    'grand vitara': multM := 1.2;
                    'swift': multM := 1.2;
                end;
            end;
            'ford':
            begin
                multB := 1.4;
                case m of
                    'ranger': multM := 1.4;
                    'ecosport': multM := 1.1;
                    'ka': multM := 1.15;
                    'fiesta': multM := 1.35;
                    'focus': multM := 1.3;
                    'territory': multM := 1.2;
                end;
            end;
            'honda':
            begin
                multB := 1.35;
                case m of
                    'wave 110': multM := 1.2;           
                    'cg 150 titan': multM := 1.1275;       
                    'glh 150': multM := 1.2;           
                    'xr 150l': multM := 1.15;              
                    'xr 250 tornado': multM := 1.1;   
                    'hr-v': multM := 1.12;
                    'cr-v': multM := 1.075;
                    'civic': multM := 1.3;
                    'fit': multM := 1.115;
                end;
            end;
            'mazda':
            begin
                multB := 1.0025;
                case m of   
                    '323': multM := 1.1;
                    '626': multM := 1.12;
                    'b2500': multM := 1.175;
                    'b2900': multM := 1.2;
                    'mx-3': multM := 1.1;
                    'mx-5 miata': multM := 1.12;
                    'mpv': multM := 1.1;
                end;
            end;
            'changan':
            begin
                multB := 1.2;
                case m of   
                    'cs55 plus': multM := 1.235;
                    'cs15': multM := 1.1;
                    'cs35 plus': multM := 1.15;
                    'eado plus': multM := 1.155;
                    'hunter': multM := 1.245;
                    'md201': multM := 1.2;
                    'star': multM := 1.15;
                end;
            end;
        end;

        valorAseguradoPoliza := montoBase * multB * multM;

    end;

    {Se determina la cantidad de meses a pagar, y se divide la suma total por eso.}
    function valorCuotaPoliza(poliza : datosPoliza) : Real;
    var
        tempTotal : Real;
        tempA1, tempA2 : word;
        tempM1, tempM2 : 1..12;
        tempD1, tempD2, diasMesIni, diasMesFin : 1..31;
        contM : Word;
        mesesExactos : Real;
    begin
        tempTotal := poliza.sumaAsegurada;
        tempA1 := poliza.fecha.vigenciadesde.A; 
        tempA2 := poliza.fecha.vigenciaHasta.A; 
        tempM1 := poliza.fecha.vigenciaDesde.M;
        tempM2 := poliza.fecha.vigenciaHasta.M; 
        tempD1 := poliza.fecha.vigenciaDesde.D;
        tempD2 := poliza.fecha.vigenciaHasta.D;
        contM := 0;

        {Mientras el año sea menor o igual, se cuentan los meses a cobrar, 
         comenzando por el mes desde y terminando en el mes del año hasta}
        while (tempM1 <= tempM2) and (tempA1 <= tempA2) do
        begin
            inc(contM);  
            if tempM1 = 12 then
            begin
                tempM1 := 1;
                inc(tempA1);
            end
            else
                inc(tempM1);
            
        end; 
        
        {Las empresas de pólizas son muy finas en sus cálculos: consideran hasta el día.
         Se toma el valor total calculando de meses abarcados, y se resta del inicio y el
         final, según el día de comienzo y de fin}
        diasMesIni := diasDelMes(poliza.fecha.vigenciaDesde.M,poliza.fecha.vigenciaDesde.A);
        diasMesFin := diasDelMes(poliza.fecha.vigenciaHasta.M,poliza.fecha.vigenciaHasta.A);
        mesesExactos := contM - (1/diasMesIni * (tempD1 - 1)) - ((1/diasMesFin) * (diasMesFin - (tempD2-1)));
    
        valorCuotaPoliza := tempTotal/mesesExactos; //Considerar que internamente, se suele trabajar con 6 decimales en las empresas de pólizas.
    end;
end.