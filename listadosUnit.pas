unit listadosUnit;

interface
uses archivoPolizasUnit, archivoClientesUnit;

Procedure suprimirEspacios(var fullName: String; var simpleName: String);
Procedure QuicksortApellidoNombre(var arch: tarchivoCliente ; path: String; first: byte; last: byte);

implementation

//Si se toma un String "fullname" con espacios, entonces la salida "simpleName" no los tendrá.
Procedure suprimirEspacios(var fullName: String; var simpleName: String);
var
  i : cardinal;
begin
    simplename := fullname;
    for i := 1 to sizeof(fullname[i]) do
    begin
        if fullname[i] = ' ' then
            delete(simplename,i,1);
    end;
end;

//En un futuro se sustituirá por un árbol de búsqueda.
Procedure QuicksortApellidoNombre(var arch: tarchivoCliente ; path: String; first: byte; last: byte);
var
  lower, upper: byte;
  temp, tempLower, tempUpper, pivot: datoscliente;
begin
    inicializarArchivoCliente(arch,path);
    lower := first;
    upper := last;
    seek(arch,(lower + upper) div 2);
    read(arch,pivot);

    repeat
        seek(arch,lower);
        read(arch,tempLower);
        while tempLower.apellidoYNombre < pivot do
            inc(lower);
        seek(arch,upper);
        read(arch,tempUpper);
        while tempUpper.apellidoYNombre > pivot do
            dec(upper);
        if lower <= upper then
        begin
            seek(arch,lower);
            read(arch, temp);
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