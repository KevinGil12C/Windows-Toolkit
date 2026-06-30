@echo off
:: ============================================================
:: Name:        Desactivar_Defender.bat
:: Description: Desactiva o reactiva la proteccion en tiempo
::              real de Windows Defender mediante PowerShell.
:: Author:      Windows-Toolkit
:: Version:     1.0.0
:: Date:        2026-06-29
:: License:     MIT
:: Requirements: Administrador, PowerShell
:: Compatibility: Windows 10, Windows 11
:: ============================================================

net session >nul 2>&1
if %errorLevel% neq 0 (
    echo ============================================================
    echo  ERROR: Se requieren permisos de Administrador.
    echo ============================================================
    echo  Por favor, haz clic derecho y selecciona "Ejecutar como administrador".
    echo.
    pause
    exit /b
)

title Desactivar Windows Defender via PowerShell

:menu
cls
echo ============================================================
echo      DESACTIVADOR DE WINDOWS DEFENDER (METODO POWERSHELL)
echo ============================================================
echo.
echo  [1] Desactivar Monitoreo en Tiempo Real
echo  [2] Volver a Activar Monitoreo
echo  [3] Salir
echo.
set /p opcionMenu="Selecciona una opcion (1-3): "

if "%opcionMenu%"=="1" goto :desactivar
if "%opcionMenu%"=="2" goto :activar
if "%opcionMenu%"=="3" goto :salir
goto :menu

:desactivar
echo.
echo Deshabilitando proteccion en tiempo real...
:: Cada flag se desactiva individualmente porque Set-MpPreference no
:: acepta combinaciones. La proteccion contra alteraciones (tamper
:: protection) puede re-activar estas opciones en el proximo reinicio.
powershell -Command "Set-MpPreference -DisableRealtimeMonitoring $true"
powershell -Command "Set-MpPreference -DisableBehaviorMonitoring $true"
powershell -Command "Set-MpPreference -DisableBlockAtFirstSeen $true"
powershell -Command "Set-MpPreference -DisableIOAVProtection $true"
powershell -Command "Set-MpPreference -DisablePrivacyMode $true"
powershell -Command "Set-MpPreference -SignatureDisableUpdateOnStartupWithoutEngine $true"
echo.
echo [OK] Comandos de deshabilitacion enviados.
echo Nota: Si la proteccion contra alteraciones sigue encendida, 
echo Windows podria ignorar estos comandos en el proximo reinicio.
echo.
pause
exit /b

:activar
echo.
echo Volviendo a habilitar Windows Defender...
powershell -Command "Set-MpPreference -DisableRealtimeMonitoring $false"
powershell -Command "Set-MpPreference -DisableBehaviorMonitoring $false"
echo [OK] Reactivado.
pause
exit /b

:salir
exit /b