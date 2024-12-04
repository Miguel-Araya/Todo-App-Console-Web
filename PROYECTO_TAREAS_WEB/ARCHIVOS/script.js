//0 Mas antiguo
//1 Mas reciente
var ordenSeleccionado = 0;

//0->Pendiente
//1->Pendiente+Realizada
//2->Realizada
var tareaSeleccionada = 1;

//Para colocar los botones de la paginacion
//pagina limite
var totalPagina = 0;

//Cantidad de botones que se generar cada vez
//que se presiona un boton de pagina
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

            //El codigo anterior tambien puede ser
            // Obtén todos los elementos con la clase 'paginacion'
            // var paginacionElements = document.querySelectorAll('.paginacion');

            // // Itera sobre los elementos y vacía su contenido usando un bucle for
            // for (var i = 0; i < paginacionElements.length; i++) {
            //     paginacionElements[i].innerHTML = '';
            // }

            // document.querySelectorAll('.paginacion').forEach(function (elemento) {

            //     var primerBoton = document.createElement('input');
            //     primerBoton.type = 'button';
            //     primerBoton.className = 'pagina';
            //     primerBoton.value = valorPrimerBoton;
            //     primerBoton.onclick = function () {

            //         paginacion(valorPrimerBoton);

            //     };

            //     elemento.appendChild(primerBoton);

            //     for (let index = 2; index <= (2 + generarPaginacion) && index <= totalPagina; index++) {

            //         var boton = document.createElement('input');
            //         boton.type = 'button';
            //         boton.value = index;
            //         boton.onclick = function () {
            //             paginacion(index);
            //         };

            //         elemento.appendChild(boton);
            //     }

            // });

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

            // $('.paginacion').each(function () {

            //     var primerBoton = $('<input>', {
            //         type: "button",
            //         class: "pagina",
            //         value: valorPrimerBoton,
            //         click: function () {
            //             paginacion(valorPrimerBoton);
            //         }
            //     });

            //     $(this).append(primerBoton);

            //     for (let index = 2; index <= (generarPaginacion + 2) && index <= totalPagina; index++) {

            //         var boton = $('<input>', {
            //             type: 'button',
            //             value: index,
            //             click: function () {
            //                 paginacion(index);
            //             }
            //         });

            //         $(this).append(boton);
            //     }

            // });

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
    const pagina = (1 <= totalPagina) ? 1 : 0;

    paginacion(pagina);

}

const paginaSiguiente = () => {

    paginacion(paginaActual + 1);

}

const paginaAnterior = () => {

    paginacion(paginaActual - 1);

}

const paginacion = (botonPagina) => {

    $('#cargar').addClass('cargar');

    const opcionEjecutar = [
        tareaPendiente,
        tareaPendienteRealizada,
        tareaRealizada,
    ];

    paginaActual = botonPagina;

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

        for (let index = botonPagina - generarPaginacion; index < botonPagina; index++) {

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
            value: botonPagina,
            click: function () {
                paginacion(botonPagina);
            }
        });

        $(this).append(boton);
    });

    //colocar botones posteriores
    $('.paginacion').each(function () {

        for (let index = botonPagina + 1; index <= botonPagina + generarPaginacion && index <= totalPagina; index++) {

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

    opcionEjecutar[tareaSeleccionada](botonPagina);

}