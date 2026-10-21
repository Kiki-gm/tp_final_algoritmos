unit menu;
{$codePage UTF-8}

interface

uses archivoClientesUnit, archivoPolizasUnit, arbolUnit, clientesUnit, polizasUnit, verificacionUnit, estadisticasUnit, listadosUnit; 
procedure menuPrincipal;



implementation

    procedure menuPrincipal;
    var
        //archivoClientes : TipoArchivosClientes;
        //archivoPolizas : TipoArchivoPolizas;
        //arbolDNI, arbolNombre : TipoArbol;
        opcion : 0..4;
    begin
        // CREAR_ABRIR ARCHIVOS
        // GENERAR ARBOLES
        repeat
            Write('Ingrese opcion: ');
            ReadLn(opcion);
            case opcion of
                1:
                    begin
                    
                    end;
                2:
                    begin
                    
                    end;
                3:
                    begin
                    
                    end;
                4:
                    begin
                    
                    end;
            end;
        until opcion = 0;
    end;
end.