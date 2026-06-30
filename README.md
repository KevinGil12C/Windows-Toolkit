<div align="center">

# ⚡ Windows Toolkit

**Colección profesional de utilidades portables para administradores de sistemas Windows y usuarios avanzados**

[![Version](https://img.shields.io/badge/version-1.1.0-blue.svg)]()
[![Windows](https://img.shields.io/badge/Windows-10%20%7C%2011-00a4ef.svg)]()
[![PowerShell](https://img.shields.io/badge/PowerShell-5.1%2B-5391FE.svg)]()
[![License](https://img.shields.io/badge/license-MIT-green.svg)]()

---

</div>

## 📋 Descripción General

Windows Toolkit es una colección seleccionada de scripts portables y sin dependencias, diseñados para optimizar la administración de Windows. Cada herramienta sigue una filosofía **simple, segura y documentada** — sin bloat, sin comportamiento oculto, sin ambigüedades.

| Categoría | Herramientas | Requiere Admin |
|:----------|:------------:|:--------------:|
| Seguridad | 1 | ✅ |
| Sistema | 2 | ✅ |
| Desarrollo | 3 | ❌ |
| Utilidades CLI | 1 | ❌ |

---

## 🧰 Herramientas

| # | Herramienta | Descripción | Ejecución |
|:-:|:------------|:------------|:---------:|
| 1 | **Desactivar Defender** | Activa/desactiva la protección en tiempo real de Windows Defender vía PowerShell | Administrador |
| 2 | **Limpiador Office** | Escanea y elimina claves de producto de Office (KMS o residuales) | Administrador |
| 3 | **Menú Clásico Win11** | Restaura el menú contextual de Windows 10 en Windows 11 | Administrador |
| 4 | **Gestor de Entornos** | Detecta y cierra entornos WAMP/XAMPP en ejecución | Administrador |
| 5 | **Panel Git** | Panel Git interactivo: commit, push, ramas, reparar credenciales | Usuario |
| 6 | **Panel Laravel** | Gestor multi-ruta de proyectos Laravel con comandos Artisan | Usuario |
| 7 | **Alias Linux** | Comandos estilo Unix para cmd.exe (ls, cat, rm, grep) | Usuario |

---

### 🔒 1. Desactivar Defender (`Desactivar_Defender.bat`)

Activa o desactiva la protección en tiempo real de Windows Defender, incluyendo monitoreo de comportamiento, protección IOAV y más.

```
[1] Desactivar Monitoreo en Tiempo Real
[2] Volver a Activar Monitoreo
[3] Salir
```

**Requisitos:** Administrador · PowerShell  
**Compatibilidad:** Windows 10, Windows 11  
**⚠ Advertencia:** Reduce la seguridad del sistema. La protección contra alteraciones puede ignorar los cambios.

---

### 🧹 2. Limpiador Office (`LimpiOffice.bat`)

Localiza `ospp.vbs`, audita las claves de producto de Office instaladas y elimina las licencias detectadas — activaciones KMS, restos de trials o entradas residuales.

```
[PASO 1] Buscando ospp.vbs...
[PASO 2] Consultando estado de licencias...
[PASO 3] Eliminando claves detectadas...
[PASO 4] Verificación final...
```

**Requisitos:** Administrador · Microsoft Office (ospp.vbs) · PowerShell  
**Compatibilidad:** Windows 10, Windows 11 + Office 2010+  
**⚠ Advertencia:** Elimina **todas** las licencias de Office, incluyendo las legítimas. Irreversible.

---

### 🖱️ 3. Menú Clásico Win11 (`Restaurar_Menu_Clasico_Win11.bat`)

Elimina el paso intermedio "Mostrar más opciones" restaurando el menú contextual de Windows 10 directamente.

```
[1] Activar Menú Clásico
[2] Revertir al Menú Original de Windows 11
[3] Salir
```

**Requisitos:** Administrador  
**Compatibilidad:** Solo Windows 11  
**⚠ Advertencia:** Modifica el registro (HKCU). Reinicia el Explorador.

---

### 🖥️ 4. Gestor de Entornos (`entorno.ps1`)

Detecta procesos de WampServer o XAMPP en ejecución y detiene sus servicios (Apache, MySQL, MariaDB) de forma controlada.

```
[!] Se detectó WampServer. ¿Cerrar? (s/n)
[-] Deteniendo servicios de WAMP...
[-] Matando procesos...
[OK] WampServer cerrado por completo.
```

**Requisitos:** Administrador · PowerShell  
**Compatibilidad:** Windows 10, Windows 11  
**⚠ Advertencia:** Los servicios deben reiniciarse manualmente después.

---

### 🔄 5. Panel Git (`gitup.bat`)

Panel Git completo. Funciona en cualquier repositorio Git o inicializa uno nuevo.

| Opción | Acción |
|:------:|:-------|
| 1 | Commit y Push |
| 2 | Sincronizar (Pull --rebase) |
| 3 | Crear Rama |
| 4 | Cambiar Rama |
| 5 | Eliminar Rama |
| 6 | Reset Completo (nuevo repo) |
| 7 | Reparar Credenciales (fix 403) |
| 8 | Salir |

Soporta configuración vía `.env`:
```env
GIT_USER=TuUsuarioGitHub
GIT_EMAIL=tu@email.com
```

**Requisitos:** Git · PowerShell (para reparar credenciales)  
**Compatibilidad:** Windows 10, Windows 11  
**⚠ Advertencia:** Operaciones destructivas (eliminar rama, hard reset) se ejecutan sin confirmación adicional.

---

### ⚙️ 6. Panel Laravel (`laravel.ps1`)

Escanea directorios configurados en busca de proyectos Laravel (que contengan `artisan`) y presenta un menú de comandos.

```
PROYECTO: my-app
[1] php artisan serve
[2] migrate
[3] migrate --seed
[4] migrate:rollback
[5] Optimización total (cache, config, rutas, vistas, clases)
[6] tinker
[7] route:list
[8] Volver a lista de proyectos
[9] Salir
```

Rutas escaneadas: `C:\xampp\htdocs`, `C:\Scripts`

**Requisitos:** XAMPP (PHP en `C:\xampp\php\php.exe`) · Proyecto Laravel  
**Compatibilidad:** Windows 10, Windows 11  
**⚠ Advertencia:** Las migraciones modifican la base de datos. La ruta de PHP está hardcodeada.

---

### 🐧 7. Alias Linux (`alias_linux.bat`)

Registra macros DOSKEY para usar comandos estilo Unix en cmd.exe.

| Alias | Equivale a | Alias | Equivale a |
|:------|:-----------|:------|:-----------|
| `ls` | `dir /B` | `clear` | `cls` |
| `ll` | `dir /N` | `pwd` | `cd` |
| `cat` | `type` | `rm` | `del /S` |
| `touch` | `copy nul` | `mv` | `move` |
| `cp` | `copy` | `grep` | `findstr` |
| `mkdir` | `md` | `ifconfig` | `ipconfig` |
| `rmdir` | `rd /S /Q` | `linux-help` | muestra todos los alias |

**Requisitos:** Ninguno  
**Compatibilidad:** Windows 10, Windows 11  
**⚠ Nota:** Los alias solo viven en la sesión actual de cmd.

---

## 💻 Requisitos del Sistema

| Dependencia | Notas |
|:------------|:------|
| **Windows 10** u **Windows 11** | Todas las herramientas probadas en ambos |
| **Privilegios de Administrador** | Herramientas 1–4 requieren elevación |
| **PowerShell 5.1+** | Requerido en herramientas 1, 2, 4, 6; opcional en 5 |
| **Git** | Requerido solo para herramienta 5 (Panel Git) |
| **XAMPP / PHP** | Requerido solo para herramienta 6 (Panel Laravel) |

---

## 🚀 Cómo Empezar

```batch
git clone https://github.com/KevinGil12C/Windows-Toolkit.git
cd Windows-Toolkit
Launcher.bat
```

No requiere instalación. Todo es portable — funciona desde USB, unidad de red o disco local.

> **Consejo:** Ancla `Launcher.bat` a la barra de tareas para acceso con un clic.

---

## 📁 Estructura del Proyecto

```
Windows-Toolkit/
│
├── Launcher.bat             # Lanzador con detección automática (cero mantenimiento)
├── README.md
├── CHANGELOG.md
├── LICENSE
│
├── Tools/
│   ├── Desactivar_Defender.bat
│   ├── LimpiOffice.bat
│   ├── Restaurar_Menu_Clasico_Win11.bat
│   ├── entorno.ps1
│   ├── gitup.bat
│   ├── laravel.ps1
│   └── alias_linux.bat
│
├── Docs/                    # Documentación extendida
└── Assets/                  # Recursos visuales
```

### Launcher — Auto-Detección

El lanzador escanea `Tools/` en busca de archivos `.bat` y `.ps1` al iniciar y construye el menú dinámicamente. **Agregar una nueva herramienta no requiere modificar el lanzador** — solo coloca el archivo en `Tools/`.

---

## 📄 Licencia

Distribuido bajo **Licencia MIT**. Consulta `LICENSE` para más detalles.

---

<div align="center">

**Windows Toolkit** — *Creado por y para profesionales de TI.*

</div>
