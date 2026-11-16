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
    function valorCuota(poliza : datosPoliza) : Real;


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

    {Se determina la cantidad de meses a pagar, y se divide la suma total por eso.}
    function valorCuota(poliza : datosPoliza) : Real;
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
        mesesExactos := contM - (1/diasMesIni * tempD1) - ((1/diasMesFin) * (diasMesFin - tempD2));
    
        valorCuota := tempTotal/mesesExactos; //Considerar que internamente, se suele trabajar con 6 decimales en las empresas de pólizas.
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