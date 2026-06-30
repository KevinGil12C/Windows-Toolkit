@echo off
:: ============================================================
:: Name:        Restaurar_Menu_Clasico_Win11.bat
:: Description: Restaura el menu contextual clasico de
::              Windows 10 en Windows 11 (quita el paso
::              "Mostrar mas opciones").
:: Author:      Windows-Toolkit
:: Version:     1.0.0
:: Date:        2026-06-29
:: License:     MIT
:: Requirements: Administrador
:: Compatibility: Windows 11
:: ============================================================

net session >nul 2>&1
if %errorLevel% == 0 (
    goto :init
) else (
    echo ============================================================
    echo  ERROR: Se requieren permisos de Administrador.
    echo ============================================================
    echo  Por favor, haz clic derecho sobre este archivo y selecciona
    echo  "Ejecutar como administrador".
    echo.
    pause
    exit /b
)

:init
title Restaurar Menu Contextual Clasico - Windows 11
cls
echo ============================================================
echo   RESTAURADOR DEL MENÚ CONTEXTUAL CLÁSICO (WINDOWS 10)
echo ============================================================
echo.
echo  Este script configurara Windows 11 para que muestre el menu
echo  clasico directamente en el primer clic derecho.
echo.
echo  [1] Activar Menu Clasico (Quitar "Mostrar mas opciones")
echo  [2] Revertir al Menu Original de Windows 11
echo  [3] Salir
echo.
set /p opcionMenu="Selecciona una opcion (1-3): "

if "%opcionMenu%"=="1" goto :activar
if "%opcionMenu%"=="2" goto :revertir
if "%opcionMenu%"=="3" goto :salir
goto :init

:activar
echo.
echo Aplicando cambio en el Registro...
reg add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f /ve >nul
if %errorLevel% == 0 (
    echo [OK] Registro modificado correctamente.
    goto :reiniciar_explorer
) else (
    echo [ERROR] No se pudo modificar el registro.
    pause
    goto :init
)

:revertir
echo.
echo Eliminando modificacion del Registro...
reg delete "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}" /f >nul 2>&1
echo [OK] Registro restaurado al estado original.
goto :reiniciar_explorer

:reiniciar_explorer
echo.
echo Reiniciando el Explorador de Windows para aplicar cambios...
taskkill /f /im explorer.exe >nul
timeout /t 2 /nobreak >nul
start explorer.exe
echo.
echo ============================================================
echo  PROCESO COMPLETADO CON EXITO
echo ============================================================
echo.
pause
goto :init

:salir
exit /b