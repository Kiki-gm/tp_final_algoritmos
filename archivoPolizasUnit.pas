unit archivoPolizasUnit;

interface
    uses polizasUnit;

    type
        tArchivoPolizas = file of datosPoliza;

    procedure InicializarArchivoPolizas(var f : tArchivoPolizas; path : String);
    procedure LeerArchivoPolizas(var f : tArchivoPolizas; pos : Cardinal; var data : datosPoliza);
    procedure EscribirArchivoPolizas(var f : tArchivoPolizas; pos : Cardinal; data : datosPoliza);
    function UltimaLinea(var f : tArchivoPolizas): Integer;    



implementation

    procedure InicializarArchivoPolizas(var f : tArchivoPolizas; path : String);
    begin
        Assign (f,path);
        {$i-}
        Reset (f);
        {$i+}
        If IOresult<>0 then
            Rewrite(f);
    end;

    procedure LeerArchivoPolizas(var f : tArchivoPolizas; pos : Cardinal; var data : datosPoliza);
    var
        lastPos : Cardinal;
    begin
        lastPos := FilePos(f);
        Seek(f,pos);
        Read(f,data);
        Seek(f, lastPos);
    end;

    procedure EscribirArchivoPolizas(var f : tArchivoPolizas; pos : Cardinal; data : datosPoliza);
    var
        lastPos : Cardinal;
    begin
        lastPos := FilePos(f);
        Seek(f,pos);
        Write(f,data);
        Seek(f, lastPos);
    end;
    
    function UltimaLinea(var f : tArchivoPolizas): Integer;
    begin
        UltimaLinea := FileSize(f) - 1;
    end;

end.