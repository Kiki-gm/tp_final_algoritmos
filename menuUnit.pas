unit menuUnit;
{$codePage UTF-8}

interface

uses crt, interfazDeUsuarioUnit, archivoClientesUnit, archivoPolizasUnit, arbolUnit, clientesUnit, polizasUnit, verificacionUnit, estadisticasUnit, listadosUnit, tiposUnit; 

procedure menuPrincipal;

implementation

    procedure menuModificacionCliente(var f : tArchivoClientes; indiceRegistro : Integer; var cliente : datosCliente);
    var
        ventanaDatos : infoVentana;
        menuConfirmacion : registroMenu;
        teclaPresionada : tecla;
        seleccion, seleccionConfirmacion : Integer;
        salirMenu : Boolean;
        tempString : String;

        procedure editarFechaLocal;
        var
            tempD, tempM, tempA : Integer;
            campoSeleccionado : Integer; 
            k : tecla;
            activo : Boolean;
        begin
            tempD := cliente.fechaDeNacimiento.D;
            tempM := cliente.fechaDeNacimiento.M;
            tempA := cliente.fechaDeNacimiento.A;
            campoSeleccionado := 1;
            activo := true;

            repeat
                GotoXY(ventanaDatos.topLeft.x + 15, ventanaDatos.topLeft.y + 6);

                if campoSeleccionado = 1 then TextColor(Yellow) else TextColor(White);
                if tempD < 10 then Write('0', tempD) else Write(tempD);

                TextColor(White);
                Write('/');

                if campoSeleccionado = 2 then TextColor(Yellow) else TextColor(White);
                if tempM < 10 then Write('0', tempM) else Write(tempM);

                TextColor(White);
                Write('/');

                if campoSeleccionado = 3 then TextColor(Yellow) else TextColor(White);
                Write(tempA);
                
                TextColor(Cyan);

                GotoXY(dimensionesDeTerminal.x,dimensionesDeTerminal.y);

                k := leerTecla;

                case k of
                    izquierda:
                    begin
                        if campoSeleccionado > 1 then 
                            campoSeleccionado := campoSeleccionado - 1;
                    end;

                    derecha:
                    begin
                        if campoSeleccionado < 3 then 
                            campoSeleccionado := campoSeleccionado + 1;
                    end; 

                    arriba:
                    begin
                        if campoSeleccionado = 1 then
                        begin
                            Inc(tempD);
                            if tempD > 31 then tempD := 1;
                        end
                        else if campoSeleccionado = 2 then
                        begin
                            Inc(tempM);
                            if tempM > 12 then tempM := 1;
                        end
                        else if campoSeleccionado = 3 then
                        begin
                            Inc(tempA);
                        end;
                    end;

                    abajo:
                    begin
                        if campoSeleccionado = 1 then
                        begin
                            Dec(tempD);
                            if tempD < 1 then tempD := 31;
                        end
                        else if campoSeleccionado = 2 then
                        begin
                            Dec(tempM);
                            if tempM < 1 then tempM := 12;
                        end
                        else if (campoSeleccionado = 3) and (tempA > 999) then
                            Dec(tempA);
                    end;

                    enter, escape:
                    begin
                        activo := false;
                    end;
                end;
            until not activo;

            if k = enter then
            begin
                cliente.fechaDeNacimiento.D := tempD;
                cliente.fechaDeNacimiento.M := tempM;
                cliente.fechaDeNacimiento.A := tempA;
                EscribirArchivoClientes(f, indiceRegistro, cliente);
            end;
        end;

        procedure dibujarFormulario(sel : Integer; actualizando : Boolean);
        var
            i : Integer; 
        begin
            dibujarEscape(false);
            ventanaDatos := dibujarVentana('Datos de Cliente con DNI: ' + cliente.DNI, 55, 13, 0, 0);
            
            if ventanaDatos.topLeft.x <> 0 then
            begin
                for i := 1 to 7 do
                begin
                    GotoXY(ventanaDatos.cursor.x, ventanaDatos.cursor.y);
                    
                    if i = sel then
                    begin
                        TextColor(Cyan);
                        if actualizando then
                            Write('> [EDITANDO] ')
                        else
                            Write('> ');
                    end
                    else
                    begin
                        TextColor(White);
                        Write('    ');
                    end;
                    
                    case i of
                        1: begin
                                Write('Apellidos y Nombres: ');
                                if actualizando and (i = sel) then 
                                begin
                                    TextColor(White);
                                    Write(tempString, '_ ');
                                    TextColor(Cyan); 
                                end 
                                else 
                                    Write(cliente.apellidoYNombres);
                        end;
                        2: begin
                                Write('Direccion: ');
                                if actualizando and (i = sel) then 
                                begin
                                    TextColor(White);
                                    Write(tempString, '_ ');
                                    TextColor(Cyan);
                                end 
                                else 
                                    Write(cliente.direccion);
                        end;
                        3: begin
                                Write('Fecha Nac: ');
                                TextColor(White);
                                Write(cliente.fechaDeNacimiento.D, '/', 
                                    cliente.fechaDeNacimiento.M, '/', 
                                    cliente.fechaDeNacimiento.A);
                                TextColor(Cyan);
                        end;
                        4: begin
                                Write('Celular: ');
                                if actualizando and (i = sel) then 
                                begin
                                    TextColor(White);
                                    Write(tempString, '_ ');
                                    TextColor(Cyan);
                                end 
                                else 
                                    Write(cliente.celular);
                        end;
                        5: begin
                                Write('Email: ');
                                if actualizando and (i = sel) then 
                                begin
                                    TextColor(White);
                                    Write(tempString, '_ ');
                                    TextColor(Cyan);
                                end 
                                else 
                                    Write(cliente.email);
                        end;
                        6: Write('Estado: ', cliente.estado);
                        7: begin
                                if cliente.estado then
                                begin
                                    TextColor(LightRed);
                                    Write('--- DAR DE BAJA ---');
                                end
                                else
                                begin
                                    TextColor(LightGreen);
                                    Write('--- DAR DE ALTA ---');
                                end;
                                TextColor(White);
                        end;
                    end;
                    
                    Inc(ventanaDatos.cursor.y);
                end;
            end;
            GotoXY(dimensionesDeTerminal.x, dimensionesDeTerminal.y);
        end;

    begin
        seleccion := 1;
        salirMenu := false;
        
        repeat
            if seleccionConfirmacion <> 1 then
                ClrScr;
            
            seleccionConfirmacion := 0;

            dibujarFormulario(seleccion, false);
            teclaPresionada := leerTecla;
            
            case teclaPresionada of
                arriba: seleccion := (seleccion + 5) mod 7 + 1; // Equivale a restar 1
                abajo: seleccion := seleccion mod 7 + 1; // Equivale a sumar 1
                escape: salirMenu := true;
                enter:
                    begin
                        case seleccion of
                            1,2,4,5:
                            begin
                                case seleccion of
                                    1: tempString := cliente.apellidoYNombres;
                                    2: tempString := cliente.direccion;
                                    4: tempString := cliente.celular;
                                    5: tempString := cliente.email;
                                end;
                                
                                repeat
                                    dibujarFormulario(seleccion, true);
                                    
                                    case seleccion of
                                        1,5: teclaPresionada := leerSoloTexto(tempString, 64);
                                        2,4: teclaPresionada := leerSoloTexto(tempString, 32);
                                    end;
                                until (teclaPresionada = enter) or (teclaPresionada = escape);
                                
                                if teclaPresionada = enter then
                                begin
                                    case seleccion of
                                        1: cliente.apellidoYNombres := tempString;
                                        2: cliente.direccion := tempString;
                                        4: cliente.celular := tempString;
                                        5: cliente.email := tempString;
                                    end;
                                    EscribirArchivoClientes(f, indiceRegistro, cliente);
                                end;
                            end;
                            3: editarFechaLocal;
                            7: 
                            begin
                                inicializarMenu(menuConfirmacion);
                                agregarOpcion(menuConfirmacion, 'Si');
                                agregarOpcion(menuConfirmacion, 'No');
                                seleccionConfirmacion := 1;
                                
                                if cliente.estado then
                                    menuHorizontal('Esta seguro que desea dar de baja?', menuConfirmacion, seleccionConfirmacion, 30, 7, 0, 11)
                                else
                                    menuHorizontal('Esta seguro que desea dar de alta?', menuConfirmacion, seleccionConfirmacion, 30, 7, 0, 11);
                            
                                if seleccionConfirmacion = 1 then
                                begin
                                    cliente.estado := not cliente.estado; 
                                    EscribirArchivoClientes(f, indiceRegistro, cliente);
                                    ClrScr;
                                end;
                            end;
                        end;
                    end;
            end;
        until salirMenu;
    end;

    procedure salirDelPrograma(var clientsF : tArchivoClientes);
    var
        temp : String[3];
        i,j : Byte;
    begin
        {$i-}
        Close(clientsF);
        {$i+}

        ClrScr;
        for i := 1 to 3 do
        begin
            temp := '';
            for j := 1 to i do
            begin
                temp := temp + '.';
            end;
            dibujarVentana('Saliendo' + temp, 15, 5, 0, 0);
            GotoXY(dimensionesDeTerminal.x, dimensionesDeTerminal.y);
            Delay(1000);
        end;
        ClrScr;
    end;

    procedure gestionDeClientes(var f : tArchivoClientes);
    var
        ventanaActual : infoVentana;
        menuActual : registroMenu;
        tempString : String;
        teclaPresionada : tecla;
        seleccionActual, indiceBusquedaBinaria : Integer;
        cliente : datosCliente;
        stop : Boolean;
    begin
        ClrScr;
        tempString := '';
        stop := false;
        dibujarEscape(false);
        ventanaActual := dibujarVentana('Gestion de clientes', 24, 7, 0, 0);
        repeat
            escribirEnVentana(ventanaActual, 'DNI: ' + tempString);
            
            teclaPresionada := leerSoloNumeros(tempString, 8);
            
            if teclaPresionada = escape then
                stop := true;
                
            if (teclaPresionada = enter) and esDNI(tempString) then
                stop := true;  
        until stop;
        
        if teclaPresionada <> escape then
        begin
            tempString := completarCeros(tempString);

            indiceBusquedaBinaria := busquedaBinariaDNI(f, tempString);

            if indiceBusquedaBinaria = -1 then
            begin
                ClrScr;
                inicializarMenu(menuActual);
                agregarOpcion(menuActual, 'Registrar');
                agregarOpcion(menuActual, 'Salir');
                seleccionActual := 1;
                menuHorizontal('El DNI ' + tempString  + ' no esta registrado', menuActual, seleccionActual, 30, 7, 0, 0);

                if seleccionActual = 1 then
                begin
                    inicializarCliente(cliente, tempString);
                    AgregarCliente(f, cliente);
                    menuModificacionCliente(f, ultimaLineaArchivoClientes(f), cliente);
                end;
            end
            else
            begin
                cliente := buscarDatosCliente(f, indiceBusquedaBinaria);
                menuModificacionCliente(f, indiceBusquedaBinaria, cliente);
            end;
        end;
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
        menuPrincipal : registroMenu;
        seleccion : Integer;
        archivoClientes : tArchivoClientes;
    begin
        InicializarArchivoClientes(archivoClientes, 'clientes.dat');

        inicializarMenu(menuPrincipal);
        agregarOpcion(menuPrincipal, 'Gestion de clientes');
        agregarOpcion(menuPrincipal, 'Gestion de polizas');
        agregarOpcion(menuPrincipal, 'Listado');
        agregarOpcion(menuPrincipal, 'Estadisticas');

        seleccion := 1;

        repeat
            ClrScr;
            seleccion := 1;
            menuVertical('Menu principal', menuPrincipal, seleccion, 0, 0);

            case seleccion of 
                -1: salirDelPrograma(archivoClientes);
                1: gestionDeClientes(archivoClientes);
                2: gestionDePolizas;
                3: listado;
                4: estadisticas;
            end;

        until seleccion = -1;
    end;

end.