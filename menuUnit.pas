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
        procedure campoValido(campo : Integer; cliente : datosCliente; var error : String; var validInput : Boolean);
        begin
            case campo of
                1: verificarNombre(cliente.apellidoYNombres, validInput, error);
                2: verificarDireccion(cliente.direccion, validInput, error);
                4: verificarCel(cliente.celular, validInput, error);
                5: verificarEmail(cliente.email, validInput, error);
            else
                validInput := false;
            end;
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
                modoEditar: titulo := 'Modificacion de Cliente con DNI: ' + cliente.DNI;
            end;

            form.ventana := dibujarVentana(titulo, 55, 7, 0, 0);

            for i := 1 to 7 do
                dibujarFila(cliente, form, i);
        end;

        procedure moverFila(cliente : datosCliente; var form : registroFormulario; delta : Integer);
        var
            anterior : Integer;
        begin
            anterior := form.seleccion;
            form.seleccion := moverSeleccion(anterior, delta);
            dibujarFila(cliente, form, anterior);
            dibujarFila(cliente, form, form.seleccion);
        end;

        procedure editarCampoTexto(var cliente : datosCliente; var form : registroFormulario; var confirmado : Boolean);
        var
            k : tecla;
            copia : datosCliente;
            error : String;
            menuError : registroMenu;
            inputValido : Boolean;
            seleccionError : Integer;
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
                if campo = 4 then
                    leerSoloNumeros(form.textoTemp, max, k)
                else
                    leerSoloTexto(form.textoTemp, max, k);

                if k = enter then
                begin
                    copia := cliente;
                    asignarCampo(copia, campo, suprimirEspacios(form.textoTemp));
                    campoValido(campo, copia, error, inputValido);
                    if inputValido then
                    begin
                        cliente := copia;
                        confirmado := true;
                    end
                    else
                    begin
                        inicializarMenu(menuError);
                        agregarOpcion(menuError, 'Presione enter para continuar');
                        seleccionError := 1;

                        menuVertical('Error: ' + error, menuError, seleccionError, 0, 11);
                        limpiarConsolaEn(menuError.ventana);
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

    procedure gestionDePolizas(var fClientes : tArchivoClientes; var fPolizas : tArchivoPolizas);
    var
        menuActual : registroMenu;
        dniStr, patenteStr : String;
        seleccionActual, indicePoliza, indiceCliente : Integer;
        cliente : datosCliente;
        poliza : datosPoliza;
        stop, polizaRegistrada : Boolean;

        type
            tModoFormularioPoliza = (modoVerPoliza, modoEditarPoliza, modoAltaPoliza);
            tCompletadosPoliza = array[1..6] of Boolean;

            registroFormularioPoliza = record
                modo          : tModoFormularioPoliza;
                ventana       : infoVentana; 
                seleccion     : 1..10;
                editandoTexto : Boolean;
                textoTemp     : String;
                campoFecha    : 0..3; 
                completados   : tCompletadosPoliza;
                tipoFechaActiva : 5..6;
            end;

            registroFormularioBusquedaPoliza = record
                ventana       : infoVentana;
                seleccion     : 1..3;
                editandoTexto : Boolean;
                textoTemp     : String;
                completados   : array[1..2] of Boolean;
            end;
        
        function etiquetaCampoPoliza(campo : Integer) : String;
        begin
            case campo of
                1: etiquetaCampoPoliza := 'Marca: ';
                2: etiquetaCampoPoliza := 'Modelo: ';
                3: etiquetaCampoPoliza := 'Año Vehiculo: ';
                4: etiquetaCampoPoliza := 'Cobertura: ';
                5: etiquetaCampoPoliza := 'Vigencia Desde: ';
                6: etiquetaCampoPoliza := 'Vigencia Hasta: ';
            else
                etiquetaCampoPoliza := '';
            end;
        end;

        function obtenerCampoPolizaTexto(poliza : datosPoliza; campo : Integer) : String;
        begin
            case campo of
                1: obtenerCampoPolizaTexto := poliza.marca;
                2: obtenerCampoPolizaTexto := poliza.modelo;
                3: obtenerCampoPolizaTexto := integerToString(poliza.yearVehicle);
            else
                obtenerCampoPolizaTexto := '';
            end;
        end;

        function todosCompletadosPoliza(form : registroFormularioPoliza) : Boolean;
        var
            i : Integer;
            ok : Boolean;
        begin
            ok := true;
            for i := 1 to 6 do
                if not form.completados[i] then
                    ok := false;
            todosCompletadosPoliza := ok;
        end;
        procedure escribirFechaPoliza(fecha : tFecha; form : registroFormularioPoliza; campoActual, filaEval : Integer; colorBase : Byte; var ventana : infoVentana);
        var
            pendiente : Boolean;
            colorD, colorM, colorA : Byte;
        begin
            pendiente := (form.modo = modoAltaPoliza) and (not form.completados[filaEval]) and (form.campoFecha = 0);

            if pendiente then
                colorBase := DarkGray;

            colorD := colorBase;
            colorM := colorBase;
            colorA := colorBase;
            if (form.campoFecha > 0) and (form.tipoFechaActiva = filaEval) then
            begin
                if form.campoFecha = 1 then colorD := Yellow;
                if form.campoFecha = 2 then colorM := Yellow;
                if form.campoFecha = 3 then colorA := Yellow;
            end;

            escribirSeguido(ventana, numeroConCeros(fecha.D, 2), colorD);
            escribirSeguido(ventana, '/', colorBase);
            escribirSeguido(ventana, numeroConCeros(fecha.M, 2), colorM);
            escribirSeguido(ventana, '/', colorBase);
            escribirSeguido(ventana, numeroConCeros(fecha.A, 4), colorA);
        end;

        procedure dibujarFilaPoliza(poliza : datosPoliza; form : registroFormularioPoliza; i : Integer);
        var
            v : infoVentana;
            filaActiva, editando : Boolean;
            colorBase : Byte;
            strMonto : String;
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
                    if editando and (i <= 6) then
                        escribirSeguido(v, '> [EDITANDO] ', colorBase)
                    else
                        escribirSeguido(v, '> ', colorBase);
                end
                else
                    escribirSeguido(v, '  ', colorBase);

                case i of
                    1..2:
                    begin
                        escribirSeguido(v, etiquetaCampoPoliza(i), colorBase);
                        if filaActiva and form.editandoTexto then
                            escribirSeguido(v, form.textoTemp + '_', White)
                        else if (form.modo = modoAltaPoliza) and (not form.completados[i]) then
                            escribirSeguido(v, '<pendiente>', DarkGray)
                        else
                            escribirSeguido(v, obtenerCampoPolizaTexto(poliza, i), colorBase);
                    end;
                    3:
                    begin
                        escribirSeguido(v, etiquetaCampoPoliza(3), colorBase);
                        if filaActiva and form.editandoTexto then
                            escribirSeguido(v, integerToString(poliza.yearVehicle), Yellow)
                        else if (form.modo = modoAltaPoliza) and (not form.completados[3]) then
                            escribirSeguido(v, '<pendiente>', DarkGray)
                        else
                            escribirSeguido(v, integerToString(poliza.yearVehicle), colorBase);
                    end;
                    4:
                    begin
                        escribirSeguido(v, etiquetaCampoPoliza(4), colorBase);
                        if filaActiva and form.editandoTexto then
                            escribirSeguido(v, obtenerTextoCobertura(poliza.cobertura), Yellow)
                        else if (form.modo = modoAltaPoliza) and (not form.completados[4]) then
                            escribirSeguido(v, '<pendiente>', DarkGray)
                        else
                            escribirSeguido(v, obtenerTextoCobertura(poliza.cobertura), colorBase);
                    end;
                    5:
                    begin
                        escribirSeguido(v, etiquetaCampoPoliza(5), colorBase);
                        escribirFechaPoliza(poliza.fecha.vigenciaDesde, form, form.campoFecha, 5, colorBase, v);
                    end;
                    6:
                    begin
                        escribirSeguido(v, etiquetaCampoPoliza(6), colorBase);
                        escribirFechaPoliza(poliza.fecha.vigenciaHasta, form, form.campoFecha, 6, colorBase, v);
                    end;
                    7:
                    begin
                        escribirSeguido(v, 'Suma Asegurada: $', colorBase);
                        Str(poliza.sumaAsegurada:0:2, strMonto);
                        escribirSeguido(v, strMonto, colorBase);
                    end;
                    8:
                    begin
                        escribirSeguido(v, 'Valor Cuota: $', colorBase);
                        Str(poliza.valorCuota:0:2, strMonto);
                        escribirSeguido(v, strMonto, colorBase);
                    end;
                    9:
                    begin
                        escribirSeguido(v, 'Estado: ', colorBase);
                        if poliza.estado then
                            escribirSeguido(v, 'Activo', colorBase)
                        else
                            escribirSeguido(v, 'Inactivo', colorBase);
                    end;
                    10:
                    begin
                        case form.modo of
                            modoVerPoliza:
                                escribirSeguido(v, '--- OPCIONES ---', colorBase);
                            modoEditarPoliza:
                                escribirSeguido(v, '--- GUARDAR CAMBIOS ---', LightGreen);
                            modoAltaPoliza:
                                if todosCompletadosPoliza(form) then
                                    escribirSeguido(v, '--- CONFIRMAR POLIZA ---', LightGreen)
                                else
                                    escribirSeguido(v, '--- CONFIRMAR POLIZA ---', DarkGray);
                        end;
                    end;
                end;

                TextColor(White);
                GotoXY(dimensionesDeTerminal.x, dimensionesDeTerminal.y);
            end;
        end;

        procedure campoPolizaValido(campo : Integer; poliza : datosPoliza; var validInput : Boolean; var error : String);
        begin
            validInput := true;
            error := '';
            case campo of
                1: verificarMarca(poliza.marca, validInput, error);
                2: verificarModelo(poliza.modelo, validInput, error);
                3: verificarYearVehicle(poliza.yearVehicle, validInput, error);
                4: validInput := true;
            else
                validInput := true;
            end;
        end;

        procedure editarCoberturaPoliza(var cobertura : tipoCobertura; var form : registroFormularioPoliza; tipoFila : Integer; var confirmado : Boolean; var polizaRef : datosPoliza);
        var
            k : tecla;
        begin
            form.editandoTexto := true;
            confirmado := false;

            repeat
                dibujarFilaPoliza(polizaRef, form, tipoFila);
                k := leerTecla;

                case k of
                    arriba:
                        if Ord(cobertura) > 0 then
                            cobertura := tipoCobertura(Ord(cobertura) - 1)
                        else
                            cobertura := tipoCobertura(4);
                    abajo:
                        if Ord(cobertura) < 4 then 
                            cobertura := tipoCobertura(Ord(cobertura) + 1)
                        else
                            cobertura := tipoCobertura(0);
                end;
            until (k = enter) or (k = escape);

            form.editandoTexto := false;
            if k = enter then
                confirmado := true;
        end;

        procedure editarYearVehiclePoliza(var yearV : Word; var form : registroFormularioPoliza; tipoFila : Integer; var confirmado : Boolean; var polizaRef : datosPoliza);
        var
            k : tecla;
            yearOriginal : Word;
        begin
            yearOriginal := yearV;
            form.editandoTexto := true;
            confirmado := false;

            repeat
                dibujarFilaPoliza(polizaRef, form, tipoFila);
                k := leerTecla;

                case k of
                    arriba:
                        if yearV < 2026 then
                            Inc(yearV)
                        else
                            yearV := 1800;
                    abajo:
                        if yearV > 1800 then
                            Dec(yearV)
                        else
                            yearV := 2026;
                end;
            until (k = enter) or (k = escape);

            form.editandoTexto := false;
            if k = enter then
                confirmado := true
            else
                yearV := yearOriginal;
        end;

        procedure dibujarFilaBusquedaPoliza(dni, patente : String; form : registroFormularioBusquedaPoliza; i : Integer);
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

                editando := form.editandoTexto;
                filaActiva := (i = form.seleccion);
                if filaActiva then colorBase := Cyan else colorBase := White;

                if filaActiva then
                begin
                    if editando and (i <= 2) then
                        escribirSeguido(v, '> [EDITANDO] ', colorBase)
                    else
                        escribirSeguido(v, '> ', colorBase);
                end
                else
                    escribirSeguido(v, '  ', colorBase);

                case i of
                    1:
                    begin
                        escribirSeguido(v, 'DNI: ', colorBase);
                        if filaActiva and form.editandoTexto then
                            escribirSeguido(v, form.textoTemp + '_', White)
                        else if dni = '' then
                            escribirSeguido(v, '<pendiente>', DarkGray)
                        else
                            escribirSeguido(v, dni, colorBase);
                    end;
                    2:
                    begin
                        escribirSeguido(v, 'Patente: ', colorBase);
                        if filaActiva and form.editandoTexto then
                            escribirSeguido(v, form.textoTemp + '_', White)
                        else if patente = '' then
                            escribirSeguido(v, '<pendiente>', DarkGray)
                        else
                            escribirSeguido(v, patente, colorBase);
                    end;
                    3:
                    begin
                        if form.completados[1] and form.completados[2] then
                            escribirSeguido(v, '--- BUSCAR / CONTINUAR ---', LightGreen)
                        else
                            escribirSeguido(v, '--- BUSCAR / CONTINUAR ---', DarkGray);
                    end;
                end;

                TextColor(White);
                GotoXY(dimensionesDeTerminal.x, dimensionesDeTerminal.y);
            end;
        end;

        procedure ingresarDniPatenteFormulario(var dni : tDNI; var patente : tPatente; var cancel : Boolean);
        var
            form : registroFormularioBusquedaPoliza;
            k : tecla;
            salir, confirmado : Boolean;
            i : Integer;
        begin
            form.seleccion := 1;
            form.editandoTexto := false;
            form.textoTemp := '';
            dni := '';
            patente := '';
            form.completados[1] := false;
            form.completados[2] := false;
            cancel := false;
            salir := false;

            ClrScr;
            dibujarEscape(false);
            form.ventana := dibujarVentana('Gestion de Polizas - Ingreso', 55, 3, 0, 0);

            for i := 1 to 3 do
                dibujarFilaBusquedaPoliza(dni, patente, form, i);

            repeat
                k := leerTecla;
                case k of
                    arriba:
                    begin
                        if form.seleccion > 1 then Dec(form.seleccion);
                        dibujarFilaBusquedaPoliza(dni, patente, form, form.seleccion + 1);
                        dibujarFilaBusquedaPoliza(dni, patente, form, form.seleccion);
                    end;
                    abajo:
                    begin
                        if form.seleccion < 3 then Inc(form.seleccion);
                        dibujarFilaBusquedaPoliza(dni, patente, form, form.seleccion - 1);
                        dibujarFilaBusquedaPoliza(dni, patente, form, form.seleccion);
                    end;
                    escape:
                    begin
                        cancel := true;
                        salir := true;
                    end;
                    enter:
                    begin
                        case form.seleccion of
                            1, 2:
                            begin
                                if form.seleccion = 1 then form.textoTemp := dni else form.textoTemp := patente;
                                form.editandoTexto := true;
                                confirmado := false;

                                repeat
                                    dibujarFilaBusquedaPoliza(dni, patente, form, form.seleccion);
                                    k := texto;
                                    if form.seleccion = 1 then
                                        leerSoloNumeros(form.textoTemp, 8, k)
                                    else
                                        leerSoloTexto(form.textoTemp, 7, k);

                                    if k = enter then
                                    begin
                                        if form.seleccion = 1 then
                                        begin
                                            if esDNI(form.textoTemp) then
                                            begin
                                                dni := form.textoTemp;
                                                form.completados[1] := true;
                                                confirmado := true;
                                            end;
                                        end
                                        else
                                        begin
                                            if esPatente(form.textoTemp) then
                                            begin
                                                patente := UpCase(form.textoTemp);
                                                form.completados[2] := true;
                                                confirmado := true;
                                            end;
                                        end;
                                    end;
                                until confirmado or (k = escape);
                                form.editandoTexto := false;
                                dibujarFilaBusquedaPoliza(dni, patente, form, form.seleccion);
                                dibujarFilaBusquedaPoliza(dni, patente, form, 3);
                            end;
                            3:
                            begin
                                if form.completados[1] and form.completados[2] then
                                    salir := true;
                            end;
                        end;
                    end;
                end;
            until salir;
            ClrScr;
        end;

        procedure asignarCampoPolizaTexto(var poliza : datosPoliza; campo : Integer; valor : String);
        var
            covInt : Integer;
        begin
            case campo of
                1: poliza.marca := suprimirEspacios(valor);
                2: poliza.modelo := suprimirEspacios(valor);
                3: poliza.yearVehicle := stringToInteger(valor);
                4: 
                begin
                    covInt := stringToInteger(valor);
                    if (covInt >= 1) and (covInt <= 5) then
                        poliza.cobertura := tipoCobertura(covInt - 1);
                end;
            end;
        end;

        function moverSeleccionPoliza(sel, delta : Integer) : Integer;
        begin
            repeat
                sel := sel + delta;
                if sel < 1 then sel := 10;
                if sel > 10 then sel := 1;
            until not (sel in [7, 8, 9]); { Salta Suma Asegurada, Valor Cuota y Estado }
            moverSeleccionPoliza := sel;
        end;

        procedure inicializarFormularioPoliza(var form : registroFormularioPoliza; modo : tModoFormularioPoliza);
        var
            i : Integer;
        begin
            form.modo := modo;
            if modo = modoVerPoliza then
                form.seleccion := 10
            else
                form.seleccion := 1;
            form.editandoTexto := false;
            form.textoTemp := '';
            form.campoFecha := 0;
            for i := 1 to 6 do
                form.completados[i] := false;
        end;

        procedure dibujarFormularioPolizaCompleto(poliza : datosPoliza; var form : registroFormularioPoliza);
        var
            i : Integer;
            titulo : String;
        begin
            dibujarEscape(false);
            case form.modo of
                modoAltaPoliza: titulo := 'Alta de Poliza - DNI: ' + poliza.DNI;
                modoVerPoliza: titulo := 'Datos de Poliza Nro: ' + poliza.numPol;
                modoEditarPoliza: titulo := 'Modificacion de Poliza Nro: ' + poliza.numPol;
            end;

            form.ventana := dibujarVentana(titulo, 66, 10, 0, 0);
            for i := 1 to 10 do
                dibujarFilaPoliza(poliza, form, i);
        end;

        procedure moverFilaPoliza(poliza : datosPoliza; var form : registroFormularioPoliza; delta : Integer);
        var
            anterior : Integer;
        begin
            anterior := form.seleccion;
            form.seleccion := moverSeleccionPoliza(anterior, delta);
            dibujarFilaPoliza(poliza, form, anterior);
            dibujarFilaPoliza(poliza, form, form.seleccion);
        end;

        procedure editarCampoTextoPoliza(var poliza : datosPoliza; var form : registroFormularioPoliza; var confirmado : Boolean);
        var
            k : tecla;
            copia : datosPoliza;
            error : String;
            menuError : registroMenu;
            inputValido : Boolean;
            seleccionError : Integer;
            campo : Integer;
            max : Word;
        begin
            campo := form.seleccion;
            form.textoTemp := obtenerCampoPolizaTexto(poliza, campo);
            form.editandoTexto := true;

            if campo = 1 then max := 20
            else if campo = 2 then max := 40
            else max := 4;

            confirmado := false;
            repeat
                dibujarFilaPoliza(poliza, form, campo);
                k := texto;
                if campo = 3 then
                    leerSoloNumeros(form.textoTemp, max, k)
                else
                    leerSoloTexto(form.textoTemp, max, k);

                if k = enter then
                begin
                    copia := poliza;
                    asignarCampoPolizaTexto(copia, campo, form.textoTemp);
                    campoPolizaValido(campo, copia, inputValido, error);
                    if inputValido then
                    begin
                        poliza := copia;
                        confirmado := true;
                    end
                    else
                    begin
                        inicializarMenu(menuError);
                        agregarOpcion(menuError, 'Presione enter para continuar');
                        seleccionError := 1;

                        menuVertical('Error: ' + error, menuError, seleccionError, 0, 12);
                        limpiarConsolaEn(menuError.ventana);
                    end;
                end;
            until confirmado or (k = escape);

            form.editandoTexto := false;
        end;

        procedure editarFechaPoliza(var fecha : tFecha; var form : registroFormularioPoliza; tipoFila : Integer; var confirmado : Boolean; var polizaRef : datosPoliza);
        var
            k : tecla;
            d, m, a : Integer;
            menuError : registroMenu;
            seleccionError : Integer;
            errorMsg : String;
            esValido : Boolean;
        begin
            d := fecha.D;
            m := fecha.M;
            a := fecha.A;

            form.campoFecha := 1;
            form.tipoFechaActiva := tipoFila;
            confirmado := false;

            repeat
                fecha.D := d;
                fecha.M := m;
                fecha.A := a;

                dibujarFilaPoliza(polizaRef, form, tipoFila);
                k := leerTecla;

                case k of
                    izquierda:
                        if form.campoFecha > 1 then Dec(form.campoFecha);
                    derecha:
                        if form.campoFecha < 3 then Inc(form.campoFecha);
                    arriba:
                    begin
                        case form.campoFecha of
                            1: begin Inc(d); if d > diasDelMes(m, a) then d := 1; end;
                            2: begin Inc(m); if m > 12 then m := 1; end;
                            3: if a < 2050 then Inc(a);
                        end;
                    end;
                    abajo:
                    begin
                        case form.campoFecha of
                            1: begin Dec(d); if d < 1 then d := diasDelMes(m, a); end;
                            2: begin Dec(m); if m < 1 then m := 12; end;
                            3: if a > 2020 then Dec(a);
                        end;
                    end;
                end;

                if d > diasDelMes(m, a) then
                    d := diasDelMes(m, a);

                if k = enter then
                begin
                    esValido := true;
                    errorMsg := '';

                    if tipoFila = 5 then
                    begin
                        if a > 2026 then
                        begin
                            esValido := false;
                            errorMsg := 'Anio de vigencia desde no puede ser mayor a 2026';
                        end;
                    end
                    else if tipoFila = 6 then
                    begin
                        if (a < polizaRef.fecha.vigenciaDesde.A) or 
                        ((a = polizaRef.fecha.vigenciaDesde.A) and (m < polizaRef.fecha.vigenciaDesde.M)) or
                        ((a = polizaRef.fecha.vigenciaDesde.A) and (m = polizaRef.fecha.vigenciaDesde.M) and (d <= polizaRef.fecha.vigenciaDesde.D)) then
                        begin
                            esValido := false;
                            errorMsg := 'La fecha hasta debe ser mayor a la fecha desde';
                        end;
                    end;

                    if not esValido then
                    begin
                        inicializarMenu(menuError);
                        agregarOpcion(menuError, 'Presione enter para continuar');
                        seleccionError := 1;
                        menuVertical('Error: ' + errorMsg, menuError, seleccionError, 0, 12);
                        limpiarConsolaEn(menuError.ventana);
                        confirmado := false;
                    end
                    else
                    begin
                        fecha.D := d;
                        fecha.M := m;
                        fecha.A := a;
                        confirmado := true;
                    end;
                end;
            until confirmado or (k = escape);

            form.campoFecha := 0;
        end;

        procedure menuModificacionPoliza(var fPol : tArchivoPolizas; indiceRegistro : Integer; var poliza : datosPoliza);
        var
            form : registroFormularioPoliza;
            polizaCopia : datosPoliza;
            k : tecla;
            salir, confirmado : Boolean;
            menuError : registroMenu;
            selErr : Integer;
        begin
            if not poliza.estado then
            begin
                inicializarMenu(menuError);
                agregarOpcion(menuError, 'Aceptar');
                selErr := 1;
                menuHorizontal('La poliza esta inactiva. No se puede modificar.', menuError, selErr, 45, 1, 0, 12);
                limpiarConsolaEn(menuError.ventana);
                exit;
            end;

            polizaCopia := poliza;
            inicializarFormularioPoliza(form, modoEditarPoliza);
            salir := false;
            ClrScr;
            dibujarFormularioPolizaCompleto(polizaCopia, form);

            repeat
                k := leerTecla;

                case k of
                    arriba: moverFilaPoliza(polizaCopia, form, -1);
                    abajo:  moverFilaPoliza(polizaCopia, form, 1);
                    escape: salir := true;
                    enter:
                        case form.seleccion of
                            1..2:
                            begin
                                editarCampoTextoPoliza(polizaCopia, form, confirmado);
                                if confirmado then
                                begin
                                    polizaCopia.sumaAsegurada := 676767;
                                    polizaCopia.valorCuota := valorCuota(polizaCopia);
                                end;
                                dibujarFilaPoliza(polizaCopia, form, form.seleccion);
                                dibujarFilaPoliza(polizaCopia, form, 7);
                                dibujarFilaPoliza(polizaCopia, form, 8);
                                dibujarFilaPoliza(polizaCopia, form, 10);
                            end;
                            3:
                            begin
                                editarYearVehiclePoliza(polizaCopia.yearVehicle, form, 3, confirmado, polizaCopia);
                                if confirmado then
                                begin
                                    polizaCopia.sumaAsegurada := 676767;
                                    polizaCopia.valorCuota := valorCuota(polizaCopia);
                                end;
                                dibujarFilaPoliza(polizaCopia, form, 3);
                                dibujarFilaPoliza(polizaCopia, form, 7);
                                dibujarFilaPoliza(polizaCopia, form, 8);
                                dibujarFilaPoliza(polizaCopia, form, 10);
                            end;
                            4:
                            begin
                                editarCoberturaPoliza(polizaCopia.cobertura, form, 4, confirmado, polizaCopia);
                                if confirmado then
                                begin
                                    form.completados[4] := true;
                                    polizaCopia.sumaAsegurada := 676767;
                                    polizaCopia.valorCuota := valorCuota(polizaCopia);
                                end;
                                dibujarFilaPoliza(polizaCopia, form, 4);
                                dibujarFilaPoliza(polizaCopia, form, 7);
                                dibujarFilaPoliza(polizaCopia, form, 8);
                                dibujarFilaPoliza(polizaCopia, form, 10);
                            end;
                            5:
                            begin
                                editarFechaPoliza(polizaCopia.fecha.vigenciaDesde, form, 5, confirmado, polizaCopia);
                                if confirmado then
                                    polizaCopia.valorCuota := valorCuota(polizaCopia);
                                dibujarFilaPoliza(polizaCopia, form, 5);
                                dibujarFilaPoliza(polizaCopia, form, 7);
                                dibujarFilaPoliza(polizaCopia, form, 8);
                                dibujarFilaPoliza(polizaCopia, form, 10);
                            end;
                            6:
                            begin
                                editarFechaPoliza(polizaCopia.fecha.vigenciaHasta, form, 6, confirmado, polizaCopia);
                                if confirmado then
                                    polizaCopia.valorCuota := valorCuota(polizaCopia);
                                dibujarFilaPoliza(polizaCopia, form, 6);
                                dibujarFilaPoliza(polizaCopia, form, 7);
                                dibujarFilaPoliza(polizaCopia, form, 8);
                                dibujarFilaPoliza(polizaCopia, form, 10);
                            end;
                            10:
                            begin
                                poliza := polizaCopia;
                                escribirArchivoPolizas(fPol, indiceRegistro, poliza);
                                salir := true;
                            end;
                        end;
                end;
            until salir;
            ClrScr;
        end;

        procedure menuAltaPoliza(var fPol : tArchivoPolizas; dni : tDNI; patente : tPatente; var registrado : Boolean);
        var
            poliza : datosPoliza;
            form : registroFormularioPoliza;
            k : tecla;
            salir, confirmado : Boolean;
        begin
            registrado := false;
            inicializarPoliza(poliza);
            poliza.numPol := generarNumeroDePoliza(fPol, FileSize(fPol));
            poliza.DNI := dni;
            poliza.patente := patente;

            inicializarFormularioPoliza(form, modoAltaPoliza);
            salir := false;
            ClrScr;
            dibujarFormularioPolizaCompleto(poliza, form);

            repeat
                k := leerTecla;

                case k of
                    arriba: moverFilaPoliza(poliza, form, -1);
                    abajo:  moverFilaPoliza(poliza, form, 1);
                    escape: salir := true;
                    enter:
                        case form.seleccion of
                            1, 2:
                            begin
                                editarCampoTextoPoliza(poliza, form, confirmado);
                                if confirmado then
                                begin
                                    form.completados[form.seleccion] := true;
                                    poliza.sumaAsegurada := 676767;
                                    poliza.valorCuota := valorCuota(poliza);
                                end;
                                dibujarFilaPoliza(poliza, form, form.seleccion);
                                dibujarFilaPoliza(poliza, form, 7);
                                dibujarFilaPoliza(poliza, form, 8);
                                dibujarFilaPoliza(poliza, form, 10);
                            end;
                            3:
                            begin
                                editarYearVehiclePoliza(poliza.yearVehicle, form, 3, confirmado, poliza);
                                if confirmado then
                                begin
                                    form.completados[3] := true;
                                    poliza.sumaAsegurada := 676767;
                                    poliza.valorCuota := valorCuota(poliza);
                                end;
                                dibujarFilaPoliza(poliza, form, 3);
                                dibujarFilaPoliza(poliza, form, 7);
                                dibujarFilaPoliza(poliza, form, 8);
                                dibujarFilaPoliza(poliza, form, 10);
                            end;
                            4:
                            begin
                                editarCoberturaPoliza(poliza.cobertura, form, 4, confirmado, poliza);
                                if confirmado then
                                begin
                                    form.completados[4] := true;
                                    poliza.sumaAsegurada := 676767;
                                    poliza.valorCuota := valorCuota(poliza);
                                end;
                                dibujarFilaPoliza(poliza, form, 4);
                                dibujarFilaPoliza(poliza, form, 7);
                                dibujarFilaPoliza(poliza, form, 8);
                                dibujarFilaPoliza(poliza, form, 10); 
                            end;
                            5:
                            begin
                                editarFechaPoliza(poliza.fecha.vigenciaDesde, form, 5, confirmado, poliza);
                                if confirmado then
                                begin
                                    form.completados[5] := true;
                                    poliza.valorCuota := valorCuota(poliza);
                                end;
                                dibujarFilaPoliza(poliza, form, 5);
                                dibujarFilaPoliza(poliza, form, 7);
                                dibujarFilaPoliza(poliza, form, 8);
                                dibujarFilaPoliza(poliza, form, 10);
                            end;
                            6:
                            begin
                                editarFechaPoliza(poliza.fecha.vigenciaHasta, form, 6, confirmado, poliza);
                                if confirmado then
                                begin
                                    form.completados[6] := true;
                                    poliza.valorCuota := valorCuota(poliza);
                                end;
                                dibujarFilaPoliza(poliza, form, 6);
                                dibujarFilaPoliza(poliza, form, 7);
                                dibujarFilaPoliza(poliza, form, 8);
                                dibujarFilaPoliza(poliza, form, 10);
                            end;
                            10:
                                if todosCompletadosPoliza(form) then
                                begin
                                    poliza.sumaAsegurada := 676767;
                                    poliza.valorCuota := valorCuota(poliza);
                                    agregarPoliza(fPol, poliza);
                                    registrado := true;
                                    salir := true;
                                end;
                        end;
                end;
            until salir;

            ClrScr;
        end;

        procedure menuVisualizacionPoliza(var fPol : tArchivoPolizas; indiceRegistro : Integer; var poliza : datosPoliza);
        var
            form : registroFormularioPoliza;
            k : tecla;
            salir : Boolean;
            menuOpciones : registroMenu;
            seleccionOpcion : Integer;
            menuConfirmacion : registroMenu;
            selConf : Integer;
        begin
            inicializarFormularioPoliza(form, modoVerPoliza);
            salir := false;
            ClrScr;
            dibujarFormularioPolizaCompleto(poliza, form);

            repeat
                k := leerTecla;
                case k of
                    escape: salir := true;
                    enter:
                    begin
                        inicializarMenu(menuOpciones);
                        agregarOpcion(menuOpciones, 'Modificar datos');
                        if poliza.estado then
                            agregarOpcion(menuOpciones, 'Dar de baja')
                        else
                            agregarOpcion(menuOpciones, 'Dar de alta');
                        
                        seleccionOpcion := 1;

                        menuHorizontal('Seleccione una opcion para la poliza', menuOpciones, seleccionOpcion, 34, 1, 0, 12);
                        limpiarConsolaEn(menuOpciones.ventana);

                        case seleccionOpcion of
                            1: 
                            begin
                                menuModificacionPoliza(fPol, indiceRegistro, poliza);
                            end;
                            2:
                            begin
                                inicializarMenu(menuConfirmacion);
                                agregarOpcion(menuConfirmacion, 'Si');
                                agregarOpcion(menuConfirmacion, 'No');
                                selConf := 1;
                                
                                if poliza.estado then
                                    menuHorizontal('Esta seguro que desea dar de baja?', menuConfirmacion, selConf, 30, 1, 0, 12)
                                else
                                    menuHorizontal('Esta seguro que desea dar de alta?', menuConfirmacion, selConf, 30, 1, 0, 12);
                                    
                                limpiarConsolaEn(menuConfirmacion.ventana);

                                if selConf = 1 then
                                begin
                                    poliza.estado := not poliza.estado;
                                    escribirArchivoPolizas(fPol, indiceRegistro, poliza);
                                end;
                            end;
                        end;
                        
                        ClrScr;
                        dibujarFormularioPolizaCompleto(poliza, form);
                    end;
                end;
            until salir;
            ClrScr;
        end;

    begin
        ingresarDniPatenteFormulario(dniStr, patenteStr, stop);

        if not stop then
        begin
            dniStr := completarCeros(dniStr);

            indicePoliza := buscarIndicePoliza(fPolizas, dniStr, patenteStr);

            if indicePoliza = -1 then
                begin
                    indiceCliente := busquedaBinariaDNI(fClientes, dniStr);
                    
                    if indiceCliente <> -1 then
                    begin
                        cliente := buscarDatosCliente(fClientes, indiceCliente);
                        
                        if cliente.estado then
                        begin
                            menuAltaPoliza(fPolizas, dniStr, patenteStr, polizaRegistrada);
                        end
                        else
                        begin
                            ClrScr;
                            inicializarMenu(menuActual);
                            agregarOpcion(menuActual, 'Aceptar');
                            seleccionActual := 1;
                            menuHorizontal('El cliente no esta activo. Volviendo...', menuActual, seleccionActual, 45, 1, 0, 0);
                        end;
                    end
                    else
                    begin
                        ClrScr;
                        inicializarMenu(menuActual);
                        agregarOpcion(menuActual, 'Aceptar');
                        seleccionActual := 1;
                        menuHorizontal('El cliente con DNI ' + dniStr + ' no existe.', menuActual, seleccionActual, 40, 1, 0, 0);
                    end;
                end
            else
                begin
                    leerArchivoPolizas(fPolizas, indicePoliza, poliza);
                    menuVisualizacionPoliza(fPolizas, indicePoliza, poliza);
                end;
        end;
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
        archivoPolizas : tArchivoPolizas;
    begin
        inicializarArchivoClientes(archivoClientes, 'clientes.dat');
        inicializarArchivoPolizas(archivoPolizas, 'polizas.dat');

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
                2: gestionDePolizas(archivoClientes, archivoPolizas);
                3: listado;
                4: estadisticas;
            end;

        until seleccion = -1;
    end;
end.