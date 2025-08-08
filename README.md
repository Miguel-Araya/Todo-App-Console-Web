# Todo-App-Console-Web

## Descripción

Este repositorio contiene dos aplicaciones complementarias para la gestión de tareas:

* **Aplicación de consola**: interactiva y centrada en el manejo directo de listas de tareas desde la terminal. Su función principal es la creación y gestión de tareas.
* **Aplicación web**: accesible desde el navegador. Su función principal es la visualización de las tareas con una interfaz amigable.

---

## Aplicación de Consola

Permite gestionar tareas desde la terminal con diversas funcionalidades:

* Selección de una lista de tareas.
* Creación de nuevas tareas.
* Marcado de tareas como pendientes o realizadas.
* Búsqueda por nombre o palabra clave.
* Eliminación de tareas.
* Visualización del estado actual.
* Filtros por tipo:

  * Solo pendientes
  * Solo realizadas
  * Todas
* Paginación para facilitar la navegación.

---

## Aplicación Web

Brinda una interfaz visual para consultar tareas desde el navegador:

* Ordenamiento por fecha:

  * Más recientes primero
  * Más antiguas primero
* Selección de listas específicas.
* Filtros por estado:

  * Pendientes
  * Realizadas
  * Todas
* Paginación para navegación por bloques.

---

## Tecnologías Utilizadas

### Aplicación de Consola

* Ruby

### Aplicación Web

* HTML
* CSS
* JavaScript
* JQuery
* Node.js
* Express.js
---

## Automatización de Scripts

Se han incluido scripts `.bat` para facilitar la ejecución y automatización del sistema en entornos Windows.

### Script 1: Ejecutar servidor y abrir visualizador

**Archivo**: `Tareas.bat`

Este script inicia el servidor Node.js y abre automáticamente la interfaz visual de tareas en el navegador.

```bat
@echo off
setlocal

REM Ruta donde está el archivo del servidor Node.js
set directory_server=C:\Ruta\Al\Servidor

REM Ruta donde está el archivo HTML a abrir
set directory_page=C:\Ruta\A\La\PaginaHTML

REM Guardar la ruta actual
set current_path=%cd%

REM Cambiar a la ruta del servidor y ejecutar el servidor
cd %directory_server%
start /D %directory_server% node servidor.js

REM Volver a la ruta anterior
cd %current_path%

REM Abrir el visualizador en el navegador
start "" %directory_page%\visualizadorTarea.html

endlocal
```

> No requiere configuración adicional. Puedes ejecutarlo manualmente haciendo doble clic en el archivo.

---

### Script 2: Crear tarea programada al iniciar sesión

Este comando crea una tarea programada en Windows para ejecutar el script `Tareas.bat` automáticamente al iniciar sesión:

```cmd
SCHTASKS /CREATE /SC ONLOGON /TN "TareaInicio" /TR "C:\Ruta\Al\Script\Tareas.bat" /RU "<NOMBRE_USUARIO>" /I
```

**Parámetros**:

* `/SC ONLOGON`: Ejecutar al iniciar sesión.
* `/TN "TareaInicio"`: Nombre de la tarea.
* `/TR`: Ruta completa al script `.bat`.
* `/RU`: Usuario que ejecutará la tarea.
* `/I`: Ejecutar sin requerir tiempo de inactividad.

---

### Script 3: Acceso rápido a la consola en Ruby

**Archivo**: `AbrirConsola.bat`

Este script abre directamente la consola de Ruby para iniciar la gestión de tareas:

```bat
@echo off
setlocal

REM Ruta donde está la app de consola
set origin_dir=C:\Ruta\A\La\Console_App

cd %origin_dir%

REM Ejecutar el programa principal
start_program.bat

endlocal
```

> También puedes ingresar manualmente a la carpeta `Console_App` y ejecutar `start_program.bat` directamente.
