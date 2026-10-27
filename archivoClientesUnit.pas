unit archivoClientesUnit;

interface
uses clientesUnit,archivosUnit;

type
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

implementation

end.