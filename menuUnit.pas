unit menuUnit;
{$codePage UTF-8}

interface

uses crt, interfazDeUsuarioUnit, archivoClientesUnit, archivoPolizasUnit, arbolUnit, clientesUnit, polizasUnit, verificacionUnit, estadisticasUnit, listadosUnit; 
procedure menuPrincipal;
procedure salirDelPrograma;

implementation

    procedure salirDelPrograma;
    var
        temp : String[3];
        i,j : Byte;
    begin
        ClrScr;
        for i := 1 to 3 do
        begin
            temp := '';
            for j := 1 to i do
            begin
                temp := temp + '.';
            end;
            dibujarVentana('Saliendo' + temp, 15, 5);
            Delay(1000);
        end;
        ClrScr;
    end;

    procedure menuPrincipal;
    var
        menuActual : registroMenu;
        seleccion : Integer;

    begin
        
        inicializarMenu(menuActual);
        agregarOpcion(menuActual, 'Gestion de clientes');
        agregarOpcion(menuActual, 'Gestion de polizas');
        agregarOpcion(menuActual, 'Listado');
        agregarOpcion(menuActual, 'Estadisticas');
        seleccion := 1;
        
        menu('Menu principal', menuActual, seleccion);

        // case seleccion of 
        //     -1: salirDelPrograma;
        //     1: gestionDeClientes;
        //     2: gestionDePolizas;
        //     3: listado;
        //     4: estadisticas;
        // end;
        
        WriteLn('Presiona una tecla para salir...');
        ReadKey;
    end;
end.