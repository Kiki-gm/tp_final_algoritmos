unit polizasUnit;

interface

type
    tFecha = record
        yy : word;
        mm : 1..12;
        dd : 1..31;
    end;

    datospoliza = record
        DNI : String[8];
        fecha : record;
            carga : tFecha;
            vigenciaDesde : tFecha;
            vigenciaHasta : tFecha;
        marca : String[20];
        modelo : String[40]; //Algunos modelos tienen nombres bastante largos.
        yearVehicle : word;  //Me rehuso a utilizar "anioVehiculo", por más que sea lo ideal.
        patente : String[7]; //Considerar la posibilidad de los formatos "AA111AA" Y "AAA111" coexistiendo.
        sumaAsegurada : Real;
        tipoCobertura : String[4]; //RC, IRT, IRTP, TC, TR.
        valorCuota : Real;
        estado : Boolean;
  end; 


implementation

end.