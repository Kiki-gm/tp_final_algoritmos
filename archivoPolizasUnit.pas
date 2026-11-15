unit archivoPolizasUnit;

interface
    uses polizasUnit,verificacionUnit;

    type
        tArchivoPolizas = file of datosPoliza;

    procedure inicializarArchivoPolizas(var f : tArchivoPolizas; path : String);
    procedure leerArchivoPolizas(var f : tArchivoPolizas; pos : Cardinal; var data : datosPoliza);
    procedure escribirArchivoPolizas(var f : tArchivoPolizas; pos : Cardinal; data : datosPoliza);
    function ultimaLineaArchivoPolizas(var f : tArchivoPolizas): Integer;    
    function generarNumeroDePoliza(var arch : tArchivoPolizas; num : cardinal; cant : byte):String;


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

    {Como sólo hay opción de baja lógica, no de eliminar, tiene sentido presumir
     que el número de póliza corresponderá con su ubicación en el archivo una vez esta se añade.
     Por lo tanto, lo único que queda es embellecerlo un poco para que tenga una longitud sensata.}
    function generarNumeroDePoliza(var arch : tArchivoPolizas; num : cardinal; cant : byte):String;
    var
        temp : cardinal;
        tempStr : String;
    begin
        temp := filesize(arch);
        tempStr := integerToString(temp);
        while length(tempStr) < cant do //cantidad deseada de cifras en número de póliza.
        begin
            tempStr := '0' + tempStr;  
        end; 
        generarNumeroDePoliza := tempStr;
    end;

    {Se determina la cantidad de meses a pagar, y se divide la suma total por eso.}
    function valorCuota(poliza : datosPoliza):Real;
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

end.