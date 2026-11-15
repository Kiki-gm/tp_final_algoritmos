unit polizasUnit;

interface
uses tiposUnit;

type
    datosPoliza = record
        numPol : Cardinal;
        DNI : tDNI;
        fecha : record
            carga : tFecha;
            vigenciaDesde : tFecha;
            vigenciaHasta : tFecha;
        end;
        marca : String[20];
        modelo : String[40]; //Algunos modelos tienen nombres bastante largos.
        yearVehicle : Word;  //Me rehuso a utilizar "anioVehiculo", por más que sea lo ideal.
        patente : tPatente; //Considerar la posibilidad de los formatos "AA111AA" Y "AAA111" coexistiendo.
        sumaAsegurada : Real;
        cobertura : tipoCobertura;
        valorCuota : Real;
        estado : tEstado;
    end;


implementation

end.