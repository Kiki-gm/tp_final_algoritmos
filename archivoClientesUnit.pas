unit archivoClientesUnit;

interface
    uses clientesUnit, tiposUnit;

    type
        tArchivoClientes = file of datosCliente;

    procedure InicializarArchivoClientes(var f : tArchivoClientes; path : String);
    procedure LeerArchivoClientes(var f : tArchivoClientes; pos : Cardinal; var data : datosCliente);
    procedure EscribirArchivoClientes(var f : tArchivoClientes; pos : Cardinal; data : datosCliente);
    function UltimaLinea(var f : tArchivoClientes): Integer;    
    
    function busquedaBinariaDNI(var arch: tArchivoClientes; searched: tDNI): Word;



implementation

    procedure InicializarArchivoClientes(var f : tArchivoClientes; path : String);
    begin
        Assign (f,path);
        {$i-}
        Reset (f);
        {$i+}
        If IOresult<>0 then
            Rewrite(f);
    end;

    procedure LeerArchivoClientes(var f : tArchivoClientes; pos : Cardinal; var data : datosCliente);
    var
        lastPos : Cardinal;
    begin
        lastPos := FilePos(f);
        Seek(f,pos);
        Read(f,data);
        Seek(f, lastPos);
    end;

    procedure EscribirArchivoClientes(var f : tArchivoClientes; pos : Cardinal; data : datosCliente);
    var
        lastPos : Cardinal;
    begin
        lastPos := FilePos(f);
        Seek(f,pos);
        Write(f,data);
        Seek(f, lastPos);
    end;
    
    function UltimaLinea(var f : tArchivoClientes): Integer;
    begin
        UltimaLinea := FileSize(f) - 1;
    end;
    
    function busquedaBinariaDNI(var arch: tArchivoClientes; searched: tDNI): Word;
    var
        ini, fin, mid, pos: Word;
        temp: datosCliente;
    begin
        pos := 0;
        ini := 0;
        fin := UltimaLinea(arch);
        while (ini <= fin) and (pos = 0) do
        begin
            mid := (ini + fin) div 2;
            LeerArchivoClientes(arch,mid,temp);
            if searched = temp.dni then
                pos := mid
            else 
            begin
                if searched < temp.dni then
                    fin := mid - 1
                else if searched > temp.dni then
                    ini := mid + 1;
            end;   
        end;
        busquedaBinariaDNI := pos;
    end;

end.