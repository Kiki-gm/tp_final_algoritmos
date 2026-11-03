unit clientesUnit;

interface
uses tiposUnit;

type
    datosCliente = record
        DNI : tDNI;
        apellidoYNombres : tApellidoYNombres;
        direccion : tDireccion;
        fechaDeNacimiento : tFecha; //Nótese que la fecha se ha cambiado de un String[8] a un record. Considerar revertir el cambio de ser conveniente.
        celular : tCelular;
        email : tEmail;    
        estado : tEstado;
    end;

{Se añaden acá por ahora, para evitar un choque de dependencias entre tiposUnit,clientesUnit y verificationUnit}
function aplicarMayus(nombre : tApellidoYNombres):tApellidoYNombres; 
function DispParaAlta(var cliente : datosCliente):Boolean;

implementation

{Si algún campo está vacío, el registro del cliente no está disponible para el alta. 
Falta añadir compatibilidad con tFecha para el primer condicional.}
function DispParaAlta(var cliente : datosCliente):Boolean;
begin
    if (cliente.ApellidoYNombres = '') or (cliente.direccion = '') or (cliente.email = '') then  
    begin
        DispParaAlta := False;  
    end
    else
        DispParaAlta := true;
end;

{Aplica mayusculas a la primer letra, y a cualquier subcadena de dos o más caractéres, 
precedida por un espacio blanco. Esto le permite funcionar con nombres como "Lin Wu", "D'artagnan", o "Jean-Pierre"}
function aplicarMayus(nombre : tApellidoYNombres):tApellidoYNombres;
    var
    i : Cardinal;
    temp : tApellidoYNombres;
    begin
        temp := nombre;

        if (ord(nombre[1]) >= 97) and (ord(nombre[1]) <= 119) then
            temp[1] := upcase(nombre[1]);

        for i := 2 to i-1 do
        begin
            if (ord(nombre[i]) >= 97) and (ord(nombre[i]) <= 119) then
            begin
                if (ord(nombre[i-1]) = 32) or (ord(nombre[i-1]) = 45)  and (ord(nombre[i+1]) <> 32) then
                    temp[i] := upcase(nombre[i]);  
            end;
        end;
        aplicarMayus := temp;
    end;

end.