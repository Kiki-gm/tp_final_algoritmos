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

    procedure inicializarPoliza(var poliza : datosPoliza);

implementation
    procedure inicializarPoliza(var poliza : datosPoliza);
    begin
        poliza.yearVehicle := 2000;
        poliza.estado := true;
        poliza.fecha.carga.D := 1; 
        poliza.fecha.carga.M := 1; 
        poliza.fecha.carga.A := 2026;
        poliza.fecha.vigenciaDesde.D := 1; 
        poliza.fecha.vigenciaDesde.M := 1; 
        poliza.fecha.vigenciaDesde.A := 2026;
        poliza.fecha.vigenciaHasta.D := 1; 
        poliza.fecha.vigenciaHasta.M := 2; 
        poliza.fecha.vigenciaHasta.A := 2026;
        poliza.cobertura := terceroCompleto;
    end;
end.