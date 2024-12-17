//Realizar una opción predeterminada para el select
//Y que se reinicie esa opción cada vez que se recargue la página
$(document).ready(function () {
    const $selectTarea = $('#selectTarea');
    const $defaultOption = $('#defaultOption');

    const selectTarea = document.getElementById('selectTarea');

    $defaultOption.prop('selected', true);
    $defaultOption.prop('disabled', true);

    //Poner un mensaje de para avisar al usuario que debe 
    //seleccionar una archivo de tareas antes de seleccionar una opción de menu
    //A menos que exista solo un archivo de tareas que se seleccione de manera automatica
    selectTarea.setCustomValidity('Seleccione un archivo');
});

//0 Más antiguo
//1 Más reciente
var ordenSeleccionado = 0;

//1->No seleccionado
//0->Pendiente
//1->Pendiente+Realizada
//2->Realizada

var tareaSeleccionada = -1;

//Para colocar los botones de la paginacion
//pagina límite
var totalPagina = 0;

//Cantidad de botones que se generar cada vez
//que se presiona un botón de página
//3 botones siguientes y 3 anteriores
const generarPaginacion = 3;

//Para realizar siguiente y atras de la pagina
var paginaActual = 0;

//componentes necesarios para manejar el menu responsivo
const navMenu = document.getElementById('navMenu');
const abrirMenu = document.getElementById('abrirMenu');
const cerrarMenu = document.getElementById('cerrarMenu');

//agregar eventos a los botones de abrir y cerrar menu
abrirMenu.addEventListener('click', () => {

    navMenu.classList.add('active');

});

cerrarMenu.addEventListener('click', () => {

    navMenu.classList.remove('active');

});

const menuPendiente = () => {

    var selectTarea = document.getElementById('selectTarea');

    //Verificar que sea la opcion por defecto
    if (selectTarea.selectedIndex === 0) {

        selectTarea.reportValidity();
        
        return;
    }

    $.ajax({

        //hacer la peticion de la paginacion y tambien mostrar las primeras tareas
        url: 'http://localhost:5000/api/paginacionPendiente',
        type: 'get',
        success: function (dato) {

            // console.log('Respuesta del servidor', dato);

            totalPagina = dato.totalPagina;

            $('nav li').removeClass('seleccionada');

            $('#menuPendiente').addClass('seleccionada');

            $('.paginacion').empty();

            var valorPrimerBoton = 0;

            //var elemento = $('.paginacion');

            if (totalPagina > 0) {

                valorPrimerBoton = 1;
                paginaActual = 1;
            }

            tareaSeleccionada = 0;

            //Aqui se crean los botones y tambien se llama a las tareas correspondientes
            paginacion(valorPrimerBoton);

        },
        error: function (jqXHR, textStatus, errorThrown) {

            console.error('Error al realizar la solicitud:', textStatus, errorThrown);

            $('#cargar').removeClass('cargar');
        }
    });

}

const menuPendienteRealizada = () => {

    var selectTarea = document.getElementById('selectTarea');

    // Verifica si el campo select tiene una opción seleccionada
    // O que sea la opcion por defecto que no tiene ningun valor
    if (selectTarea.selectedIndex === 0) {

        selectTarea.reportValidity();
        
        return;
    }


    $.ajax({

        url: 'http://localhost:5000/api/paginacionPendienteRealizada',
        type: 'get',
        success: function (dato) {

            // console.log('Respuesta del servidor', dato);

            document.querySelectorAll('nav li').forEach(function (li) {

                li.classList.remove('seleccionada');

            });

            document.getElementById('menuPendienteRealizada').className = 'seleccionada';

            var valorPrimerBoton = 0;

            totalPagina = dato.totalPagina;

            if (totalPagina > 0) {

                valorPrimerBoton = 1;
                paginaActual = 1;
            }

            document.querySelectorAll('.paginacion').forEach(function (elemento) {

                elemento.innerHTML = '';

            });

            tareaSeleccionada = 1;

            //Aqui se crean los botones y tambien se llama a las tareas correspondientes
            paginacion(valorPrimerBoton);
        },
        error: function (jqXHR, textStatus, errorThrown) {

            console.error('Error al realizar la solicitud:', textStatus, errorThrown);

            $('#cargar').removeClass('cargar');

        }
    });

}

const menuRealizada = () => {

    var selectTarea = document.getElementById('selectTarea');

    // Verifica si el campo select tiene una opción seleccionada
    // O que sea la opcion por defecto que no tiene ningun valor
    if (selectTarea.selectedIndex === 0) {

        selectTarea.reportValidity();
        
        return;
    }

    $.ajax({

        url: 'http:localhost:5000/api/paginacionRealizada',
        type: 'get',
        success: function (dato) {

            // console.log('Respuesta del servidor', dato);

            $('nav li').removeClass('seleccionada');

            $('#menuRealizada').addClass('seleccionada');

            totalPagina = dato.totalPagina;

            $('.paginacion').empty();

            var valorPrimerBoton = 0;

            if (totalPagina > 0) {

                valorPrimerBoton = 1;
                paginaActual = 1;
            }

            tareaSeleccionada = 2;

            //Aqui se crean los botones y tambien se llama a las tareas correspondientes
            paginacion(valorPrimerBoton);
        },
        error: function (jqXHR, textStatus, errorThrown) {

            console.error('Error al realizar la solicitud:', textStatus, errorThrown);

            $('#cargar').removeClass('cargar');

        }  

    });

}

const tareaPendiente = (pagina) => {
    
    var parametro = {
        pagina: pagina,
        orden: ordenSeleccionado
    };

    $.ajax({
        data: parametro,
        url: 'http://localhost:5000/api/tareaPendiente',
        type: 'get',
        success: function (dato) {
            // Manejar la respuesta del servidor
            // console.log('Respuesta del servidor:', dato);
            $('#tarea').empty();

            for (let i = 0; i < dato.length; i++) {

                var columna1 = $('<td>', {

                    text: dato[i].tarea,
                    class: dato[i].estado
                });

                var columna2 = $('<td>', {

                    text: dato[i].fecha,
                    class: dato[i].estado
                });

                var fila = $('<tr>');

                fila.append(columna1);
                fila.append(columna2);

                $('#tarea').append(fila);

            }


            $('#cargar').removeClass('cargar');

        },
        error: function (jqXHR, textStatus, errorThrown) {
            console.error('Error al realizar la solicitud:', textStatus, errorThrown);
           
            $('#cargar').removeClass('cargar');

        }
    });
}

const tareaPendienteRealizada = (pagina) => {

    var parametro = {
        pagina: pagina,
        orden: ordenSeleccionado
    };

    $.ajax({

        data: parametro,
        url: 'http://localhost:5000/api/tareaPendienteRealizada',
        type: 'get',
        success: function (dato) {

            // console.log("Respuesta del servidor", dato);

            document.getElementById('tarea').innerHTML = '';

            for (let i = 0; i < dato.length; i++) {

                var columna1 = document.createElement('td');
                columna1.textContent = dato[i].tarea;
                columna1.className = dato[i].estado;

                var columna2 = document.createElement('td');
                columna2.textContent = dato[i].fecha;
                columna2.className = dato[i].estado;

                var fila = document.createElement('tr');
                fila.appendChild(columna1);
                fila.appendChild(columna2);

                document.getElementById('tarea').appendChild(fila);
            }

            document.getElementById('cargar').classList.remove('cargar');
        },
        error: function (jqXHR, textStatus, errorThrown) {

            console.error('Error al realizar la solicitud:', textStatus, errorThrown);
            document.getElementById('cargar').classList.remove('cargar');
        }
    });

}

const tareaRealizada = (pagina) => {

    var parametro = {
        pagina: pagina,
        orden: ordenSeleccionado
    };

    $.ajax({

        data: parametro,
        url: 'http://localhost:5000/api/tareaRealizada',
        type: 'get',
        success: function (dato) {

            // console.log("Respuesta del servidor", dato);

            $('#tarea').empty();

            for (let index = 0; index < dato.length; index++) {

                var columna1 = $('<td>', {

                    text: dato[index].tarea,
                    class: dato[index].estado

                });

                var columna2 = $('<td>', {

                    text: dato[index].fecha,
                    class: dato[index].estado
                });

                var fila = $('<tr>');

                fila.append(columna1);
                fila.append(columna2);

                $('#tarea').append(fila);
            }


            $('#cargar').removeClass('cargar');

        },
        error: function (jqXHR, textStatus, errorThrown) {

            console.error('Error al realizar la solicitud:', textStatus, errorThrown);
  
            $('#cargar').removeClass('cargar');

        }
    });

}

const cambiarOrden = () => {

    if (ordenSeleccionado === 0) {

        ordenSeleccionado = 1;
        $('#btn-ordenar').val("Más reciente");

    } else {

        ordenSeleccionado = 0;
        $('#btn-ordenar').val("Más antiguo");

    }

    //Al cambiar el orden, retrocede hacia la pagina 1 o a la pagina 0
    //si no tiene tareas disponibles
    const pagina = (totalPagina < 1) ? 0 : 1;

    paginacion(pagina);

}

const paginaSiguiente = () => {

    paginacion(paginaActual + 1);

}

const paginaAnterior = () => {

    paginacion(paginaActual - 1);

}

const paginacion = (pagina) => {

    $('#cargar').addClass('cargar');

    const opcionEjecutar = [
        tareaPendiente,
        tareaPendienteRealizada,
        tareaRealizada,
    ];

    paginaActual = pagina;

    //$('.pagina').removeClass('pagina');

    $('.paginacion').empty();

    //poner una cantidad de botones considerable atras
    $('.paginacion').each(function () {

        var boton = $('<input>', {
            type: "button",
            value: "<<<",
            click: function () {
                paginaAnterior();
            }
        });

        if (paginaActual - 1 < 1) {
            boton.addClass("bloqueado");
            boton.off("click");
        }

        $(this).append(boton);

        for (let index = pagina - generarPaginacion; index < pagina; index++) {

            if (index <= 0) {

                continue;
            }

            var boton = $('<input>', {
                type: "button",
                value: index,
                click: function () {
                    paginacion(index);
                }
            });

            $(this).append(boton);
        }

        //poner el boton marcado
        var boton = $('<input>', {
            class: 'pagina',
            type: "button",
            value: pagina,
            click: function () {
                paginacion(pagina);
            }
        });

        $(this).append(boton);
    });

    //colocar botones posteriores
    $('.paginacion').each(function () {

        for (let index = pagina + 1; index <= pagina + generarPaginacion && index <= totalPagina; index++) {

            var boton = $('<input>', {
                type: "button",
                value: index,
                click: function () {
                    paginacion(index);
                }
            });

            $(this).append(boton);

        }

        var boton = $('<input>', {
            type: "button",
            value: ">>>",
            click: function () {
                paginaSiguiente();
            }
        });

        $(this).append(boton);

        if (paginaActual + 1 > totalPagina) {

            boton.addClass("bloqueado");
            boton.off("click");
        }
    });

    opcionEjecutar[tareaSeleccionada](pagina);

}

const cargarListaTareas = () => {

    $.ajax({
        url: 'http://localhost:5000/api/obtenerArchivosDisponibles',
        type: 'get',
        success: function (dato) {

            dato.forEach(archivo => {

                var opcion = $('<option>', {
                    text: archivo.split('.')[0],
                    value: archivo
                });

                $('#selectTarea').append(opcion);

            });

            //si solo existe un archivo para seleccionar entonces se selecciona de manera automatica
            if(dato.length === 1){

                //reflejar el archivo seleccionado en el select
                const $selectTarea = $('#selectTarea');
                $selectTarea.prop('selectedIndex', 1);
                
                establecerArchivoSeleccionado(dato[0]);

            }
            
        },
        error: function (jqXHR, textStatus, errorThrown) {

            console.error('Error al realizar la solicitud:', textStatus, errorThrown);
  
            $('#cargar').removeClass('cargar');

        }
    });

}

const establecerArchivoSeleccionado = (opcion) => {

    const archivoSeleccionado = opcion;
    
    const menuEjecutar = [
        menuPendiente,
        menuPendienteRealizada,
        menuRealizada,
    ];

    var parametro = {
        archivo: archivoSeleccionado
    };
    
    $.ajax({
        url: "http://localhost:5000/api/establecerArchivoSeleccionado",
        type: "PUT", // Método HTTP
        contentType: "application/json", // Especifica el tipo de contenido
        data: JSON.stringify(parametro), // Convierte el objeto en una cadena JSON
        success: function (dato) {
            
            //si no se ha seleccionado un tipo de tarea (pendiente, realizada, ...)
            if(tareaSeleccionada < 0){

                menuPendienteRealizada();

            }//si ya se selecciono un tipo de tarea entonces se vuelve a cargar ese menu ya seleccionado
            else{

                menuEjecutar[tareaSeleccionada]();

            }

        },
        error: function (jqXHR, textStatus, errorThrown) {
            console.error("Error al realizar la solicitud:", textStatus, errorThrown);
        }
    });

};