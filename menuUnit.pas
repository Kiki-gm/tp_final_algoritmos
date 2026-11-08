unit menuUnit;
{$codePage UTF-8}

interface

uses crt, interfazDeUsuarioUnit, archivoClientesUnit, archivoPolizasUnit, arbolUnit, clientesUnit, polizasUnit, verificacionUnit, estadisticasUnit, listadosUnit, tiposUnit; 

procedure menuPrincipal;

implementation

    const
        minA = 1800;
        maxA = 2008;

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
            dibujarVentana('Saliendo' + temp, 15, 0, 0, 0);
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
        registrado, stop : Boolean;

        type
            tModoFormulario = (modoVer, modoEditar, modoAlta);

            tCompletados = array[1..5] of Boolean;

            registroFormulario = record
                modo          : tModoFormulario;
                ventana       : infoVentana; 
                seleccion     : 1..7;
                editandoTexto : Boolean;
                textoTemp     : String;
                campoFecha    : 0..3; 
                completados   : tCompletados;
            end;

        // validacion dejada vacia a proposito
        function campoValido(campo : Integer; cliente : datosCliente) : Boolean;
        begin
            campoValido := true;
        end;

        function etiquetaCampo(campo : Integer) : String;
        begin
            case campo of
                1: etiquetaCampo := 'Apellidos y Nombres: ';
                2: etiquetaCampo := 'Direccion: ';
                3: etiquetaCampo := 'Fecha Nac: ';
                4: etiquetaCampo := 'Celular: ';
                5: etiquetaCampo := 'Email: ';
            else
                etiquetaCampo := '';
            end;
        end;

        function obtenerCampo(cliente : datosCliente; campo : Integer) : String;
        begin
            case campo of
                1: obtenerCampo := cliente.apellidoYNombres;
                2: obtenerCampo := cliente.direccion;
                4: obtenerCampo := cliente.celular;
                5: obtenerCampo := cliente.email;
            else
                obtenerCampo := '';
            end;
        end;

        procedure asignarCampo(var cliente : datosCliente; campo : Integer; valor : String);
        begin
            case campo of
                1: cliente.apellidoYNombres := valor;
                2: cliente.direccion := valor;
                4: cliente.celular := valor;
                5: cliente.email := valor;
            end;
        end;

        function moverSeleccion(sel, delta : Integer) : Integer;
        begin
            repeat
                sel := sel + delta;
                if sel < 1 then sel := 7;
                if sel > 7 then sel := 1;
            until sel <> 6;
            moverSeleccion := sel;
        end;

        function todosCompletados(form : registroFormulario) : Boolean;
        var
            i : Integer;
            ok : Boolean;
        begin
            ok := true;
            for i := 1 to 5 do
                if not form.completados[i] then
                    ok := false;
            todosCompletados := ok;
        end;

        procedure inicializarFormulario(var form : registroFormulario; modo : tModoFormulario);
        var
            i : Integer;
        begin
            form.modo := modo;
            if modo = modoVer then
                form.seleccion := 7
            else
                form.seleccion := 1;
            form.editandoTexto := false;
            form.textoTemp := '';
            form.campoFecha := 0;
            for i := 1 to 5 do
                form.completados[i] := false;
        end;

        procedure escribirValor(valor : String; mostrarFinal : Boolean; color : Byte; var ventana : infoVentana);
        var
            disponible : Integer;
            s : String;
        begin
            disponible := espacioLibre(ventana);
            s := valor;
            if disponible < 1 then
                s := ''
            else if Length(s) > disponible then
            begin
                if mostrarFinal then
                    s := Copy(s, Length(s) - disponible + 1, disponible)
                else if disponible > 2 then
                    s := Copy(s, 1, disponible - 2) + '..'
                else
                    s := Copy(s, 1, disponible);
            end;
            escribirSeguido(ventana, s, color);
        end;

        procedure escribirFecha(cliente : datosCliente; form : registroFormulario; colorBase : Byte; var ventana : infoVentana);
        var
            pendiente : Boolean;
            colorD, colorM, colorA : Byte;
        begin
            pendiente := (form.modo = modoAlta) and (not form.completados[3]) and (form.campoFecha = 0);

            if pendiente then
                colorBase := DarkGray;

            colorD := colorBase;
            colorM := colorBase;
            colorA := colorBase;
            if form.campoFecha = 1 then colorD := Yellow;
            if form.campoFecha = 2 then colorM := Yellow;
            if form.campoFecha = 3 then colorA := Yellow;

            escribirSeguido(ventana, numeroConCeros(cliente.fechaDeNacimiento.D, 2), colorD);
            escribirSeguido(ventana, '/', colorBase);
            escribirSeguido(ventana, numeroConCeros(cliente.fechaDeNacimiento.M, 2), colorM);
            escribirSeguido(ventana, '/', colorBase);
            escribirSeguido(ventana, numeroConCeros(cliente.fechaDeNacimiento.A, 4), colorA);
        end;

        procedure dibujarFila(cliente : datosCliente; form : registroFormulario; i : Integer);
        var
            v : infoVentana;
            filaActiva, editando : Boolean;
            colorBase : Byte;
        begin
            if form.ventana.topLeft.x <> 0 then
            begin
                v := form.ventana;
                v.cursor.y := v.cursor.y + i - 1;

                limpiarLineaEnVentana(v);

                editando := form.editandoTexto or (form.campoFecha <> 0);
                filaActiva := (i = form.seleccion);
                if filaActiva then colorBase := Cyan else colorBase := White;

                if filaActiva then
                begin
                    if editando and (i <= 5) then
                        escribirSeguido(v, '> [EDITANDO] ', colorBase)
                    else
                        escribirSeguido(v, '> ', colorBase);
                end
                else
                    escribirSeguido(v, '  ', colorBase);

                case i of
                    1, 2, 4, 5:
                    begin
                        escribirSeguido(v, etiquetaCampo(i), colorBase);
                        if filaActiva and form.editandoTexto then
                            escribirValor(form.textoTemp + '_', true, White, v)
                        else if (form.modo = modoAlta) and (not form.completados[i]) then
                            escribirSeguido(v, '<pendiente>', DarkGray)
                        else
                            escribirValor(obtenerCampo(cliente, i), false, colorBase, v);
                    end;

                    3:
                    begin
                        escribirSeguido(v, etiquetaCampo(3), colorBase);
                        escribirFecha(cliente, form, colorBase, v);
                    end;

                    6:
                    begin
                        escribirSeguido(v, 'Estado: ', colorBase);
                        if cliente.estado then
                            escribirSeguido(v, 'Activo', colorBase)
                        else
                            escribirSeguido(v, 'Inactivo', colorBase);
                    end;

                    7:
                    begin
                        case form.modo of
                            modoVer:
                                escribirSeguido(v, '--- EDITAR ---', colorBase);
                            modoEditar:
                                if cliente.estado then
                                    escribirSeguido(v, '--- DAR DE BAJA ---', LightRed)
                                else
                                    escribirSeguido(v, '--- DAR DE ALTA ---', LightGreen);
                            modoAlta:
                                if todosCompletados(form) then
                                    escribirSeguido(v, '--- CONFIRMAR DATOS ---', LightGreen)
                                else
                                    escribirSeguido(v, '--- CONFIRMAR DATOS ---', DarkGray);
                        end;
                    end;
                end;

                TextColor(White);
                GotoXY(dimensionesDeTerminal.x, dimensionesDeTerminal.y);
            end;
        end;

        procedure dibujarFormularioCompleto(cliente : datosCliente; var form : registroFormulario);
        var
            i : Integer;
            titulo : String;
        begin
            dibujarEscape(false);

            case form.modo of
                modoAlta: titulo := 'Nuevo Cliente con DNI: ' + cliente.DNI;
                modoVer: titulo := 'Datos de Cliente con DNI: ' + cliente.DNI;
                modoEditar: titulo := 'Modiciacion de Cliente con DNI: ' + cliente.DNI;
            end;

            form.ventana := dibujarVentana(titulo, 55, 7, 0, 0);

            for i := 1 to 7 do
                dibujarFila(cliente, form, i);
        end;

        procedure moverFila(cliente : datosCliente; var form : registroFormulario; delta : Integer);
        var
            vieja : Integer;
        begin
            vieja := form.seleccion;
            form.seleccion := moverSeleccion(vieja, delta);
            dibujarFila(cliente, form, vieja);
            dibujarFila(cliente, form, form.seleccion);
        end;

        procedure editarCampoTexto(var cliente : datosCliente; var form : registroFormulario; var confirmado : Boolean);
        var
            k : tecla;
            copia : datosCliente;
            campo : Integer;
            max : Word;
        begin
            campo := form.seleccion;
            form.textoTemp := obtenerCampo(cliente, campo);
            form.editandoTexto := true;

            if (campo = 1) or (campo = 5) then
                max := 64
            else
                max := 32;

            confirmado := false;
            repeat
                dibujarFila(cliente, form, campo);
                k := texto;
                leerSoloTexto(form.textoTemp, max, k);

                if k = enter then
                begin
                    copia := cliente;
                    asignarCampo(copia, campo, form.textoTemp);
                    if campoValido(campo, copia) then
                    begin
                        cliente := copia;
                        confirmado := true;
                    end;
                end;
            until confirmado or (k = escape);

            form.editandoTexto := false;
        end;

        procedure editarFecha(var cliente : datosCliente; var form : registroFormulario; var confirmado : Boolean);
        var
            k : tecla;
            copia : datosCliente;
            d, m, a : Integer;
        begin
            copia := cliente;
            d := copia.fechaDeNacimiento.D;
            m := copia.fechaDeNacimiento.M;
            a := copia.fechaDeNacimiento.A;

            form.campoFecha := 1;
            confirmado := false;

            repeat
                copia.fechaDeNacimiento.D := d;
                copia.fechaDeNacimiento.M := m;
                copia.fechaDeNacimiento.A := a;

                dibujarFila(copia, form, 3);
                k := leerTecla;

                case k of
                    izquierda:
                        if form.campoFecha > 1 then Dec(form.campoFecha);
                    derecha:
                        if form.campoFecha < 3 then Inc(form.campoFecha);
                    arriba:
                    begin
                        case form.campoFecha of
                            1: 
                            begin 
                                Inc(d); 
                                if d > diasDelMes(m, a) then d := 1; 
                            end;
                            2: 
                            begin 
                                Inc(m); 
                                if m > 12 then m := 1; 
                            end;
                            3: if a < maxA then Inc(a);
                        end;
                    end;
                    abajo:
                    begin
                        case form.campoFecha of
                            1: 
                            begin 
                                Dec(d); 
                                if d < 1 then d := diasDelMes(m, a); 
                            end;
                            2: 
                            begin 
                                Dec(m); 
                                if m < 1 then m := 12; 
                            end;
                            3: if a > minA then Dec(a);
                        end;
                    end;
                end;

                if d > diasDelMes(m, a) then
                    d := diasDelMes(m, a);

                if k = enter then
                begin
                    copia.fechaDeNacimiento.D := d;
                    copia.fechaDeNacimiento.M := m;
                    copia.fechaDeNacimiento.A := a;
                    if campoValido(3, copia) then
                        confirmado := true;
                end;
            until confirmado or (k = escape);

            form.campoFecha := 0;
            if confirmado then
                cliente := copia;
        end;

        procedure menuModificacionCliente(var f : tArchivoClientes; indiceRegistro : Integer; var cliente : datosCliente);
        var
            form : registroFormulario;
            k : tecla;
            salir, confirmado : Boolean;
            menuConfirmacion : registroMenu;
            seleccionConfirmacion : Integer;
        begin
            inicializarFormulario(form, modoEditar);
            salir := false;
            ClrScr;
            dibujarFormularioCompleto(cliente, form);

            repeat
                k := leerTecla;

                case k of
                    arriba: moverFila(cliente, form, -1);
                    abajo:  moverFila(cliente, form, 1);
                    escape: salir := true;
                    enter:
                        case form.seleccion of
                            1, 2, 4, 5:
                            begin
                                editarCampoTexto(cliente, form, confirmado);
                                if confirmado then
                                    EscribirArchivoClientes(f, indiceRegistro, cliente);
                                dibujarFila(cliente, form, form.seleccion);
                            end;
                            3:
                            begin
                                editarFecha(cliente, form, confirmado);
                                if confirmado then
                                    EscribirArchivoClientes(f, indiceRegistro, cliente);
                                dibujarFila(cliente, form, 3);
                            end;
                            7:
                            begin
                                inicializarMenu(menuConfirmacion);
                                agregarOpcion(menuConfirmacion, 'Si');
                                agregarOpcion(menuConfirmacion, 'No');
                                seleccionConfirmacion := 1;

                                if cliente.estado then
                                    menuHorizontal('Esta seguro que desea dar de baja?', menuConfirmacion, seleccionConfirmacion, 30, 1, 0, 11)
                                else
                                    menuHorizontal('Esta seguro que desea dar de alta?', menuConfirmacion, seleccionConfirmacion, 30, 1, 0, 11);

                                if seleccionConfirmacion = 1 then
                                begin
                                    cliente.estado := not cliente.estado;
                                    EscribirArchivoClientes(f, indiceRegistro, cliente);
                                end;

                                ClrScr;
                                dibujarFormularioCompleto(cliente, form);
                            end;
                        end;
                end;
            until salir;

            ClrScr;
        end;

        procedure menuVisualizacionCliente(var f : tArchivoClientes; indiceRegistro : Integer; var cliente : datosCliente);
        var
            form : registroFormulario;
            k : tecla;
            salir : Boolean;
        begin
            inicializarFormulario(form, modoVer);
            salir := false;
            ClrScr;
            dibujarFormularioCompleto(cliente, form);

            repeat
                k := leerTecla;

                case k of
                    escape: salir := true;
                    enter:
                    begin
                        menuModificacionCliente(f, indiceRegistro, cliente);
                        ClrScr;
                        dibujarFormularioCompleto(cliente, form);
                    end;
                end;
            until salir;

            ClrScr;
        end;

        procedure menuAltaCliente(var f : tArchivoClientes; dni : tDNI; var registrado : Boolean);
        var
            cliente : datosCliente;
            form : registroFormulario;
            k : tecla;
            salir, confirmado : Boolean;
        begin
            registrado := false;
            inicializarCliente(cliente, dni);
            inicializarFormulario(form, modoAlta);
            salir := false;
            ClrScr;
            dibujarFormularioCompleto(cliente, form);

            repeat
                k := leerTecla;

                case k of
                    arriba: moverFila(cliente, form, -1);
                    abajo:  moverFila(cliente, form, 1);
                    escape: salir := true;
                    enter:
                        case form.seleccion of
                            1, 2, 4, 5:
                            begin
                                editarCampoTexto(cliente, form, confirmado);
                                if confirmado then
                                    form.completados[form.seleccion] := true;
                                dibujarFila(cliente, form, form.seleccion);
                                dibujarFila(cliente, form, 7);
                            end;
                            3:
                            begin
                                editarFecha(cliente, form, confirmado);
                                if confirmado then
                                    form.completados[3] := true;
                                dibujarFila(cliente, form, 3);
                                dibujarFila(cliente, form, 7);
                            end;
                            7:
                                if todosCompletados(form) then
                                begin
                                    agregarCliente(f, cliente);
                                    registrado := true;
                                    salir := true;
                                end;
                        end;
                end;
            until salir;

            ClrScr;
        end;

    begin
        ClrScr;
        tempString := '';
        stop := false;
        dibujarEscape(false);
        ventanaActual := dibujarVentana('Gestion de clientes', 24, 1, 0, 0);
        repeat
            escribirEnVentana(ventanaActual, 'DNI: ' + tempString + ' ');
            GotoXY(dimensionesDeTerminal.x, dimensionesDeTerminal.y);

            teclaPresionada := numero;
            leerSoloNumeros(tempString, 8, teclaPresionada);

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
                menuHorizontal('El DNI ' + tempString  + ' no esta registrado', menuActual, seleccionActual, 30, 1, 0, 0);

                if seleccionActual = 1 then
                    menuAltaCliente(f, tempString, registrado);
            end
            else
            begin
                cliente := buscarDatosCliente(f, indiceBusquedaBinaria);
                menuVisualizacionCliente(f, indiceBusquedaBinaria, cliente);
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