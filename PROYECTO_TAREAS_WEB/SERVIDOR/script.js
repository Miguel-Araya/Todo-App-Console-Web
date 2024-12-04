const fs = require('fs');
const readline = require('readline');
const rutaArchivoTarea = 'C:/Users/Miguel/Desktop/RUBY/PROYECTO_TAREAS - ORIGINAL/TASK.txt';
//Para la paginacion
const limiteLinea = 7;
var cantidadPendiente = 0;
var cantidadPendienteRealizada = 0;
var cantidadRealizada = 0;

async function obtenerCantidadTarea(){
    
    return new Promise((resolve, reject) => {

    const archivoStream = fs.createReadStream(rutaArchivoTarea);

    const rl = readline.createInterface({
         input: archivoStream,
        crlfDelay: Infinity,
    });
    
    var lineaComparar = "";

    //console.log("entro a la funcion");

    rl.on('line', (linea) => {

        lineaComparar = linea.split("~");

        if (lineaComparar[lineaComparar.length-1].trim() === "done"){

            ++cantidadRealizada;

        }else{

            ++cantidadPendiente;

        }

    }); 

    rl.on('close', () => {
        resolve({cantidadPendienteRealizada: (cantidadRealizada+cantidadPendiente)});
    });

    rl.on('error', (error) => {
        reject(error);
    });

    });
}

async function tareaPendienteAntigua(pagina) {
    return new Promise((resolve, reject) => {
        
        const archivoStream = fs.createReadStream(rutaArchivoTarea);

        const rl = readline.createInterface({
            input: archivoStream,
            crlfDelay: Infinity,
        });

        let contadorLineaPendiente = 0;
        let contadorLineaGeneral = 1;
        var lineaComparar = "";
        let fecha = "";
        let parteLinea = 0;
        let tarea = "";
        const tareaPendiente = [];
        const estado = "pendiente";

        function procesarLinea(linea){
            
            lineaComparar = linea.split("~");

            if (lineaComparar[lineaComparar.length-1].trim() !== "done" && contadorLineaGeneral++ > (pagina*limiteLinea)) {

                linea = linea.split("Fecha: ");

                fecha = linea[linea.length-1];

                if(linea.length >= 2){

                    tarea += linea[0];
                    parteLinea++;
                }

                while(parteLinea < linea.length-1){

                    tarea += "Fecha: "+linea[parteLinea];
                    parteLinea++;
                }

                tarea = tarea.trimEnd();

                tareaPendiente.push({tarea: tarea,fecha: fecha, estado: estado});

                //contadorLineaPendiente++;

                if (++contadorLineaPendiente === limiteLinea) {
                    rl.removeListener('line', procesarLinea);
                    rl.close();
                }

                tarea = "";
                parteLinea = 0;
            }

            //++contadorLineaGeneral;

        }

        if(cantidadPendiente > 0){

            rl.on('line', procesarLinea);

        }else{

            tareaPendiente.push({tarea: "No existen tareas a mostrar", fecha: "xx/xx/xxxx", estado: "vacio"});

        }
        
        rl.on('close', () => {
            resolve(tareaPendiente);
        });

        rl.on('error', (error) => {
            reject(error);
        });
    });
}

async function tareaPendienteReciente(pagina) {
    return new Promise((resolve, reject) => {
        
        const archivoStream = fs.createReadStream(rutaArchivoTarea);

        const rl = readline.createInterface({
            input: archivoStream,
            crlfDelay: Infinity,
        });

        var contadorLineaPendiente = 0;
        var fecha = "";
        var lineaComparar = "";
        var parteLinea = 0;
        var tarea = "";
        var cantidadPendienteAux = cantidadPendiente;
        const estado = "pendiente";
        const tareaPendiente = [];

        const limiteReciente = (cantidadPendiente - (pagina*limiteLinea)) < 0? limiteLinea + (cantidadPendiente - (pagina*limiteLinea)) : limiteLinea;
        
        function procesarLinea(linea){

            //replace(/[\r\n]+/g, '')
            lineaComparar = linea.split("~");

            if(lineaComparar[lineaComparar.length-1].trim() !== "done"){
                    
                if((pagina*limiteLinea) >= cantidadPendienteAux){

                    linea = linea.split("Fecha: ");
    
                    fecha = linea[linea.length-1];
    
                    if(linea.length >= 2){
    
                        tarea += linea[0];
                        parteLinea++;
                    }
    
                    while(parteLinea < linea.length-1){
    
                        tarea += "Fecha: "+linea[parteLinea];
                        parteLinea++;
                    }
    
                    tarea = tarea.trimEnd();
    
                    tareaPendiente.push({tarea: tarea,fecha: fecha, estado: estado});
    
                    //++contadorLineaPendienteRealizada;
                    
                    if (++contadorLineaPendiente === limiteReciente) {
                        rl.removeListener('line', procesarLinea);
                        rl.close();
                    }

                    tarea = "";
                    parteLinea = 0;
                }
                
                --cantidadPendienteAux;
            }

        }

        if(cantidadPendiente > 0){
            rl.on('line', procesarLinea);
        }else{
            tareaPendiente.push({tarea: "No existen tareas a mostrar", fecha: "xx/xx/xxxx", estado: "vacio"});
        }

        rl.on('close', () => {
            resolve(tareaPendiente.reverse());
        });

        rl.on('error', (error) => {
            reject(error);
        });
    });
}

async function tareaPendienteRealizadaAntigua(pagina) {
    return new Promise((resolve, reject) => {
        const archivoStream = fs.createReadStream(rutaArchivoTarea);
        const rl = readline.createInterface({
            input: archivoStream,
            crlfDelay: Infinity,
        });

        let estado = "";
        let lineaComparar = "";
        let contadorLineaGeneral = 0;
        let fecha = "";
        let parteLinea = 0;
        let tarea = "";
        const tareaPendienteRealizada = [];

        // Función de procesamiento para cada línea
        function procesarLinea(linea) {

            if (++contadorLineaGeneral > (pagina * limiteLinea)) {

                lineaComparar = linea.split("~");

                if (lineaComparar[lineaComparar.length - 1].trim() === "done") {
                    estado = "realizada";
                } else {
                    estado = "pendiente";
                }

                linea = linea.split("Fecha: ");
                fecha = linea[linea.length - 1];
                fecha = fecha.split("~")[0];

                if (linea.length >= 2) {
                    tarea += linea[0];
                    parteLinea++;
                }

                while (parteLinea < linea.length - 1) {
                    tarea += "Fecha: " + linea[parteLinea];
                    parteLinea++;
                }

                tarea = tarea.trimEnd();
                tareaPendienteRealizada.push({ tarea: tarea, fecha: fecha, estado: estado });

                // Se hace la suma luego de la evaluación
                if ((contadorLineaGeneral % limiteLinea) === 0) {
                    rl.removeListener('line', procesarLinea);
                    rl.close();
                }

                tarea = "";
                parteLinea = 0;
            }

        }

        // Configurar el evento 'line' con la función de procesamiento
        if(cantidadPendienteRealizada > 0){

            rl.on('line', procesarLinea);

        }else{

            tareaPendienteRealizada.push({tarea: "No existen tareas a mostrar", fecha: "xx/xx/xxxx", estado: "vacio"});

        }
        
        rl.on('close', () => {
            resolve(tareaPendienteRealizada);
        });

        rl.on('error', (error) => {
            reject(error);
        });
    });
}

//REPARAR
async function tareaPendienteRealizadaReciente(pagina) {
    return new Promise((resolve, reject) => {
        
        const archivoStream = fs.createReadStream(rutaArchivoTarea);

        const rl = readline.createInterface({
            input: archivoStream,
            crlfDelay: Infinity,
        });

        var fecha = "";
        var lineaComparar = "";
        var estado = "";
        var parteLinea = 0;
        var tarea = "";
        var cantidadPendienteRealizadaAux = cantidadPendienteRealizada;
        const tareaPendienteRealizada = [];

        function procesarLinea(linea){

            //console.log("entro a realizada reciente, cantidadPedienteRealizadaAux", cantidadPendienteRealizadaAux);

            if((pagina*limiteLinea) >= cantidadPendienteRealizadaAux--){

                lineaComparar = linea.split("~");

                if(lineaComparar[lineaComparar.length-1].trim() === "done"){

                    estado = "realizada";

                }else{

                    estado = "pendiente";

                }   

                linea = linea.split("Fecha: ");
    
                fecha = linea[linea.length-1].split("~")[0];

                if(linea.length >= 2){
    
                    tarea += linea[0];
                    parteLinea++;
                }
    
                while(parteLinea < linea.length-1){
    
                    tarea += "Fecha: "+linea[parteLinea];
                    parteLinea++;
                }
    
                tarea = tarea.trimEnd();
    
                tareaPendienteRealizada.push({tarea: tarea,fecha: fecha, estado: estado});
        
                if ((cantidadPendienteRealizadaAux % limiteLinea) === 0) {
                    rl.removeListener('line', procesarLinea);
                    rl.close();
                }

                tarea = "";
                parteLinea = 0;
            }

        }

        if(cantidadPendienteRealizada > 0){

            rl.on('line', procesarLinea);

        }else{

            tareaPendienteRealizada.push({tarea: "No existen tareas a mostrar", fecha: "xx/xx/xxxx", estado: "vacio"});

        }

        rl.on('close', () => {
            resolve(tareaPendienteRealizada.reverse());
        });

        rl.on('error', (error) => {
            reject(error);
        });
    });
}

async function tareaRealizadaAntigua(pagina) {
    return new Promise((resolve, reject) => {
        
        const archivoStream = fs.createReadStream(rutaArchivoTarea);

        const rl = readline.createInterface({
            input: archivoStream,
            crlfDelay: Infinity,
        });

        let contadorLineaRealizada = 0;
        let contadorLineaGeneral = 1;
        var lineaComparar = "";
        let fecha = "";
        let parteLinea = 0;
        let tarea = "";
        const estado = "realizada";
        const tareaRealizada = [];

        function procesarLinea(linea){

            lineaComparar = linea.split("~");

            if (lineaComparar[lineaComparar.length-1].trim() === "done" && contadorLineaGeneral++ > (pagina*limiteLinea)) {

                linea = linea.split("Fecha: ");

                fecha = linea[linea.length-1].split("~")[0];

                if(linea.length >= 2){

                    tarea += linea[0];
                    parteLinea++;
                }

                while(parteLinea < linea.length-1){

                    tarea += "Fecha: "+linea[parteLinea];
                    parteLinea++;
                }

                tarea = tarea.trimEnd();

                tareaRealizada.push({tarea: tarea,fecha: fecha, estado: estado});

                //contadorLineaRealizada++;

                if (++contadorLineaRealizada === limiteLinea) {
                    rl.removeListener('line', procesarLinea);
                    rl.close();
                }

                tarea = "";
                parteLinea = 0;
            }

            //++contadorLineaGeneral;
        }

        if(cantidadRealizada > 0){

            rl.on('line', procesarLinea);

        }else{

            tareaRealizada.push({tarea: "No existen tareas a mostrar", fecha: "xx/xx/xxxx", estado: "vacio"});

        }

        rl.on('close', () => {
            resolve(tareaRealizada);
        });

        rl.on('error', (error) => {
            reject(error);
        });
    });
}

async function tareaRealizadaReciente(pagina) {
    return new Promise((resolve, reject) => {
        
        const archivoStream = fs.createReadStream(rutaArchivoTarea);

        const rl = readline.createInterface({
            input: archivoStream,
            crlfDelay: Infinity,
        });

        var contadorLineaRealizada = 0;
        var fecha = "";
        var lineaComparar = "";
        var parteLinea = 0;
        var tarea = "";
        var cantidadRealizadaAux = cantidadRealizada;
        const estado = "realizada";
        const tareaRealizada = [];

        const limiteReciente = (cantidadRealizada - (pagina*limiteLinea)) < 0? limiteLinea + (cantidadRealizada - (pagina*limiteLinea)) : limiteLinea;
        
        function procesarLinea(linea){

            lineaComparar = linea.split("~");

            if(lineaComparar[lineaComparar.length-1].trim() === "done"){
                    
                if((pagina*limiteLinea) >= cantidadRealizadaAux){
                    
                    linea = linea.split("Fecha: ");
    
                    fecha = linea[linea.length-1].split("~")[0];
    
                    if(linea.length >= 2){
    
                        tarea += linea[0];
                        parteLinea++;
                    }
    
                    while(parteLinea < linea.length-1){
    
                        tarea += "Fecha: "+linea[parteLinea];
                        parteLinea++;
                    }
    
                    tarea = tarea.trimEnd();
    
                    tareaRealizada.push({tarea: tarea,fecha: fecha, estado: estado});
    
                    //++contadorLineaPendienteRealizada;
                    
                    //realizar operacion limite linea en donde
                    //(pagina - cantidadRealizada) < 0? limiteLinea + (pagina - cantidadRealizada) : limiteLinea 

                    if (++contadorLineaRealizada === limiteReciente) {
                        rl.removeListener('line', procesarLinea);
                        rl.close();
                    }

                    tarea = "";
                    parteLinea = 0;
                }

                --cantidadRealizadaAux;
            }

        }

        if(cantidadRealizada > 0){
            
            rl.on('line', procesarLinea);

        }else{

            tareaRealizada.push({tarea: "No existen tareas a mostrar", fecha: "xx/xx/xxxx", estado: "vacio"});

        }
        
        rl.on('close', () => {
            resolve(tareaRealizada.reverse());
        });

        rl.on('error', (error) => {
            reject(error);
        });
    });
}

function obtenerPaginacionPendiente(){

    try{
        const cantidadPagina = {totalPagina: Math.ceil(cantidadPendiente/limiteLinea)};

        return cantidadPagina;

    }catch(error){
        return {totalPagina: 0};
    }

}

function obtenerPaginacionPendienteRealizada(){

    try{

        const cantidadPagina = {totalPagina: Math.ceil(cantidadPendienteRealizada/limiteLinea)};

        return cantidadPagina;
    }catch(error){

        return {totalPagina: 0};
        
    }

}

function obtenerPaginacionRealizada(){

    try{

        const cantidadPagina = {totalPagina: Math.ceil(cantidadRealizada/limiteLinea)};

        return cantidadPagina;

    }catch(error){

        return {totalPagina: 0};
    }
    
}

(async () => {
    try {
        const resultado = await obtenerCantidadTarea();
        cantidadPendienteRealizada = resultado.cantidadPendienteRealizada;
       
    } catch (error) {
        console.error('Error al ejecutar la función asíncrona:', error);
    }
})();

// Exporta la función para que pueda ser utilizada en otros archivos
module.exports = {
    tareaPendienteAntigua,
    tareaPendienteReciente,
    tareaPendienteRealizadaAntigua,
    tareaPendienteRealizadaReciente,
    tareaRealizadaAntigua,
    tareaRealizadaReciente,
    obtenerPaginacionPendiente,
    obtenerPaginacionPendienteRealizada,
    obtenerPaginacionRealizada,
};