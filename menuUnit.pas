unit menuUnit;
{$codePage UTF-8}

interface

uses crt, interfazDeUsuarioUnit, archivoClientesUnit, archivoPolizasUnit, arbolUnit, clientesUnit, polizasUnit, verificacionUnit, estadisticasUnit, listadosUnit; 

procedure menuPrincipal;
procedure salirDelPrograma;
procedure gestionDeClientes;
procedure gestionDePolizas;
procedure listado;
procedure estadisticas;

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
            GotoXY(dimensionesDeTerminal.x,dimensionesDeTerminal.y);
            Delay(1000);
        end;
        ClrScr;
    end;

    procedure gestionDeClientes;
    begin
      
    end;

    procedure gestionDePolizas;
    begin
      
    end;

    procedure listado;
    begin
      
    end;

    procedure estadisticas; 
    begin
      
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

        repeat

            seleccion := 1;
            menu('Menu principal', menuActual, seleccion, false);

            case seleccion of 
                -1: salirDelPrograma;
                1: gestionDeClientes;
                2: gestionDePolizas;
                3: listado;
                4: estadisticas;
            end;

        until seleccion = -1;
    end;
end.