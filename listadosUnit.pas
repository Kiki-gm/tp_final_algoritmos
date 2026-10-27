unit listadosUnit;

interface
uses archivoPolizasUnit, archivoClientesUnit, clientesUnit, polizasUnit;

Procedure suprimirEspacios(var fullName: String; var simpleName: String); // Creo que esto puede ir a la unit de validaciones, o podemos crear una unit aparte para trabajar los strings, pero no estoy seguro, lo hablamos en clase.
Procedure QuicksortApellidoNombre(var arch: tArchivoClientes ; path: String; first: Word; last: Word);

implementation

    //Si se toma un String "fullname" con espacios, entonces la salida "simpleName" no los tendrá.
    Procedure suprimirEspacios(var fullName: String; var simpleName: String);
    var
    i : Cardinal;
    begin
        simplename := fullname;
        for i := 1 to SizeOf(fullname) do
        begin
            if fullname[i] = ' ' then
                delete(simplename,i,1);
        end;
    end;

    //En un futuro se sustituirá por un árbol de búsqueda.
    Procedure QuicksortApellidoNombre(var arch: tArchivoClientes ; path: String; first: Word; last: Word);
    var
    lower, upper: Word;
    temp, tempLower, tempUpper, pivot: datosCliente;
    begin
        InicializarArchivoClientes(arch,path);
        lower := first;
        upper := last;
        LeerArchivoClientes(arch, (lower + upper) div 2, pivot);

        repeat
            LeerArchivoClientes(arch,lower,tempLower);

            while tempLower.apellidoYNombres < pivot.apellidoYNombres do
            begin
                inc(lower);
                LeerArchivoClientes(arch,upper,tempUpper);
            end;
            
            while tempUpper.apellidoYNombres > pivot.apellidoYNombres do
                dec(upper);

            if lower <= upper then
            begin
                LeerArchivoClientes(arch,lower,temp);
                tempLower := tempUpper;
                tempUpper := temp;
                inc(lower);
                dec(upper);
            end;

        until lower > upper;

        if upper > first then
            QuicksortApellidoNombre(arch, path, first, upper);
        
        if lower < last then
            QuicksortApellidoNombre(arch, path, lower, last);
    end;  

end.