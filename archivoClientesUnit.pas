unit archivoClientesUnit;

interface
    uses clientesUnit, tiposUnit;

    type
        tArchivoClientes = file of datosCliente;

    procedure inicializarArchivoClientes(var f : tArchivoClientes; path : String);
    procedure leerArchivoClientes(var f : tArchivoClientes; pos : Cardinal; var data : datosCliente);
    procedure escribirArchivoClientes(var f : tArchivoClientes; pos : Cardinal; data : datosCliente);
    function ultimaLineaArchivoClientes(var f : tArchivoClientes): Integer;    
    
    function busquedaBinariaDNI(var arch: tArchivoClientes; searched: tDNI): Integer;
    function buscarDatosCliente(var arch: tArchivoClientes; i : Word): datosCliente;
    procedure inicializarCliente(var c : datosCliente; d : tDNI);
    procedure agregarCliente(var f : tArchivoClientes; c : datosCliente); 
    
    function busquedaBinariaDNI(var arch: tArchivoClientes; searched: tDNI): Word;
    procedure quicksortApellidoNombre(var arch: tArchivoClientes; first: Word; last: Word);


implementation

    procedure inicializarArchivoClientes(var f : tArchivoClientes; path : String);
    begin
        Assign(f, path);
        {$i-}
        Reset(f);
        {$i+}
        if IOResult <> 0 then
        begin
            {$i-}
            Rewrite(f);
            {$i+}
            if IOResult <> 0 then
                WriteLn('Tamos mal loco');
        end;
    end;

    procedure leerArchivoClientes(var f : tArchivoClientes; pos : Cardinal; var data : datosCliente);
    begin
        Seek(f,pos);
        Read(f,data);
    end;

    procedure escribirArchivoClientes(var f : tArchivoClientes; pos : Cardinal; data : datosCliente);
    begin
        Seek(f,pos);
        Write(f,data);
    end;

    procedure agregarCliente(var f : tArchivoClientes; c : datosCliente);
    begin
        Seek(f, FileSize(f));
        Write(f,c);
    end;
    
    function ultimaLineaArchivoClientes(var f : tArchivoClientes): Integer;
    begin
        ultimaLineaArchivoClientes := FileSize(f) - 1;
    end;

    function ArchivoVacio(var f : tArchivoClientes): Boolean;
    begin
        ArchivoVacio := FileSize(f) = 0;
    end;
    
    function busquedaBinariaDNI(var arch: tArchivoClientes; searched: tDNI): Integer;
    var
        ini, fin, mid, pos: Integer;
        temp: datosCliente;
    begin
        pos := -1;

        if not ArchivoVacio(arch) then
        begin
            ini := 0;
            fin := ultimaLineaArchivoClientes(arch);

            while (ini <= fin) and (pos = -1) do
            begin
                mid := (ini + fin) div 2;
                leerArchivoClientes(arch, mid, temp);

                if searched = temp.DNI then
                    pos := mid
                else if searched < temp.DNI then
                    fin := mid - 1 
                else 
                    ini := mid + 1;
            end;
        end;

        busquedaBinariaDNI := pos;
    end;

    function buscarDatosCliente(var arch: tArchivoClientes; i: Word): datosCliente;
    begin
        Seek(arch,i);
        Read(arch,buscarDatosCliente);
    end;

    procedure inicializarCliente(var c : datosCliente; d : tDNI);
    begin
        c.dni := d;
        c.apellidoYNombres := '';
        c.direccion := '';
        c.fechaDeNacimiento.D := 1;
        c.fechaDeNacimiento.M := 1;
        c.fechaDeNacimiento.A := 2000;
        c.celular := '';
        c.email := '';
        c.estado := true;
    end;

    //En un futuro se sustituirá por un árbol de búsqueda.
    procedure quicksortApellidoNombre(var arch: tArchivoClientes; first: Word; last: Word);
    var
    lower, upper: Word;
    temp, tempLower, tempUpper, pivot: datosCliente;
    begin
        lower := first;
        upper := last;

        if ultimaLinea(arch) >= 0 then
        begin
            leerArchivoClientes(arch, (lower + upper) div 2, pivot);

            repeat
                leerArchivoClientes(arch,lower,tempLower);

                while tempLower.apellidoYNombres < pivot.apellidoYNombres do
                begin
                    inc(lower);
                    leerArchivoClientes(arch,upper,tempUpper);
                end;
                
                while tempUpper.apellidoYNombres > pivot.apellidoYNombres do
                    dec(upper);

                if lower <= upper then
                begin
                    leerArchivoClientes(arch,lower,temp);
                    tempLower := tempUpper;
                    tempUpper := temp;
                    inc(lower);
                    dec(upper);
                end;

            until lower > upper;

            if upper > first then
                quicksortApellidoNombre(arch, first, upper);
            
            if lower < last then
                quicksortApellidoNombre(arch, lower, last);
        end;
    end;  
end.