// server.js
const express = require('express');
const cors = require('cors');
const app = express();
const puerto = 5000;
const corsMiddle = cors();
//se puede omitir el .js
const manejoArchivo = require('./script.js');

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

app.get('/api/paginacionPendiente', corsMiddle, (req, res) => {

    var contenido;

    try{
        
        contenido = manejoArchivo.obtenerPaginacionPendiente();

        res.json(contenido);
        
    }catch(error){

        console.error(error);
        res.status(500).json({ error: 'Error al procesar la solicitud' });
    }

    // console.log('Solicitud recibida');
});

app.get('/api/paginacionPendienteRealizada', corsMiddle, (req, res) => {

    var contenido;

    try{

        contenido = manejoArchivo.obtenerPaginacionPendienteRealizada();

        res.json(contenido);
    }catch(error){

        console.error(error);
        res.status(500).json({ error: 'Error al procesar la solicitud'});
    }

});

app.get('/api/paginacionRealizada', corsMiddle, (req, res) => {

    var contenido;

    try{

        contenido = manejoArchivo.obtenerPaginacionRealizada();

        res.json(contenido);
        
    }catch(error){

        console.error(error);
        res.status(500).json({error: 'Error al procesar la solicitud'});
    }
});

// Manejar solicitud GET a /api/ejemplo
/*
app.get('/api/tareaPendiente', (req, res) => {
    console.log("Solicitud recibida");
    res.json({ mensaje: 'Hola desde el servidor Node.js!' });
});
*/
// Iniciar el servidor en el puerto especificado
app.listen(puerto, () => {
    console.log(`Servidor escuchando en http://localhost:${puerto}`);
});