program test;
uses crt, verificacionUnit;

begin
    WriteLn(isNumber('5.3'));
    WriteLn((stringToNumber('5.267') + stringToNumber(numberToString(4.733))):0:3);
end.