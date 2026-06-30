@echo off
:: ============================================================
:: Name:        alias_linux.bat
:: Description: Emulador de comandos Linux en cmd.exe mediante
::              macros DOSKEY (ls, cat, rm, mv, cp, grep, etc.).
:: Author:      Windows-Toolkit
:: Version:     1.0.0
:: Date:        2026-06-29
:: License:     MIT
:: Requirements: Ninguno
:: Compatibility: Windows 10, Windows 11
:: ============================================================

DOSKEY ls=dir /B $*
DOSKEY ll=dir /N $*
DOSKEY cat=type $*
DOSKEY clear=cls
DOSKEY pwd=cd

DOSKEY touch=copy nul $* > nul
DOSKEY rm=del /S $*
DOSKEY rmdir=rd /S /Q $*
DOSKEY mv=move $*
DOSKEY cp=copy $*
DOSKEY mkdir=md $*

DOSKEY grep=findstr $*
DOSKEY ifconfig=ipconfig

:: call :show_help en vez de un macro inline porque cmd.exe
:: tiene limite de caracteres por linea en DOSKEY
DOSKEY linux-help=cls ^& call :show_help

goto :eof

:show_help
echo.
echo  COMANDOS LINUX DISPONIBLES:
echo  ==================================
echo  ls      : Listar (corto)
echo  ll      : Listar (detalle)
echo  cat     : Ver contenido
echo  touch   : Crear archivo
echo  rm      : Borrar
echo  mv      : Mover/Renombrar
echo  cp      : Copiar
echo  grep    : Buscar texto
echo  clear   : Limpiar pantalla
echo  pwd     : Ruta actual
echo.
goto :eof