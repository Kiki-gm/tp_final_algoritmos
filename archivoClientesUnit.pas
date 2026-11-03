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

end.