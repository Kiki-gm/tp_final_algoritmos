unit archivoClientesUnit;

interface
    uses clientesUnit, tiposUnit;

    type
        tArchivoClientes = file of datosCliente;

    procedure InicializarArchivoClientes(var f : tArchivoClientes; path : String);
    procedure LeerArchivoClientes(var f : tArchivoClientes; pos : Cardinal; var data : datosCliente);
    procedure EscribirArchivoClientes(var f : tArchivoClientes; pos : Cardinal; data : datosCliente);
    function UltimaLinea(var f : tArchivoClientes): Integer;    
    
    function busquedaBinariaDNI(var arch: tArchivoClientes; searched: tDNI): Integer;
    function buscarDatosCliente(var arch: tArchivoClientes; i : Word): datosCliente;
    function completarCeros(dni : tDNI) : tDNI;


implementation

    procedure InicializarArchivoClientes(var f : tArchivoClientes; path : String);
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

    procedure LeerArchivoClientes(var f : tArchivoClientes; pos : Cardinal; var data : datosCliente);
    begin
        Seek(f,pos);
        Read(f,data);
    end;

    procedure EscribirArchivoClientes(var f : tArchivoClientes; pos : Cardinal; data : datosCliente);
    begin
        Seek(f,pos);
        Write(f,data);
    end;
    
    function UltimaLinea(var f : tArchivoClientes): Integer;
    begin
        UltimaLinea := FileSize(f) - 1;
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
            fin := UltimaLinea(arch);

            while (ini <= fin) and (pos = -1) do
            begin
                mid := (ini + fin) div 2;
                LeerArchivoClientes(arch, mid, temp);

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

    function completarCeros(dni : tDNI) : tDNI;
    var
        s : tDNI;
    begin
        s := dni;
        while Length(s) < 8 do
            s := '0' + s;
        completarCeros := s;
    end;

end.