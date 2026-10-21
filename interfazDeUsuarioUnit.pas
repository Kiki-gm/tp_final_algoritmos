unit interfazDeUsuarioUnit;



interface
    
uses crt;

type
    tecla = (arriba,abajo,escape,enter);
    Vector2 = record
        x : Word;
        y : Word;
    end;

function leerTecla : tecla;
function dimensionesDeTerminal : Vector2;
procedure dibujarCaja(esquinaSuperiorIzquierda : Vector2; esquinaInferiorDerecha : Vector2);
procedure dibujarEscape;
procedure dibujarVentana(titulo : String; ancho : Word; alto : Word);
procedure dibujarMenuPrincipal(seleccion : Byte);
function adentroDeVentanaActual(coordenadas : Vector2) : Boolean;


implementation

    var
        topLeftCorner, bottomRightCorner : Vector2;

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
                        #87:
                        begin
                            leerTecla := arriba;
                            keyDetected := true;
                        end;
                        #83:
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
                'W':
                begin
                    leerTecla := arriba;
                    keyDetected := true;
                end;
                'w':
                begin
                    leerTecla := arriba;
                    keyDetected := true;
                end;
                'S':
                begin
                    leerTecla := abajo;
                    keyDetected := true;
                end;
                's':
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
                if j = esquinaSuperiorIzquierda.y then
                    Write('#')
                else if j = esquinaInferiorDerecha.y then
                    Write('#')
                else if i = esquinaSuperiorIzquierda.x then
                    Write('#')
                else if i = esquinaInferiorDerecha.x then
                    Write('#');
            end;
        end;
    end;

    procedure dibujarMenuPrincipal(seleccion : Byte);
    begin

    end;

    procedure dibujarVentana(titulo : String; ancho : Word; alto : Word);
    var
        middle, topLeft, bottomRight : Vector2;
    begin
        bottomRight := dimensionesDeTerminal;
        
        if ancho < Length(titulo) then
            ancho := Length(titulo);
        
        if ancho > bottomRight.x then
            ancho := bottomRight.x;
        
        if (alto + 2) > bottomRight.y then
            alto := bottomRight.y - 2;

        middle.x := bottomRight.x div 2;
        middle.y := bottomRight.y div 2;

        topLeft.x := middle.x - (ancho div 2);
        topLeft.y := middle.y - (alto div 2);
        bottomRight.x := middle.x + (ancho div 2);
        bottomRight.y := middle.y + (alto div 2);

        TextColor(Blue);
        dibujarCaja(topLeft,bottomRight);
        GotoXY(middle.x + 1 - (Length(titulo) div 2), topLeft.y + 1);
        TextColor(LightBlue);
        Write(titulo);
        TextColor(White);
    end;

    procedure dibujarEscape;
    begin
        GotoXY(1,1);
        TextColor(Blue);
        WriteLn('#-----------------#');
        GotoXY(1,2);
        Write('| ');
        TextColor(White);
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

    function adentroDeVentanaActual(coordenadas : Vector2) : Boolean;
    begin

    end;

end.