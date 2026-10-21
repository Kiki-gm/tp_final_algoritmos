unit archivoClientesUnit;

interface

type
    datosCliente = record
        DNI : String[8];
        apellidoYNombres : String[64];
        direccion : String[32];
        fechaDeNacimiento : String[8];
        celular : String[32];
        email : String[64];    
        activo : Boolean;
    end;

implementation
    uses archivosUnit, clientesUnit;


end.