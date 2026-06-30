@echo off
:: ============================================================
:: Name:        LimpiOffice.bat
:: Description: Escanea y elimina licencias de Office
::              (KMS o residuales) mediante ospp.vbs.
:: Author:      Windows-Toolkit
:: Version:     1.0.0
:: Date:        2026-06-29
:: License:     MIT
:: Requirements: Administrador, Office (ospp.vbs), PowerShell
:: Compatibility: Windows 10, Windows 11 con Office 2010+
:: ============================================================

setlocal enabledelayedexpansion
title Limpiador Universal de Licencias de Office
color 0A

fsutil dirty query %systemdrive% >nul 2>&1
if %errorLevel% neq 0 (
    echo ============================================================
    echo [ERROR] FALTAN PERMISOS DE ADMINISTRADOR
    echo ============================================================
    echo Por favor, haz CLIC DERECHO sobre este archivo y selecciona:
    echo "Ejecutar como Administrador".
    echo.
    goto :pausaFinal
)

echo ============================================================
echo        ESCANER Y LIMPIADOR UNIVERSAL DE OFFICE
echo ============================================================
echo.
echo [PASO 1] Iniciando busqueda dinamica en el sistema...
echo Buscando el archivo 'ospp.vbs' en el disco C...
echo (Esto puede tardar un momento. No cierres la ventana).
echo ------------------------------------------------------------

:: SilentlyContinue evita que cscript se detenga si ospp.vbs no existe
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "$errorActionPreference = 'SilentlyContinue';" ^
    "$vbsFiles = Get-ChildItem -Path 'C:\Program Files', 'C:\Program Files (x86)' -Filter 'ospp.vbs' -Recurse -File;" ^
    "if (-not $vbsFiles) {" ^
    "    Write-Host '[X] ERROR: No se encontro el archivo ospp.vbs en el equipo.';" ^
    "} else {" ^
    "    $vbsPath = $vbsFiles[0].DirectoryName;" ^
    "    Write-Host '[+] Archivo localizado exitosamente';" ^
    "    Write-Host \"    Ruta: $vbsPath\";" ^
    "    Write-Host '------------------------------------------------------------';" ^
    "    cd \"$vbsPath\";" ^
    "    Write-Host '[PASO 2] Consultando el estado de las licencias...';" ^
    "    cscript //H:CScript //NoLogo | Out-Null;" ^
    "    $status = cscript //nologo ospp.vbs /dstatus;" ^
    "    Write-Host '[PASO 3] Analizando claves y buscando residuos piratas o KMS...';" ^
    "    $keys = @();" ^
    "    foreach ($line in $status) {" ^
    "        if ($line -match 'Last 5 characters of installed product key:\s*(\w{5})') {" ^
    "            $keys += $Matches[1];" ^
    "        }" ^
    "    }" ^
    "    if ($keys.Count -eq 0) {" ^
    "        Write-Host '[INFO] No se encontraron claves instaladas. El equipo ya esta limpio.';" ^
    "    } else {" ^
    "        Write-Host \"    Se detectaron $($keys.Count) clave(s). Iniciando remocion...\n\";" ^
    "        foreach ($key in $keys) {" ^
    "            Write-Host \"[PROCESANDO] Eliminando del registro la clave: ****-$key ...\";" ^
    "            $output = cscript //nologo ospp.vbs /unpkey:$key;" ^
    "            Write-Host \"[OK] Clave $key desinstalada correctamente.\";" ^
    "            Write-Host '------------------------------------------------------------';" ^
    "        }" ^
    "        Write-Host ' ';" ^
    "        Write-Host '[PASO 4] Verificando el estado final...';" ^
    "        Write-Host '============================================================';" ^
    "        Write-Host 'ESTADO ACTUAL DE LICENCIAS EN EL EQUIPO:';" ^
    "        Write-Host '============================================================';" ^
    "        $finalStatus = cscript //nologo ospp.vbs /dstatus;" ^
    "        foreach ($fLine in $finalStatus) {" ^
    "            if ($fLine -match 'No installed product keys detected') {" ^
    "                Write-Host '    -> [SISTEMA LIMPIO] No se detectaron llaves instaladas.';" ^
    "            } else {" ^
    "                Write-Host \"    $fLine\";" ^
    "            }" ^
    "        }" ^
    "    }" ^
    "}"

echo.
echo ============================================================
echo [FIN] El proceso ha terminado por completo.
echo ============================================================
echo.

:pausaFinal
echo Presiona cualquier tecla para cerrar esta ventana de forma segura...
pause >nul
exit /b