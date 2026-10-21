unit menu;
{$codePage UTF-8}

interface

uses interfazDeUsuarioUnit, archivoClientesUnit, archivoPolizasUnit, arbolUnit, clientesUnit, polizasUnit, verificacionUnit, estadisticasUnit, listadosUnit; 
procedure menuPrincipal;



implementation

    procedure menuPrincipal;
    var
        {Todo lo que sigue no tengo ni idea que sera (?}
        //archivoClientes : TipoArchivosClientes;
        //archivoPolizas : TipoArchivoPolizas;
        //arbolDNI, arbolNombre : TipoArbol;
        opcion : 0..4;
        temp : String;
    begin
        {Inicializaciones i guess}
        // CREAR_ABRIR ARCHIVOS
        // GENERAR ARBOLES
        opcion := 0;
        repeat
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