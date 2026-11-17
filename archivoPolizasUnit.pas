unit archivoPolizasUnit;

interface
    uses polizasUnit,verificacionUnit, tiposUnit;

    type
        tArchivoPolizas = file of datosPoliza;

    procedure inicializarArchivoPolizas(var f : tArchivoPolizas; path : String);
    procedure escribirArchivoPolizas(var f : tArchivoPolizas; pos : Cardinal; data : datosPoliza);
    procedure leerArchivoPolizas(var f : tArchivoPolizas; pos : Cardinal; var data : datosPoliza);
    procedure obtenerArchivoPolizas(var f : tArchivoPolizas; pos : Cardinal; var data : datosPoliza);
    function ultimaLineaArchivoPolizas(var f : tArchivoPolizas): Integer;

    procedure agregarPoliza(var f : tArchivoPolizas; data :datosPoliza);
    function buscarIndicePoliza(var f : tArchivoPolizas; dni : tDNI; patente : tPatente) : Integer;
    function generarNumeroDePoliza(var arch : tArchivoPolizas; num : cardinal) : String;


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
    begin
        Seek(f,pos);
        Read(f,data);
    end;

    procedure escribirArchivoPolizas(var f : tArchivoPolizas; pos : Cardinal; data : datosPoliza);
    begin
        Seek(f,pos);
        Write(f,data);
    end;

    procedure obtenerArchivoPolizas(var f : tArchivoPolizas; pos : Cardinal; var data : datosPoliza);
    begin
        Seek(f, pos);
        Read(f, data);
    end;
    
    function ultimaLineaArchivoPolizas(var f : tArchivoPolizas): Integer;
    begin
        ultimaLineaArchivoPolizas := FileSize(f) - 1;
    end;

    {Como sólo hay opción de baja lógica, no de eliminar, tiene sentido presumir
     que el número de póliza corresponderá con su ubicación en el archivo una vez esta se añade.
     Por lo tanto, lo único que queda es embellecerlo un poco para que tenga una longitud sensata.}
    function generarNumeroDePoliza(var arch : tArchivoPolizas; num : cardinal) : String;
    begin
        generarNumeroDePoliza := numeroConCeros(filesize(arch),32);
    end;

    function buscarIndicePoliza(var f : tArchivoPolizas; dni : tDNI; patente : tPatente) : Integer;
    var
        i, tempI : Integer;
        tempPoliza : datosPoliza;
    begin
        tempI := -1;
        if (FileSize(f) > 0) then
        begin
            i := 0;
            repeat
                leerArchivoPolizas(f,i,tempPoliza);
                if (tempPoliza.DNI = dni) and (tempPoliza.patente = patente) and (tempI = -1) then
                    tempI := i;
                Inc(i);
            until (i > ultimaLineaArchivoPolizas(f));
        end;
        buscarIndicePoliza := tempI;
    end;

    procedure agregarPoliza(var f : tArchivoPolizas; data :datosPoliza);
    begin
        Seek(f,FileSize(f));
        Write(f,data);
    end;
end.