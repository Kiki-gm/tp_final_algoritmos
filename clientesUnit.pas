unit clientesUnit;

interface

type
    tDNI = string[8];
    tApellidoYNombres = String[64];
    tDireccion = String[32];
    tFecha = record
        yy : word;
        mm : 1..12;
        dd : 1..31;
    end;
    tCelular = String[32];
    tEmail = String[64];

    datosCliente = record
        DNI : tDNI;
        apellidoYNombres : tApellidoYNombres;
        direccion : tDireccion;
        fechaDeNacimiento : tFecha; //Nótese que la fecha se ha cambiado de un String[8] a un record. Considerar revertir el cambio de ser conveniente.
        celular : tCelular;
        email : tEmail;    
        activo : Boolean;
    end;

    tArchivoCliente = file of datosCliente;

Procedure busquedaBinariaDNI(var arch: tarchivoCliente ; path: String; searched: tDNI; var pos: word);


implementation

Procedure busquedaBinariaDNI(var arch: tarchivoCliente ; path: String; searched: tDNI; var pos: word);
var
    ini, fin, mid: word;
    temp: datosCliente;
begin
    ini := 0;
    fin := filesize(arch)-1;
    while (ini <= fin) and (pos = 0) do
    begin
        mid := (ini + fin) div 2;
        seek(arch, mid);
        read(arch, temp);
        if searched = temp.dni then
        begin
            pos := mid;
        end 
        else 
        begin
            if searched < temp.dni then
            begin
                fin := mid - 1;
            end
            else if searched > temp.dni then
            begin
                ini := mid + 1;
            end; 
        end;   
    end;   
end;

end.