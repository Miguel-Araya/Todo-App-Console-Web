@echo off

REM Copy the files to make the backup

setlocal enabledelayedexpansion

title Make Backup

set newName=""
set directory="PROYECTO_BACKUP"
set /a counter=0
set /a activeExtension=0
set extension=""
set character=""
set file=""

pushd .

cd ..

if not exist %directory% ( mkdir %directory% )

popd

for %%i in (*.rb *.txt) do ( 

   pushd .              

   copy /Y %%i .. >nul

   cd ..

   set /a counter=0
   set file=%%i
   set character=!file:~%counter%,1!
   set newName=
   set extension=
   set /a activeExtension=0
   set /a counter+=1

   call :while

   move /Y %%i %directory%/!newName!_BACKUP!extension! >nul

   popd
)

   REM Not execute the code of the label cause is out of the loop

   goto :exit

    :while

      if "!character!" NEQ "." if !activeExtension! == 0 (
         set /a counter+=1
         set newName=!newName!!character!
         set character=!file:~%counter%,1!
         goto :while
      )
      
      if "!character!" == "." (
        
        set /a activeExtension=1
      ) 

      if !activeExtension! == 1 if "!character!" NEQ "" (
         set extension=!extension!!character!
         set character=!file:~%counter%,1!
         set /a counter+=1             

         goto :while
      )
      
    :exit

endlocal