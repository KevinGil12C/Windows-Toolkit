# ====================================================================
# Name:        entorno.ps1
# Description: Detecta y cierra entornos de desarrollo local
#              (WAMP / XAMPP) en ejecucion.
# Author:      Windows-Toolkit
# Version:     1.0.0
# Date:        2026-06-29
# License:     MIT
# Requirements: Administrador, PowerShell
# Compatibility: Windows 10, Windows 11
# ====================================================================
# UTF-8 evita caracteres corruptos al mostrar acentos y eñes en consola
$OutputEncoding = [System.Text.Encoding]::UTF8

# Auto-elevacion: si no es administrador, se relanza a si mismo con privilegios
$esAdministrador = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $esAdministrador) {
    Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -NoExit -Command `"Invoke-Expression (Get-Content 'C:\Scripts\entorno.ps1' -Raw)`"" -Verb RunAs
    Exit
}

Clear-Host
Write-Host "============================================================"
Write-Host "          DETECTOR INTELIGENTE DE ENTORNOS LOCALES"
Write-Host "============================================================"
Write-Host ""

$wampActivo = (Get-Process | Where-Object { $_.Name -like "wampmanager*" }) -ne $null
$xamppActivo = (Get-Process | Where-Object { $_.Name -eq "xampp-control" }) -ne $null
$apacheActivo = (Get-Process | Where-Object { $_.Name -eq "httpd" }) -ne $null

$entornoDetectado = $false

if ($wampActivo) {
    Write-Host "[!] Se detecto que WampServer esta ABIERTO." -ForegroundColor Yellow
    $entornoDetectado = $true
    $confirmacionCierre = Read-Host "Quieres cerrar WAMP y todos sus servicios? (s/n)"
    if ($confirmacionCierre -eq 's' -or $confirmacionCierre -eq 'S') {
        Write-Host "`n[-] Deteniendo servicios de WAMP..." -ForegroundColor Cyan
        Stop-Service -Name "wampapache64" -ErrorAction SilentlyContinue
        Stop-Service -Name "wampmysqld64" -ErrorAction SilentlyContinue
        Stop-Service -Name "wampmariadb64" -ErrorAction SilentlyContinue
        Stop-Service -Name "wampapache" -ErrorAction SilentlyContinue
        Stop-Service -Name "wampmysqld" -ErrorAction SilentlyContinue
        Stop-Service -Name "wampmariadb" -ErrorAction SilentlyContinue
        
        Write-Host "[-] Matando procesos de WAMP..." -ForegroundColor Cyan
        Get-Process | Where-Object { $_.Name -like "wampmanager*" } | Stop-Process -Force -ErrorAction SilentlyContinue
        Get-Process | Where-Object { $_.Name -eq "httpd" } | Stop-Process -Force -ErrorAction SilentlyContinue
        Get-Process | Where-Object { $_.Name -eq "mysqld" } | Stop-Process -Force -ErrorAction SilentlyContinue
        Get-Process | Where-Object { $_.Name -eq "mariadbd" } | Stop-Process -Force -ErrorAction SilentlyContinue
        Write-Host "[OK] WampServer cerrado por completo.`n" -ForegroundColor Green
    }
}

if ($xamppActivo -or (-not $wampActivo -and $apacheActivo)) {
    Write-Host "[!] Se detecto que XAMPP esta ACTIVO o tiene servicios corriendo." -ForegroundColor Yellow
    $entornoDetectado = $true
    $confirmacionCierre = Read-Host "Quieres cerrar XAMPP y todos sus servicios? (s/n)"
    if ($confirmacionCierre -eq 's' -or $confirmacionCierre -eq 'S') {
        Write-Host "`n[-] Deteniendo servicios de XAMPP..." -ForegroundColor Cyan
        Stop-Service -Name "xamppapache" -ErrorAction SilentlyContinue
        Stop-Service -Name "xamppmysql" -ErrorAction SilentlyContinue
        Stop-Service -Name "apache2.4" -ErrorAction SilentlyContinue
        Stop-Service -Name "mysql" -ErrorAction SilentlyContinue
        
        Write-Host "[-] Matando procesos de XAMPP..." -ForegroundColor Cyan
        Get-Process | Where-Object { $_.Name -eq "xampp-control" } | Stop-Process -Force -ErrorAction SilentlyContinue
        Get-Process | Where-Object { $_.Name -eq "httpd" } | Stop-Process -Force -ErrorAction SilentlyContinue
        Get-Process | Where-Object { $_.Name -eq "mysqld" } | Stop-Process -Force -ErrorAction SilentlyContinue
        Write-Host "[OK] XAMPP cerrado por completo.`n" -ForegroundColor Green
    }
}

if (-not $entornoDetectado) {
    Write-Host "[OK] No se detecto ningun proceso activo de WAMP o XAMPP en memoria." -ForegroundColor Green
}

Write-Host "============================================================"
Write-Host "Proceso finalizado. Ya puedes cerrar esta ventana o presionar ENTER."
Read-Host