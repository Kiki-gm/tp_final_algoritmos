unit interfazDeUsuarioUnit;



interface
    
uses crt;

type
    tecla = (arriba,abajo,escape,enter);


function leerTecla : tecla;
procedure dimensionesDeTerminal(var x : Word; var y : Word);
procedure dibujarCaja(x1 : Word; y1 : Word; x2 : Word; y2 : Word);




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

    procedure dimensionesDeTerminal(var x : Word; var y : Word);
    begin
        x := WindMaxX;
        y := WindMaxY;
    end;

    procedure dibujarCaja(x1 : Word; y1 : Word; x2 : Word; y2 : Word);
    var
        i,j : Word;
    begin
        for i := x1 to x2 do
        begin
            for j := y1 to y2 do
            begin
                GotoXY(i,j);
                if j = y1 then
                    Write('#')
                else if j = y2 then
                    Write('#')
                else if i = x1 then
                    Write('#')
                else if i = x2 then
                    Write('#');
            end;
        end;
    end;

end.