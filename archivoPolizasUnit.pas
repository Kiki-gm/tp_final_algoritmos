unit archivoPolizasUnit;

interface
    uses polizasUnit;

    type
        tArchivoPolizas = file of datosPoliza;

    procedure inicializarArchivoPolizas(var f : tArchivoPolizas; path : String);
    procedure leerArchivoPolizas(var f : tArchivoPolizas; pos : Cardinal; var data : datosPoliza);
    procedure escribirArchivoPolizas(var f : tArchivoPolizas; pos : Cardinal; data : datosPoliza);
    function ultimaLineaArchivoPolizas(var f : tArchivoPolizas): Integer;    



implementation

    procedure inicializarArchivoPolizas(var f : tArchivoPolizas; path : String);
    begin
        Assign (f,path);
        {$i-}
        Reset (f);
        {$i+}
        If IOresult<>0 then
            Rewrite(f);
    end;

    procedure leerArchivoPolizas(var f : tArchivoPolizas; pos : Cardinal; var data : datosPoliza);
    var
        lastPos : Cardinal;
    begin
        lastPos := FilePos(f);
        Seek(f,pos);
        Read(f,data);
        Seek(f, lastPos);
    end;

    procedure escribirArchivoPolizas(var f : tArchivoPolizas; pos : Cardinal; data : datosPoliza);
    var
        lastPos : Cardinal;
    begin
        lastPos := FilePos(f);
        Seek(f,pos);
        Write(f,data);
        Seek(f, lastPos);
    end;
    
    function ultimaLineaArchivoPolizas(var f : tArchivoPolizas): Integer;
    begin
        ultimaLineaArchivoPolizas := FileSize(f) - 1;
    end;

end.