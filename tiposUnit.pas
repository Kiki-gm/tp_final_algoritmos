unit tiposUnit;

interface

type
    tDNI = string[8];
    tApellidoYNombres = String[64];
    tDireccion = String[32];
    tFecha = record
        yy : word;
        mm : 1..12;
        dd : 1..31;
    end;
    tCelular = String[32];
    tEmail = String[64];
    // este pipo de aca abajo es un enumerador :)
    tipoCobertura = (responsabilidadCivil, incendioYRoboTotal, incendioYRoboTotalYParcial, terceroCompleto, todoRiesgo); 
    tPatente = String[7];
    tEstado = Boolean;



implementation

end.
