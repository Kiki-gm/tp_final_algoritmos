unit polizasUnit;

interface
    uses tiposUnit;

    type
        datosPoliza = record
            numPol : String[32]; //
            DNI : tDNI; // 
            fecha : record
                carga : tFecha;
                vigenciaDesde : tFecha;
                vigenciaHasta : tFecha;
            end;
            marca : tMarca; //
            modelo : tModelo; //
            yearVehicle : Word;  //
            patente : tPatente; 
            sumaAsegurada : Real;
            cobertura : tipoCobertura;
            valorCuota : Real;
            estado : tEstado;
        end;

        {Cada auto tiene una marca, que a su vez tiene sus propios modelos. Cada marca tiene su propia
         lista de modelos. A su vez, cada modelo tiene su propio año. Por otra parte, cada marca y modelo
         tiene un multiplicador asociado, por ejemplo, 1.5, que en base a lo ingresado, se aplicará sobre 
         un monto base. 
         A efecto de esto, sería ideal que, al ingresar datos, la marca condicionara los modelos permitidos,
         y que, a partir de ahí, se busque la marca y modelo, se extraigan los mults y la edad, y se los coloque en una
         funcion para determinar suma asegurada.}

        datoListaModelos = record
            nombre : tModelo;
            edad : word; //Mi bello auto tiene seis años de edad ٩(ˊᗜˋ*)و ♡
            mult : Real;
        end;

        ListaModelos = record
            dato : datoListaModelos;
            tam : cardinal;
        end;

        DatoListaVehiculo = record
            nombre : tMarca;
            mult : Real;
            modelos : array[1..100] of ListaModelos;
            tam : cardinal;
        end;

        listaMarca = record
            tam : cardinal;
            marca : array[1..100] of DatoListaVehiculo;
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

    {Al inicio del programa, se establecen las marcas y sus modelos. 
     Eso sí, esto solo debería aplicar si la marca no existe o su mult es distinto.}

    procedure listaAgregarMarca(var l : listamarca; var marca : tMarca; mult : Real);
    begin
        inc(l.tam);
        l.marca[l.tam].nombre := marca;
        l.marca[l.tam].mult := mult;
    end;

    procedure listaAgregarModelo(var l : listaModelos; var modelo : tModelo; edad : word; mult : Real);
    begin
        inc(l.tam);
        l.modelos[l.tam].dato.nombre := modelo;
        l.modelos[l.tam].dato.edad := edad;
        l.modelos[l.tam].dato.mult := mult;
    end;
end.