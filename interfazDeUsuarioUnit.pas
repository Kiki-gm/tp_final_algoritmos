unit interfazDeUsuarioUnit;



interface
    
uses crt, verificacionUnit, tiposUnit;

const
    maxOpciones = 64;

type
    tecla = (arriba, abajo, izquierda, derecha, escape, enter, numero, texto, borrar);

    Vector2 = record
        x : Word;
        y : Word;
    end;

    infoVentana = record
        topLeft : Vector2;
        bottomRight : Vector2;
        cursor : Vector2;
    end;

    registroMenu = record
        opciones : array[1..maxOpciones] of String;
        cantidad : Integer;
    end;

function leerTecla : tecla;
procedure leerSoloNumeros(var stringModificable : String; max : Word; var teclaRetorno : tecla);
procedure leerSoloTexto(var stringModificable : String; max : Word; var teclaRetorno : tecla);
function dimensionesDeTerminal : Vector2;
procedure dibujarCaja(esquinaSuperiorIzquierda : Vector2; esquinaInferiorDerecha : Vector2);
procedure dibujarEscape(salir : Boolean);
procedure avanzarCursorVentana(var ventana : infoVentana);
procedure escribirEnVentana(ventana : infoVentana; input : String);
procedure escribirSeguido(var ventana : infoVentana; input : String; color : Byte);
function espacioLibre(ventana : infoVentana) : Integer;
procedure limpiarVentana(ventana : infoVentana);
procedure limpiarLineaEnVentana(ventana : infoVentana);
function dibujarVentana(titulo : String; anchoMinimo : Word; altoMinimo : Word; 
                        desplazamientoX : Integer; desplazamientoY : Integer) : infoVentana;
procedure menuVertical(titulo : String; var menuData : registroMenu; var seleccion : Integer; 
                       desplazamientoX : Integer; desplazamientoY : Integer);
procedure menuHorizontal(titulo : String; var menuData : registroMenu; var seleccion : Integer; 
                         anchoMinimo : Word; altoMinimo : Word; desplazamientoX : Integer; 
                         desplazamientoY : Integer);
procedure inicializarMenu(var menuData : registroMenu);
procedure agregarOpcion(var menuData : registroMenu; opcion : String);


implementation

    function leerTecla : tecla;
    var
        ch : Char;
        keyDetected : Boolean;
    begin
        keyDetected := false;
        repeat 
            ch := ReadKey;
            case ch of
                #0: 
                begin
                    ch := ReadKey;
                    case ch of
                        #72:
                        begin
                            leerTecla := arriba;
                            keyDetected := true;
                        end;
                        #80:
                        begin
                            leerTecla := abajo;
                            keyDetected := true;
                        end;
                        #75:
                        begin
                            leerTecla := izquierda;
                            keyDetected := true;
                        end;
                        #77:
                        begin
                            leerTecla := derecha;
                            keyDetected := true;
                        end;
                    end;
                end;
                #27: 
                begin
                    leerTecla := escape;
                    keyDetected := true; 
                end;
                #13:
                begin
                    leerTecla := enter;
                    keyDetected := true;
                end;
                'W', 'w':
                begin
                    leerTecla := arriba;
                    keyDetected := true;
                end;
                'S', 's':
                begin
                    leerTecla := abajo;
                    keyDetected := true;
                end;
                'A', 'a':
                begin
                    leerTecla := izquierda;
                    keyDetected := true;
                end;
                'D', 'd':
                begin
                    leerTecla := derecha;
                    keyDetected := true;
                end;
            end;
        until keyDetected;
    end;

    procedure leerSoloTexto(var stringModificable : String; max : Word; var teclaRetorno : tecla);
    var
        ch : Char;
    begin
        ch := ReadKey;
        
        if (ch >= #32) and (ch <= #126) then 
        begin
            if Length(stringModificable) < max then 
            begin
                stringModificable := stringModificable + ch;
                teclaRetorno := texto; 
            end;
        end
        else
        begin
            case ch of
                #8: 
                begin
                    if Length(stringModificable) > 0 then
                        Delete(stringModificable, Length(stringModificable), 1);
                    teclaRetorno := borrar;
                end;
                #13:
                    teclaRetorno := enter;
                #27: 
                    teclaRetorno := escape;
                #0:
                begin
                    ch := ReadKey;
                    teclaRetorno := arriba;
                end;
            end;
        end;
    end;

    procedure leerSoloNumeros(var stringModificable : String; max : Word; var teclaRetorno : tecla);
    var
        teclaPresionada : String;
    begin
        teclaPresionada := ReadKey;

        if esNumero(teclaPresionada) and (Length(stringModificable) < max) then
        begin
            stringModificable := stringModificable + teclaPresionada;
            teclaRetorno := numero;
        end;

        case teclaPresionada of
            #0: 
            begin
                teclaPresionada := ReadKey;
                if teclaPresionada = #83 then
                    Delete(stringModificable,Length(stringModificable),1);
                teclaRetorno := borrar;
            end;
            #8:
            begin
                Delete(stringModificable,Length(stringModificable),1);
                teclaRetorno := borrar;
            end;
            #13: teclaRetorno := enter;
            #27: teclaRetorno := escape;
        end;
    end;

    procedure avanzarCursorVentana(var ventana : infoVentana);
    begin
        Inc(ventana.cursor.y);
        if (ventana.cursor.y > (ventana.bottomRight.y - 2)) then
        begin
            ventana.cursor.y := ventana.topLeft.y + 4;
        end;
    end;

    procedure escribirEnVentana(ventana : infoVentana; input : String);
    begin
        GotoXY(ventana.cursor.x, ventana.cursor.y);
        Write(input);
    end;

    procedure escribirSeguido(var ventana : infoVentana; input : String; color : Byte);
    begin
        GotoXY(ventana.cursor.x, ventana.cursor.y);
        TextColor(color);
        Write(input);
        ventana.cursor.x := ventana.cursor.x + Length(input);
    end;

    function espacioLibre(ventana : infoVentana) : Integer;
    begin
        espacioLibre := Integer(ventana.bottomRight.x) - 1 - Integer(ventana.cursor.x);
    end;

    procedure limpiarVentana(ventana : infoVentana);
    var
        tempString : String;
        i : Word;
    begin
        tempString := '';
        for i := 1 to ((ventana.bottomRight.x - ventana.topLeft.x) - 2) do
        begin
            tempString := tempString + ' ';
        end;
        for i := 1 to ((ventana.bottomRight.y - ventana.topLeft.y) - 4) do
        begin
            escribirEnVentana(ventana, tempString);
            avanzarCursorVentana(ventana);
        end;
    end;

    procedure limpiarLineaEnVentana(ventana : infoVentana);
    var
        tempString : String;
        i : Word;
    begin
        tempString := '';
        for i := 1 to ((ventana.bottomRight.x - ventana.topLeft.x) - 2) do
        begin
            tempString := tempString + ' ';
        end;
        escribirEnVentana(ventana, tempString);
    end;

    function dimensionesDeTerminal : Vector2;
    begin
        dimensionesDeTerminal.x := WindMaxX;
        dimensionesDeTerminal.y := WindMaxY;
    end;

    procedure dibujarCaja(esquinaSuperiorIzquierda : Vector2; esquinaInferiorDerecha : Vector2);
    var
        i, j : Word;
    begin
        for i := esquinaSuperiorIzquierda.x to esquinaInferiorDerecha.x do
        begin
            GotoXY(i, esquinaSuperiorIzquierda.y);  Write('#');
            GotoXY(i, esquinaInferiorDerecha.y);    Write('#');
        end;
        for j := esquinaSuperiorIzquierda.y + 1 to esquinaInferiorDerecha.y - 1 do
        begin
            GotoXY(esquinaSuperiorIzquierda.x, j);  Write('#');
            GotoXY(esquinaInferiorDerecha.x, j);    Write('#');
        end;
    end;

    function dibujarVentana(titulo : String; anchoMinimo : Word; altoMinimo : Word; desplazamientoX : Integer; desplazamientoY : Integer) : infoVentana;
    var
        middle, topLeft, bottomRight : Vector2;
        dimensionesValidas : Boolean;
    begin
        bottomRight := dimensionesDeTerminal;

        if altoMinimo = 0 then
            altoMinimo := 5
        else
            altoMinimo := altoMinimo + 6;

        if (anchoMinimo > (bottomRight.x - 42)) and (altoMinimo > (bottomRight.y - 8)) then
            dimensionesValidas := false
        else
            dimensionesValidas := true;

        if not dimensionesValidas then
        begin
            dibujarVentana.topLeft.x := 0;
        end
        else
        begin
            middle.x := (bottomRight.x div 2) + desplazamientoX;
            middle.y := (bottomRight.y div 2) + desplazamientoY;

            topLeft.x := middle.x - anchoMinimo div 2;
            topLeft.y := middle.y - altoMinimo div 2;
            bottomRight.x := middle.x + anchoMinimo div 2;
            if (altoMinimo mod 2 = 1) then
                bottomRight.y := middle.y + altoMinimo div 2
            else
                bottomRight.y := (middle.y + altoMinimo div 2) - 1;


            TextColor(Blue);
            dibujarCaja(topLeft,bottomRight);
            GotoXY(middle.x - (Length(titulo) div 2), topLeft.y + 2);
            TextColor(LightBlue);
            Write(titulo);
            TextColor(White);

            dibujarVentana.topLeft := topLeft;
            dibujarVentana.bottomRight := bottomRight;
            dibujarVentana.cursor.x := topLeft.x + 2;
            dibujarVentana.cursor.y := topLeft.y + 4;
        end;
    end;
    
    procedure menuVertical(titulo : String; var menuData : registroMenu; var seleccion : Integer; desplazamientoX : Integer; desplazamientoY : Integer);
    var
        windowInfo : infoVentana;
        teclaPresionada : tecla;
        prefix : String[2];
        i : Integer;
        width, height : Word;
    begin
        if menuData.cantidad > 0 then
        begin
            if titulo = 'Menu principal' then
                dibujarEscape(true)
            else
                dibujarEscape(false);

            ///////////////////////////////////////////////////////////////////////////////////
            { Calculo de dimensiones }
            width := Length(titulo);
            for i := 1 to menuData.cantidad do
            begin
                if Length(menuData.opciones[i]) > width then
                    width := Length(menuData.opciones[i]);
            end;
            width := width + 10;
            height := menuData.cantidad;
            ///////////////////////////////////////////////////////////////////////////////////

            windowInfo := dibujarVentana(titulo, width, height, desplazamientoX, desplazamientoY);

            if windowInfo.topLeft.x = 0 then
            begin
                seleccion := -1;
            end
            else
            begin
                if (seleccion < 1) or (seleccion > menuData.cantidad) then
                    seleccion := 1;

                repeat
                    { Renderizado de opciones }
                    for i := 1 to menuData.cantidad do
                    begin
                        GotoXY(windowInfo.topLeft.x + 2, windowInfo.topLeft.y + 3 + i);

                        if i = seleccion then
                        begin
                            TextColor(Cyan);
                            prefix := '> ';
                        end
                        else
                        begin
                            TextColor(White);
                            prefix := '- ';
                        end;
                        Write(prefix, menuData.opciones[i], ' ');
                    end;

                    GotoXY(dimensionesDeTerminal.x, dimensionesDeTerminal.y);
                    TextBackground(Black);
                    TextColor(White);

                    teclaPresionada := leerTecla;

                    case teclaPresionada of
                        arriba: 
                            if seleccion > 1 then 
                                seleccion := seleccion - 1 
                            else 
                                seleccion := menuData.cantidad;
                        abajo: 
                            if seleccion < menuData.cantidad then 
                                seleccion := seleccion + 1 
                            else 
                                seleccion := 1;
                        escape:
                            begin
                                seleccion := -1; 
                                teclaPresionada := enter;
                            end;
                    end;
                until teclaPresionada = enter;
            end;
        end;
    end;

    procedure menuHorizontal(titulo : String; var menuData : registroMenu; var seleccion : Integer; anchoMinimo : Word; altoMinimo : Word; desplazamientoX : Integer; desplazamientoY : Integer);
    var
        windowInfo : infoVentana;
        teclaPresionada : tecla;
        prefix : String[2];
        i : Integer;
        width, height, anchoTotalOpciones, espacioEntreOpciones : Word;
        startX : Integer;
    begin
        if menuData.cantidad > 0 then
        begin
            if titulo = 'Menu principal' then
                dibujarEscape(true)
            else
                dibujarEscape(false);

            ///////////////////////////////////////////////////////////////////////////////////
            { Calculo de dimensiones }
            espacioEntreOpciones := 4; 
            anchoTotalOpciones := 0;

            for i := 1 to menuData.cantidad do
            begin
                anchoTotalOpciones := anchoTotalOpciones + Length(menuData.opciones[i]) + 4;
            end;

            anchoTotalOpciones := anchoTotalOpciones + (espacioEntreOpciones * (menuData.cantidad - 1));

            width := anchoMinimo;
            if width < Length(titulo) then
                width := Length(titulo);
            
            if anchoTotalOpciones + 6 > width then
                width := anchoTotalOpciones + 6
            else
                width := width + 10;

            height := altoMinimo;
            ///////////////////////////////////////////////////////////////////////////////////

            windowInfo := dibujarVentana(titulo, width, height, desplazamientoX, desplazamientoY);

            if windowInfo.topLeft.x = 0 then
            begin
                seleccion := -1;
            end
            else
            begin
                if (seleccion < 1) or (seleccion > menuData.cantidad) then
                    seleccion := 1;

                repeat
                    { Renderizado de opciones }
                    startX := windowInfo.topLeft.x + 6;
                    for i := 1 to menuData.cantidad do
                    begin
                        GotoXY(startX, windowInfo.bottomRight.y - 2);

                        if i = seleccion then
                        begin
                            TextColor(Cyan);
                            prefix := '> ';
                        end
                        else
                        begin
                            TextColor(White);
                            prefix := '  ';
                        end;
                        Write(prefix, menuData.opciones[i]);

                        startX := startX + Length(menuData.opciones[i]) + 4 + espacioEntreOpciones - 2;
                    end;

                    GotoXY(dimensionesDeTerminal.x, dimensionesDeTerminal.y);
                    TextBackground(Black);
                    TextColor(White);

                    teclaPresionada := leerTecla;

                    case teclaPresionada of
                        izquierda: 
                            if seleccion > 1 then 
                                seleccion := seleccion - 1 
                            else 
                                seleccion := menuData.cantidad;
                        derecha: 
                            if seleccion < menuData.cantidad then 
                                seleccion := seleccion + 1 
                            else 
                                seleccion := 1;
                        escape:
                            begin
                                seleccion := -1; 
                                teclaPresionada := enter;
                            end;
                    end;
                until teclaPresionada = enter;
            end;
        end;
    end;

    procedure dibujarEscape(salir : Boolean);
    begin
        GotoXY(1,1);
        TextColor(Blue);
        WriteLn('#-----------------#');
        GotoXY(1,2);
        Write('| ');
        TextColor(White);
        if salir then
            Write('Salir')
        else
            Write('Atras');
        TextColor(LightBlue);
        Write(' -> ');
        TextColor(White);
        Write('Escape');
        TextColor(Blue);
        WriteLn(' |');
        GotoXY(1,3);
        WriteLn('#-----------------#');
        TextColor(White);
    end;

    procedure inicializarMenu(var menuData : registroMenu);
    begin
        FillChar(menuData, SizeOf(menuData), #0);
        menuData.cantidad := 0;
    end;
    
    procedure agregarOpcion(var menuData : registroMenu; opcion : String);
    begin
        menuData.cantidad := menuData.cantidad + 1;
        menuData.opciones[menuData.cantidad] := opcion;
    end;

end.