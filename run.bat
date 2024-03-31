:: El objetivo es ejecutar programas con seguridad de su autenticidad. Este programa solo funciona correctamente en Windows.
@echo off
chcp 65001
setlocal

for /f %%b in ('certutil -hashfile "./checker.bat" MD5 ^| find /v ":"') do set "current_hash=%%b"
echo Hash calculado de este archivo: %current_hash%
set /p "archivo_path=Ingrese la ruta del archivo: "
set /p "hash_type=Ingrese el tipo de hash (MD5 o SHA256): "
set /p "input_hash=Ingrese el hash: "

:: Verificar si el archivo existe
if not exist "%archivo_path%" (
    echo El archivo no existe.
    goto :eof
)

:: Calcular el hash del archivo según el tipo seleccionado
if /i "%hash_type%"=="MD5" (
    for /f %%a in ('certutil -hashfile "%archivo_path%" MD5 ^| find /v ":"') do set "archivo_hash=%%a"
) else if /i "%hash_type%"=="SHA256" (
    for /f %%a in ('certutil -hashfile "%archivo_path%" SHA256 ^| find /v ":"') do set "archivo_hash=%%a"
) else (
    echo Tipo de hash no válido. Use MD5 o SHA256.
    goto :eof
)

:: Comparar los hashes
if "%archivo_hash%"=="%input_hash%" (
    echo Los hashes coinciden: %archivo_hash% y %input_hash%.
    echo ¿Desea abrir el archivo? s/n
    set /p "accion="
     if /i "%accion:~0,1%"=="s" (
        start "" "%archivo_path%"
    ) else (
        echo No se abrirá el archivo.
    )
) else (
    echo Los hashes no coinciden: %archivo_hash% y %input_hash%.
    echo ¿Desea eliminar el archivo? s/n
    set /p "accion="
    if /i "%accion:~0,1%"=="s" (
        echo Eliminando el archivo...
        del "%archivo_path%"
    ) else (
        echo No se realizará ninguna acción de eliminación.
    )
)

:end
pause
endlocal
