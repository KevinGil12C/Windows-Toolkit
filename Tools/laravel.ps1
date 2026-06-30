# ====================================================================
# Name:        laravel.ps1
# Description: Panel de control global para proyectos Laravel
#              multi-ruta. Escanea, selecciona y ejecuta comandos
#              Artisan (migrate, serve, cache, etc.).
# Author:      Windows-Toolkit
# Version:     1.0.0
# Date:        2026-06-29
# License:     MIT
# Requirements: XAMPP (PHP en C:\xampp\php\php.exe), Laravel
# Compatibility: Windows 10, Windows 11
# ====================================================================
$OutputEncoding = [System.Text.Encoding]::UTF8

# CONFIGURACION DE RUTAS
$rutasRepositorios = @("C:\xampp\htdocs", "C:\Scripts")
$phpBinario = "C:\xampp\php\php.exe"

if (-not (Test-Path $phpBinario)) {
    Write-Host "[X] ERROR: No se encontro PHP en '$phpBinario'" -ForegroundColor Red
    Write-Host "Por favor, verifica la instalacion de XAMPP." -ForegroundColor Yellow
    Pause
    Exit
}

function Buscar-Y-Menu {
    $directorioActual = (Get-Location).Path
    
    if (Test-Path (Join-Path $directorioActual "artisan")) {
        $proyectoContexto = Get-Item $directorioActual
        Mostrar-Menu-Comandos $proyectoContexto
    } else {
        Mostrar-Menu-Proyectos
    }
}

function Mostrar-Menu-Proyectos {
    Clear-Host
    Write-Host "===================================================================="
    Write-Host "             GESTOR DE PROYECTOS LARAVEL (MULTI-RUTA)"
    Write-Host "===================================================================="
    Write-Host ""
    Write-Host "No estas en un proyecto Laravel. Escaneando directorios de trabajo..."
    Write-Host ""

    $global:proyectos = @()
    foreach ($ruta in $rutasRepositorios) {
        if (Test-Path $ruta) {
            $proyectosEncontrados = Get-ChildItem -Path $ruta -Directory | Where-Object { Test-Path (Join-Path $_.FullName "artisan") }
            if ($proyectosEncontrados) { $global:proyectos += $proyectosEncontrados }
        }
    }

    if ($proyectos.Count -eq 0) {
        Write-Host "[!] No se encontraron proyectos Laravel en tus carpetas de trabajo." -ForegroundColor Yellow
        Pause
        Exit
    }

    $i = 1
    foreach ($repo in $proyectos) {
        Write-Host "  [$i] $($repo.Name)  (..\$($repo.Parent.Name))"
        $i++
    }

    Write-Host ""
    $opcion = Read-Host "Selecciona el numero de tu proyecto (o 'q' para salir)"

    if ($opcion -eq 'q' -or $opcion -eq 'Q') { Exit }

    if ($opcion -match '^\d+$' -and $opcion -ge 1 -and $opcion -le $proyectos.Count) {
        $proyectoSeleccionado = $proyectos[$opcion - 1]
        Set-Location $proyectoSeleccionado.FullName
        Mostrar-Menu-Comandos $proyectoSeleccionado
    } else {
        Write-Host "[X] Opcion no valida." -ForegroundColor Red
        Start-Sleep -Seconds 1
        Mostrar-Menu-Proyectos
    }
}

function Mostrar-Menu-Comandos($proyecto) {
    do {
        Clear-Host
        Write-Host "===================================================================="
        Write-Host "  PROYECTO DETECTADO: $($proyecto.Name)"
        Write-Host "  Ruta: $($proyecto.FullName)"
        Write-Host "  PHP Binario: $phpBinario"
        Write-Host "===================================================================="
        Write-Host ""
        Write-Host "  [1] Levantar Servidor Local (php artisan serve)"
        Write-Host "  [2] Ejecutar Migraciones (migrate)"
        Write-Host "  [3] Ejecutar Migraciones con Seeders (migrate --seed)"
        Write-Host "  [4] Revertir ultima migracion (migrate:rollback)"
        Write-Host "  [5] OPTIMIZACION TOTAL (Limpiar y Resetear Caches)"
        Write-Host "  [6] Entrar a la Consola Interactiva (tinker)"
        Write-Host "  [7] Ver Rutas Registradas (route:list)"
        Write-Host "  [8] Ir a la Lista Global de Proyectos"
        Write-Host "  [9] Salir"
        Write-Host ""
        Write-Host "===================================================================="
        
        $opcionComando = Read-Host "Selecciona una accion (1-9)"

        switch ($opcionComando) {
            "1" {
                Write-Host "`n[-] Iniciando servidor... Abre http://127.0.0.1:8000" -ForegroundColor Cyan
                Write-Host "[-] Presiona Ctrl+C para detenerlo.`n" -ForegroundColor Cyan
                & $phpBinario artisan serve
                Pause
            }
            "2" {
                Write-Host ""
                & $phpBinario artisan migrate
                Pause
            }
            "3" {
                Write-Host ""
                & $phpBinario artisan migrate --seed
                Pause
            }
            "4" {
                Write-Host ""
                & $phpBinario artisan migrate:rollback
                Pause
            }
            "5" {
                Write-Host "`n============================================================"
                Write-Host "       EJECUTANDO OPTIMIZACION Y LIMPIEZA TOTAL"
                Write-Host "============================================================`n"
                Write-Host "[-] 1/5 Limpiando cache de la aplicacion..."
                & $phpBinario artisan cache:clear
                Write-Host "[-] 2/5 Optimizando configuracion..."
                & $phpBinario artisan config:cache
                Write-Host "[-] 3/5 Limpiando mapa de rutas (Evita errores de duplicados)..."
                & $phpBinario artisan route:clear
                Write-Host "[-] 4/5 Limpiando y pre-compilando vistas (Blade/Twig)..."
                & $phpBinario artisan view:cache
                Write-Host "[-] 5/5 Optimizando la carga de clases..."
                & $phpBinario artisan optimize
                Write-Host "`n[OK] Proyecto listo y optimizado usando el PHP de XAMPP.`n" -ForegroundColor Green
                Pause
            }
            "6" {
                Write-Host ""
                & $phpBinario artisan tinker
            }
            "7" {
                Write-Host ""
                & $phpBinario artisan route:list
                Pause
            }
            "8" { 
                Mostrar-Menu-Proyectos 
                return 
            }
            "9" { Exit }
            Default {
                Write-Host "[X] Opcion no valida." -ForegroundColor Red
                Start-Sleep -Seconds 1
            }
        }
    } while ($true)
}

# Ejecutar el analisis inicial al arrancar
Buscar-Y-Menu