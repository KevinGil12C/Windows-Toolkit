@echo off
:: ============================================================
:: Name:        Launcher.bat
:: Description: Lanzador principal de Windows-Toolkit.
::              Detecta automaticamente las herramientas en
::              Tools/ y genera el menu de forma dinamica.
:: Author:      Windows-Toolkit
:: Version:     1.0.0
:: Date:        2026-06-29
:: License:     MIT
:: Requirements: Ninguno
:: Compatibility: Windows 10, Windows 11
:: ============================================================

title Windows Toolkit
setlocal enabledelayedexpansion
cd /d "%~dp0"

set "TOOLS_DIR=%~dp0Tools"
set COUNT=0

:: Escanear Tools/ en busca de .bat y .ps1
for %%f in ("%TOOLS_DIR%\*.bat" "%TOOLS_DIR%\*.ps1") do (
    set /a COUNT+=1
    set "FILE[!COUNT!]=%%~nxf"
    set "FULL[!COUNT!]=%%f"
    set "EXT[!COUNT!]=%%~xf"
)

:menu
cls
echo ============================================================
echo                    WINDOWS TOOLKIT
echo ============================================================
echo.
echo  Repositorio de herramientas para Windows
echo.
echo ------------------- HERRAMIENTAS -----------------------
echo.

if %COUNT% equ 0 (
    echo  No se encontraron herramientas en la carpeta Tools.
    echo.
    pause
    exit /b
)

for /l %%i in (1,1,%COUNT%) do (
    set "display=!FILE[%%i]!"
    set "display=!display:_= !"
    set "display=!display:.bat=!"
    set "display=!display:.ps1=!"
    if %%i lss 10 echo      [%%i] !display!
    if %%i geq 10 echo     [%%i] !display!
)

echo.
echo -------------------------------------------------------
echo.
echo      [0] Salir
echo.
set /p "opt=Seleccione una opcion (0-%COUNT%): "

if "%opt%"=="0" exit /b

:: Validar que sea numero
set "isnum=1"
for /f "delims=0123456789" %%a in ("%opt%") do set "isnum=0"
if "%isnum%"=="0" goto :menu
if %opt% gtr %COUNT% goto :menu
if %opt% lss 1 goto :menu

cls
echo ============================================================
echo  Ejecutando: !FILE[%opt%]!
echo ============================================================
echo.

if /i "!EXT[%opt%]!"==".ps1" (
    powershell -NoProfile -ExecutionPolicy Bypass -File "!FULL[%opt%]!"
) else (
    call "!FULL[%opt%]!"
)

echo.
echo ============================================================
echo  Operacion finalizada. Presione una tecla para continuar...
echo ============================================================
pause >nul
goto :menu
