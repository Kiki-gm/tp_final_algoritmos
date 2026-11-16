unit polizasUnit;

interface
    uses tiposUnit;

    type
        datosPoliza = record
            numPol : String[32];
            DNI : tDNI;
            fecha : record
                carga : tFecha;
                vigenciaDesde : tFecha;
                vigenciaHasta : tFecha;
            end;
            marca : tMarca;
            modelo : tModelo;
            yearVehicle : Word;  //Me rehuso a utilizar "anioVehiculo", por más que sea lo ideal.
            patente : tPatente;
            sumaAsegurada : Real;
            cobertura : tipoCobertura;
            valorCuota : Real;
            estado : tEstado;
        end;

    procedure inicializarPoliza(var p : datosPoliza);

implementation
    procedure inicializarPoliza(var p : datosPoliza);
    begin
        p.yearVehicle := 1800;
        p.estado := true;
        p.fecha.carga.D := 1; 
        p.fecha.carga.M := 1; 
        p.fecha.carga.A := 2026;
        p.fecha.vigenciaDesde.D := 1; 
        p.fecha.vigenciaDesde.M := 1; 
        p.fecha.vigenciaDesde.A := 2026;
        p.fecha.vigenciaHasta.D := 1; 
        p.fecha.vigenciaHasta.M := 2; 
        p.fecha.vigenciaHasta.A := 2026;
        p.cobertura := terceroCompleto;
    end;
end.