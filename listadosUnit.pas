unit listadosUnit;

interface
uses archivoPolizasUnit, archivoClientesUnit, clientesUnit, polizasUnit;

const //Placeholder.
    n = 5;

type //Placeholder. Modificar según sea necesario.
    tDatoLista = Integer;
    tLista = record
        elem : array[1..n] OF tDatoLista;
        tam : byte;
    end;

procedure listaCrear(var l : tLista);
procedure listaAdd(var l : tLista; x: tDatoLista); //La Ñ no es nativamente interpretada en todos los entornos de Pascal, por lo que se opta por una alternativa.
procedure listaRecuperar(var l : tLista;pos : byte; x : tDatoLista);
procedure listaModificar(var l : tLista; pos : byte; var x : tDatoLista);
function listaLlena(var l: tLista): boolean;
function listaVacia(var l: tLista): boolean;
function listaSize(var l: tLista): byte;
procedure listaOrdenar(var l : tLista; pos : byte);
procedure listaBurbuja(var l : tLista);
procedure listaBorrar(var l : tLista; pos : byte; var x : tDatoLista);
procedure listaMostrar(var l : tLista);
Procedure suprimirEspacios(var fullName: String; var simpleName: String); // Creo que esto puede ir a la unit de validaciones, o podemos crear una unit aparte para trabajar los strings, pero no estoy seguro, lo hablamos en clase.
Procedure QuicksortApellidoNombre(var arch: tArchivoClientes ; path: String; first: Word; last: Word);

implementation

        procedure listaCrear(var l : tLista);
    begin
        l.tam := 0;
    end;

    procedure listaAdd(var l : tLista; x: tDatoLista);
    begin
        inc(l.tam);
        l.elem[l.tam] := x;
    end;

    procedure listaRecuperar(var l : tLista;pos : byte; x : tDatoLista);
    begin
        x := l.elem[pos];
    end;

    procedure listaModificar(var l : tLista; pos : byte; var x : tDatoLista);
    begin
        l.elem[pos] := x;
    end;

    function listaLlena(var l: tLista): boolean;
    begin
        listaLlena := l.tam = N;
    end;

    function listaVacia(var l: tLista): boolean;
    begin
        listaVacia := l.tam = N;
    end;

    function listaSize(var l: tLista):byte;
    begin
        listaSize := l.tam;
    end;

    procedure listaOrdenar(var l : tLista; pos : byte);
    var 
        i : 1..n;
    begin
        for i := pos to listaSize(l)-1 do
        begin
            l.elem[i] := l.elem[i+1];  
        end;
    end;

    procedure listaBorrar(var l : tLista; pos : byte; var x : tDatoLista);
    begin

        x := l.elem[pos];

        if pos <> listaSize(l) then
        begin
            listaOrdenar(l, pos);  
        end;

        dec(l.tam);

    end;

    procedure listaBurbuja(var l : tLista);
    var
        i, j : byte;
        temp1, temp2 : tDatoLista;

    begin
        for i := 1 to listaSize(l)-1 do
        begin
            for j := 1 to listaSize(l)-i do
            begin
                listaRecuperar(l,j,temp1);
                listaRecuperar(l,j+1,temp2);

                if temp1 > temp2 then
                begin
                listaModificar(l, j, temp2);
                listaModificar(l, j+1, temp1);
                end;  
            end;
        end;
    end;

    procedure listaMostrar(var l : tLista);
    var
        i : byte;
        x : tDatoLista;
    begin
        for i := 1 to listaSize(l) do
        begin
            listaRecuperar(l,i,x);
            Writeln(x);
        end;
    end;

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