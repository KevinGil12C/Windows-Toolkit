@echo off
:: ============================================================
:: Name:        gitup.bat
:: Description: Panel de control Git con menu interactivo
::              (commit, push, pull, ramas, reparar credenciales).
:: Author:      Windows-Toolkit
:: Version:     1.0.0
:: Date:        2026-06-29
:: License:     MIT
:: Requirements: Git, PowerShell (para reparar credenciales)
:: Compatibility: Windows 10, Windows 11
:: ============================================================

setlocal enabledelayedexpansion
title VORTEX Git Dashboard - @KevinGil12C

:: --- CARGAR CONFIGURACIÓN DESDE .ENV ---
if exist ".env" (
    for /f "usebackq tokens=1,2 delims==" %%a in (".env") do (
        if "%%a"=="GIT_USER" set "NEW_USER=%%b"
        if "%%a"=="GIT_EMAIL" set "NEW_EMAIL=%%b"
    )
) else (
    set "NEW_USER=KevinGil12C"
    set "NEW_EMAIL=kekg150@gmail.com"
)

:: --- ENRUTADOR DE ARGUMENTOS ---
if "%1"=="/fix"   goto :fix_identity
if "%1"=="/reset" goto :hard_reset

:main_dashboard
cls
echo ======================================================
echo           VORTEX GIT DASHBOARD - @%NEW_USER%
echo ======================================================

if not exist ".git" (
    echo [!] No se detecto un repositorio Git.
    echo [1] Inicializar nuevo repo  [2] Salir
    set /p opcionInicial="Seleccion: "
    if "!opcionInicial!"=="1" goto :hard_reset
    exit /b
)

for /f "tokens=*" %%a in ('git remote get-url origin 2^>nul') do set "urlRemoto=%%a"
for /f "tokens=*" %%b in ('git branch --show-current') do set "ramaActual=%%b"
for /f "tokens=*" %%c in ('git log -1 --format^="%%cr (%%s)" 2^>nul') do set "ultimoCommit=%%c"

echo [i] PROYECTO: %CD%
echo [i] REMOTO:   !urlRemoto!
echo [i] RAMA ACTIVA: [!ramaActual!]
echo [i] ULTIMO COMMIT: !ultimoCommit!
echo ------------------------------------------------------
echo [ RAMAS DETECTADAS ]
git fetch origin --quiet 2>nul
for /f "tokens=*" %%i in ('git branch --format^="  L: %%(refname:short)"') do echo %%i
for /f "tokens=*" %%j in ('git branch -r --format^="%%(refname:short)" ^| findstr /v /c:"HEAD" /c:"origin$"') do (
    set "rbranch=%%j"
    set "rbranch=!rbranch:origin/=!"
    echo    R: !rbranch!
)
echo ------------------------------------------------------
git status -s
echo ------------------------------------------------------
echo OPCIONES:
echo [1] COMMIT Y PUSH           [5] ELIMINAR RAMA
echo [2] SYNC (PULL)             [6] RESET (Cambiar cuenta/Repo)
echo [3] NUEVA RAMA              [7] REPARAR CREDENCIALES (Fix 403)
echo [4] CAMBIAR RAMA (Switch)   [8] SALIR
echo.
set /p opcionAccion="Selecciona una accion: "

if "%opcionAccion%"=="1" goto :deploy_flow
if "%opcionAccion%"=="2" goto :sync_cloud
if "%opcionAccion%"=="3" goto :create_branch
if "%opcionAccion%"=="4" goto :switch_branch
if "%opcionAccion%"=="5" goto :delete_branch
if "%opcionAccion%"=="6" goto :hard_reset
if "%opcionAccion%"=="7" goto :fix_identity
if "%opcionAccion%"=="8" exit /b
goto :main_dashboard

:deploy_flow
echo.
git add .
set /p mensajeCommit="Mensaje del commit: "
if "!mensajeCommit!"=="" set "mensajeCommit=Update via Vortex - %date%"
git commit -m "!mensajeCommit!"
echo [!] Empujando a GitHub...
git push -u origin !ramaActual!
if %errorlevel% neq 0 echo [ERROR] Fallo el Push. Usa la opcion 7.
pause
goto :main_dashboard

:fix_identity
echo.
echo [!] REPARANDO CREDENCIALES PARA @%NEW_USER%...
git config --global user.name "%NEW_USER%"
git config --global user.email "%NEW_EMAIL%"
:: GitHub 403 ocurre cuando Windows guarda credenciales antiguas en
:: el Administrador de Credenciales. cmdkey las elimina para forzar
:: una autenticacion limpia con el gestor moderno de Git.
powershell -Command "cmdkey /list | Select-String 'git:https://github.com' | ForEach-Object { $target = $_.ToString().Split('=')[1].Trim(); cmdkey /delete:$target; Write-Host \"Eliminado: $target\" -ForegroundColor Yellow }"
git config --global credential.helper manager
echo [OK] Credenciales limpias e identidad configurada.
pause
goto :main_dashboard

:sync_cloud
git pull --rebase origin !ramaActual!
pause
goto :main_dashboard

:create_branch
set /p nombreRama="Nombre nueva rama: "
if "!nombreRama!"=="" goto :main_dashboard
git checkout -b !nombreRama!
git push -u origin !nombreRama!
pause
goto :main_dashboard

:switch_branch
set /p nombreRama="Rama destino: "
if "!nombreRama!"=="" goto :main_dashboard
git checkout !nombreRama!
pause
goto :main_dashboard

:delete_branch
set /p nombreRama="Rama a borrar: "
if "!nombreRama!"=="" goto :main_dashboard
git branch -D !nombreRama!
git push origin --delete !nombreRama!
pause
goto :main_dashboard

:hard_reset
rd /s /q .git 2>nul
git init
git branch -M main
set /p urlRepositorio="URL del repo: "
git remote add origin !urlRepositorio!
git config user.name "%NEW_USER%"
git config user.email "%NEW_EMAIL%"
pause
goto :main_dashboard