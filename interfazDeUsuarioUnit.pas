unit interfazDeUsuarioUnit;



interface
    
uses crt;

const
    maxOpciones = 64;

type
    tecla = (arriba, abajo, izquierda, derecha, escape, enter, desconocido);

    Vector2 = record
        x : Word;
        y : Word;
    end;

    infoVentana = record
        topLeft : Vector2;
        bottomRight : Vector2;
    end;

    registroMenu = record
        opciones : array[1..maxOpciones] of String;
        cantidad : Integer;
    end;

function leerTecla : tecla;
function dimensionesDeTerminal : Vector2;
procedure dibujarCaja(esquinaSuperiorIzquierda : Vector2; esquinaInferiorDerecha : Vector2);
procedure dibujarEscape(salir : Boolean);
function dibujarVentana(titulo : String; ancho : Word; alto : Word) : infoVentana;
procedure menuVertical(titulo : String; var menuData : registroMenu; var seleccion : Integer);
procedure menuHorizontal(titulo : String; var menuData : registroMenu; var seleccion : Integer);
function adentroDeVentanaActual(coordenadas : Vector2; windowInfo : infoVentana) : Boolean;
procedure inicializarMenu(var menuData : registroMenu);
procedure agregarOpcion(var menuData : registroMenu; opcion : String);



implementation

    var
        windowSize : infoVentana;

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
                'W', 'w': // No vay a ser que el mañoso del usuario tenga las mayus activadas
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

    function dimensionesDeTerminal : Vector2;
    begin
        dimensionesDeTerminal.x := WindMaxX;
        dimensionesDeTerminal.y := WindMaxY;
    end;

    procedure dibujarCaja(esquinaSuperiorIzquierda : Vector2; esquinaInferiorDerecha : Vector2);
    var
        i,j : Word;
    begin
        for i := esquinaSuperiorIzquierda.x to esquinaInferiorDerecha.x do
        begin
            for j := esquinaSuperiorIzquierda.y to esquinaInferiorDerecha.y do
            begin
                GotoXY(i,j);
                if (j = esquinaSuperiorIzquierda.y) or (j = esquinaInferiorDerecha.y) or 
                   (i = esquinaSuperiorIzquierda.x) or (i = esquinaInferiorDerecha.x) then
                    Write('#');
            end;
        end;
    end;

    function dibujarVentana(titulo : String; ancho : Word; alto : Word) : infoVentana;
    var
        middle, topLeft, bottomRight : Vector2;
        dimensionesValidas : Boolean;
    begin
        bottomRight := dimensionesDeTerminal;

        {Verificacion de ancho y alto adecuado}
        if (ancho > (bottomRight.x - 42)) and (alto > (bottomRight.y - 8)) then
            dimensionesValidas := false
        else
            dimensionesValidas := true;

        if not dimensionesValidas then
        begin
            {Cero detectador de atrevidos}
            dibujarVentana.topLeft.x := 0;
        end
        else
        begin
            {Calculo de esquinas de ventana}
            middle.x := bottomRight.x div 2;
            middle.y := bottomRight.y div 2;

            topLeft.x := middle.x - ancho div 2;
            topLeft.y := middle.y - alto div 2;
            bottomRight.x := middle.x + ancho div 2;
            if (alto mod 2 = 1) then
                bottomRight.y := middle.y + alto div 2
            else
                bottomRight.y := (middle.y + alto div 2) - 1;


            {Dibujado(? de ventana}
            TextColor(Blue);
            dibujarCaja(topLeft,bottomRight);
            GotoXY(middle.x - (Length(titulo) div 2), topLeft.y + 2);
            TextColor(LightBlue);
            Write(titulo);
            TextColor(White);

            {Retorno de esquinas de ventana}
            dibujarVentana.topLeft := topLeft;
            dibujarVentana.bottomRight := bottomRight;
        end;
    end;
    
    procedure menuVertical(titulo : String; var menuData : registroMenu; var seleccion : Integer);
    var
        windowInfo : infoVentana;
        keyPressed : tecla;
        prefix : String[2];
        i : Integer;
        width, alto : Word;
    begin
        if menuData.cantidad > 0 then
        begin
            ClrScr;

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
            alto := menuData.cantidad + 6;
            ///////////////////////////////////////////////////////////////////////////////////

            windowInfo := dibujarVentana(titulo, width, alto);

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

                    keyPressed := leerTecla;

                    case keyPressed of
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
                                keyPressed := enter;
                            end;
                    end;
                until keyPressed = enter;
            end;
        end;
    end;

    procedure menuHorizontal(titulo : String; var menuData : registroMenu; var seleccion : Integer);
    var
        windowInfo : infoVentana;
        keyPressed : tecla;
        prefix : String[2];
        i : Integer;
        width, alto, anchoTotalOpciones, espacioEntreOpciones : Word;
        startX : Integer;
    begin
        if menuData.cantidad > 0 then
        begin
            ClrScr;

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

            width := Length(titulo);
            for i := 1 to menuData.cantidad do
            begin
                if Length(menuData.opciones[i]) > width then
                    width := Length(menuData.opciones[i]);
            end;

            if anchoTotalOpciones + 6 > width then
                width := anchoTotalOpciones + 6
            else
                width := width + 10;

            alto := 7;
            ///////////////////////////////////////////////////////////////////////////////////

            windowInfo := dibujarVentana(titulo, width, alto);

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

                    keyPressed := leerTecla;

                    case keyPressed of
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
                                keyPressed := enter;
                            end;
                    end;
                until keyPressed = enter;
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

    function adentroDeVentanaActual(coordenadas : Vector2; windowInfo : infoVentana) : Boolean;
    begin
        adentroDeVentanaActual := (coordenadas.x > windowInfo.topLeft.x) and 
                                  (coordenadas.x < windowInfo.bottomRight.x) and 
                                  (coordenadas.y > windowInfo.topLeft.y) and 
                                  (coordenadas.y < windowInfo.bottomRight.y);
    end;

end.