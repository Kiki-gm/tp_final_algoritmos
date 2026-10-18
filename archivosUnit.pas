unit archivosUnit;

interface

type
    dataType = integer;
    fileType = file of dataType;

procedure InitializeFile(var f : fileType; path : String);
procedure ReadFile(var f : fileType; pos : Cardinal; var data : dataType);
procedure WriteFile(var f : fileType; pos : Cardinal; data : dataType);
procedure ShowFile(var f : fileType);
procedure ShowFileLine(var f : fileType; pos : Cardinal);
function FileLastI(var f : fileType): Integer;



implementation

    procedure InitializeFile(var f : fileType; path : String);
    begin
        Assign (f,path);
        {$i-}
        Reset (f);
        {$i+}
        If IOresult<>0 then
            Rewrite(f);
    end;

    procedure ReadFile(var f : fileType; pos : Cardinal; var data : dataType);
    var
        lastPos : Cardinal;
    begin
        lastPos := FilePos(f);
        Seek(f,pos);
        Read(f,data);
        Seek(f, lastPos);
    end;

    procedure WriteFile(var f : fileType; pos : Cardinal; data : dataType);
    var
        lastPos : Cardinal;
    begin
        lastPos := FilePos(f);
        Seek(f,pos);
        Write(f,data);
        Seek(f, lastPos);
    end;

    procedure ShowFile(var f : fileType);
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

    procedure ShowFileLine(var f : fileType; pos : Cardinal);
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

    function FileLastI(var f : fileType): Integer;
    begin
        FileLastI := FileSize(f) - 1;
    end;

end.