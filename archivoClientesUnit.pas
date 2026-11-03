unit archivoClientesUnit;

interface
    uses clientesUnit, tiposUnit;

    type
        tArchivoClientes = file of datosCliente;

    procedure inicializarArchivoClientes(var f : tArchivoClientes; path : String);
    procedure leerArchivoClientes(var f : tArchivoClientes; pos : Cardinal; var data : datosCliente);
    procedure escribirArchivoClientes(var f : tArchivoClientes; pos : Cardinal; data : datosCliente);
    function ultimaLinea(var f : tArchivoClientes): Integer;    
    
    function busquedaBinariaDNI(var arch: tArchivoClientes; searched: tDNI): Word;
    procedure quicksortApellidoNombre(var arch: tArchivoClientes; first: Word; last: Word);


implementation

    procedure inicializarArchivoClientes(var f : tArchivoClientes; path : String);
    begin
        Assign (f,path);
        {$i-}
        Reset (f);
        {$i+}
        If IOresult<>0 then
            Rewrite(f);
    end;

    procedure leerArchivoClientes(var f : tArchivoClientes; pos : Cardinal; var data : datosCliente);
    var
        lastPos : Cardinal;
    begin
        lastPos := FilePos(f);
        Seek(f,pos);
        Read(f,data);
        Seek(f, lastPos);
    end;

    procedure escribirArchivoClientes(var f : tArchivoClientes; pos : Cardinal; data : datosCliente);
    var
        lastPos : Cardinal;
    begin
        lastPos := FilePos(f);
        Seek(f,pos);
        Write(f,data);
        Seek(f, lastPos);
    end;
    
    function ultimaLinea(var f : tArchivoClientes): Integer;
    begin
        ultimaLinea := FileSize(f) - 1;
    end;
    
    function busquedaBinariaDNI(var arch: tArchivoClientes; searched: tDNI): Word;
    var
        ini, fin, mid, pos: Word;
        temp: datosCliente;
    begin
        pos := 0;
        ini := 0;
        fin := ultimaLinea(arch);
        while (ini <= fin) and (pos = 0) do
        begin
            mid := (ini + fin) div 2;
            leerArchivoClientes(arch,mid,temp);
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