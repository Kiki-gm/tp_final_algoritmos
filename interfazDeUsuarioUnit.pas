unit interfazDeUsuarioUnit;



interface
    
uses crt;

const
    MAX_OPCIONES = 64;

type
    tecla = (arriba, abajo, escape, enter, desconocido);

    Vector2 = record
        x : Word;
        y : Word;
    end;

    infoVentana = record
        topLeft : Vector2;
        bottomRight : Vector2;
    end;

    registroMenu = record
        opciones : array[1..MAX_OPCIONES] of String;
        cantidad : Integer;
    end;

function leerTecla : tecla;
function dimensionesDeTerminal : Vector2;
procedure dibujarCaja(esquinaSuperiorIzquierda : Vector2; esquinaInferiorDerecha : Vector2);
procedure dibujarEscape(salir : Boolean);
function dibujarVentana(titulo : String; ancho : Word; alto : Word) : infoVentana;
procedure menu(titulo : String; var menuData : registroMenu; var seleccion : Integer);
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
                        #72, #87: 
                        begin
                            leerTecla := arriba;
                            keyDetected := true;
                        end;
                        #80, #83:
                        begin
                            leerTecla := abajo;
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

            topLeft.x := middle.x - (ancho div 2);
            topLeft.y := middle.y - (alto div 2);
            bottomRight.x := middle.x + (ancho div 2);
            bottomRight.y := middle.y + (alto div 2);

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

    procedure menu(titulo : String; var menuData : registroMenu; var seleccion : Integer);
    var
        windowInfo : infoVentana;
        keyPressed : tecla;
        prefix : String[2];
        i : Integer;
        width : Word;
    begin
        if menuData.cantidad > 0 then
        begin
            ClrScr;

            if titulo = 'Menu principal' then
                dibujarEscape(true)
            else
                dibujarEscape(false);

            width := Length(titulo);

            for i := 1 to menuData.cantidad do
            begin
                if Length(menuData.opciones[i]) > width then
                    width := Length(menuData.opciones[i]);
            end;
            
            windowInfo := dibujarVentana(titulo, width + 10, menuData.cantidad + 5);

            {Si el titulo anda atrevido no hacemos anda}
            if windowInfo.topLeft.x = 0 then
            begin
                seleccion := -1;
            end
            else
            begin
                repeat
                    for i := 1 to menuData.cantidad - 1 do
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
                        Write(prefix , menuData.opciones[i], ' ');
                    end;
                    GotoXY(dimensionesDeTerminal.x,dimensionesDeTerminal.y);
                    TextBackground(Black);
                    TextColor(White);

                    keyPressed := leerTecla;
                    case keyPressed of
                        arriba: 
                            if seleccion > 1 then 
                                seleccion := seleccion - 1 
                            else 
                                seleccion := menuData.cantidad - 1;
                        abajo: 
                            if seleccion < menuData.cantidad - 1 then 
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
        menuData.cantidad := 1;
    end;
    
    procedure agregarOpcion(var menuData : registroMenu; opcion : String);
    begin
        menuData.opciones[menuData.cantidad] := opcion;
        menuData.cantidad := menuData.cantidad + 1;
    end;

    function adentroDeVentanaActual(coordenadas : Vector2; windowInfo : infoVentana) : Boolean;
    begin
        adentroDeVentanaActual := (coordenadas.x > windowInfo.topLeft.x) and 
                                  (coordenadas.x < windowInfo.bottomRight.x) and 
                                  (coordenadas.y > windowInfo.topLeft.y) and 
                                  (coordenadas.y < windowInfo.bottomRight.y);
    end;

end.