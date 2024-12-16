// server.js
const express = require('express');
const cors = require('cors');
const app = express();
const puerto = 5000;
const corsMiddle = cors();
const bodyParser = require('body-parser');
//se puede omitir el .js
const manejoArchivo = require('./script.js');

app.use(cors());
app.use(bodyParser.json()); // Permite leer JSON en el cuerpo de la solicitud

//Modificar para solo recibir solicitudes de una ruta especifica
app.get('/api/tareaPendiente', corsMiddle, async (req, res) => {
    try {
        //req.query para sacar datos atraves de la URL
        //req.body para sacar datos atraves de un FORM
        
        const {pagina, orden} = req.query || 1;
        var contenido;
        //console.log
        //orden mas antiguo
        if(orden == 0){
            
            contenido = await manejoArchivo.tareaPendienteAntigua(pagina-1);
            
        //orden mas reciente
        }else{
            
            contenido = await manejoArchivo.tareaPendienteReciente(pagina);

        }
        res.json(contenido);
    } catch (error) {
        console.error('Error al leer el archivo:', error);
        res.status(500).json({ error: 'Error al procesar la solicitud' });
    }

    // console.log("Solicitud recibida");
});

app.get('/api/tareaPendienteRealizada', corsMiddle, async (req, res) => {
    try {
        //req.query para sacar datos atraves de la URL
        //req.body para sacar datos atraves de un FORM
        
        const {pagina, orden} = req.query || 1;
        var contenido;
        //console.log
        //orden mas antiguo
        if(orden == 0){
            
            contenido = await manejoArchivo.tareaPendienteRealizadaAntigua(pagina-1);
            
        //orden mas reciente
        }else{
            
            contenido = await manejoArchivo.tareaPendienteRealizadaReciente(pagina);

        }
        res.json(contenido);
    } catch (error) {
        console.error('Error al leer el archivo:', error);
        res.status(500).json({ error: 'Error al procesar la solicitud' });
    }

    // console.log("Solicitud recibida");
});

app.get('/api/tareaRealizada', corsMiddle, async (req, res) => {
    try {
        //req.query para sacar datos atraves de la URL
        //req.body para sacar datos atraves de un FORM
        
        const {pagina, orden} = req.query || 1;
        var contenido;
        //console.log
        //orden mas antiguo
        if(orden == 0){
            
            contenido = await manejoArchivo.tareaRealizadaAntigua(pagina-1);
            
        //orden mas reciente
        }else{
            
            contenido = await manejoArchivo.tareaRealizadaReciente(pagina);

        }
        res.json(contenido);
    } catch (error) {
        console.error('Error al leer el archivo:', error);
        res.status(500).json({ error: 'Error al procesar la solicitud' });
    }

    // console.log("Solicitud recibida");
});

app.get('/api/paginacionPendiente', corsMiddle, async (req, res) => {

    var contenido;

    try{
        
        contenido = await manejoArchivo.obtenerPaginacionPendiente();

        res.json(contenido);
        
    }catch(error){

        console.error(error);
        res.status(500).json({ error: 'Error al procesar la solicitud' });
    }

    // console.log('Solicitud recibida');
});

app.get('/api/paginacionPendienteRealizada', corsMiddle, async (req, res) => {

    var contenido;

    try{

        contenido = await manejoArchivo.obtenerPaginacionPendienteRealizada();

        res.json(contenido);
    }catch(error){

        console.error(error);
        res.status(500).json({ error: 'Error al procesar la solicitud'});
    }

});

app.get('/api/paginacionRealizada', corsMiddle, async (req, res) => {

    var contenido;

    try{

        contenido = await manejoArchivo.obtenerPaginacionRealizada();

        res.json(contenido);
        
    }catch(error){

        console.error(error);
        res.status(500).json({error: 'Error al procesar la solicitud'});
    }
});

app.get('/api/obtenerArchivosDisponibles', corsMiddle, async (req, res) => {

    var contenido;

    try{

        contenido = await manejoArchivo.obtenerArchivosDisponibles();

        res.json(contenido);
        
    }catch(error){

        console.error(error);
        res.status(500).json({error: 'Error al procesar la solicitud'});
    }

});

app.put('/api/establecerArchivoSeleccionado', corsMiddle, async (req, res) => {

    try {
        
        const { archivo } = req.body;

        const contenido = await manejoArchivo.establecerArchivoSeleccionado(archivo);

        res.json(contenido);

    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Error al procesar la solicitud' });
    }
});

// Iniciar el servidor en el puerto especificado
app.listen(puerto, () => {
    console.log(`Servidor escuchando en http://localhost:${puerto}`);
});