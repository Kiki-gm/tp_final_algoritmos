unit archivosUnit;

interface

type
    dataType = integer;
    fileType = file of dataType;

procedure InicializarArchivo(var f : fileType; path : String);
procedure LeerArchivo(var f : fileType; pos : Cardinal; var data : dataType);
procedure EscribirArchivo(var f : fileType; pos : Cardinal; data : dataType);
procedure MostrarArchivo(var f : fileType);
procedure MostrarLineaArchivo(var f : fileType; pos : Cardinal);
function UltimaLinea(var f : fileType): Integer;



implementation

    procedure InicializarArchivo(var f : fileType; path : String);
    begin
        Assign (f,path);
        {$i-}
        Reset (f);
        {$i+}
        If IOresult<>0 then
            Rewrite(f);
    end;

    procedure LeerArchivo(var f : fileType; pos : Cardinal; var data : dataType);
    var
        lastPos : Cardinal;
    begin
        lastPos := FilePos(f);
        Seek(f,pos);
        Read(f,data);
        Seek(f, lastPos);
    end;

    procedure EscribirArchivo(var f : fileType; pos : Cardinal; data : dataType);
    var
        lastPos : Cardinal;
    begin
        lastPos := FilePos(f);
        Seek(f,pos);
        Write(f,data);
        Seek(f, lastPos);
    end;

    procedure MostrarArchivo(var f : fileType);
    var
        lastPos : Cardinal;
        tempData : dataType;
    begin
        lastPos := FilePos(f);
        Reset(f);
        while not EOF(f) do
        begin
            Read(f,tempData);
            WriteLn(tempData);
        end;
        Seek(f,lastPos);
    end;

    procedure MostrarLineaArchivo(var f : fileType; pos : Cardinal);
    var
        lastPos : Cardinal;
        tempData : dataType;
    begin
        lastPos := FilePos(f);
        Seek(f,pos);
        Read(f,tempData);
        WriteLn(tempData);
        Seek(f, lastPos);
    end;

    function UltimaLinea(var f : fileType): Integer;
    begin
        UltimaLinea := FileSize(f) - 1;
    end;
    
end.