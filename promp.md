# AGENTS.md

# Windows-Toolkit - Development Instructions

## Objetivo

Eres el mantenedor principal de este repositorio.

Tu misión es mantener **Windows-Toolkit** como una colección profesional de herramientas para Windows, garantizando que el código, la documentación y el launcher permanezcan sincronizados automáticamente conforme se agregan nuevas utilidades.

---

# Filosofía del proyecto

Cada herramienta debe cumplir con estos principios:

* Simple
* Segura
* Reutilizable
* Fácil de entender
* Fácil de mantener
* Compatible con Windows modernos
* Documentada

No se aceptan scripts sin documentación.

---

# Estructura esperada

```text
Windows-Toolkit/
│
├── Launcher.bat
├── README.md
├── CHANGELOG.md
├── LICENSE
│
├── Tools/
│
├── Docs/
│
└── Assets/
```

---

# Cuando aparezca un nuevo archivo dentro de Tools/

Realiza automáticamente las siguientes tareas.

## 1. Analizar el script

Determina:

* Propósito
* Funcionamiento
* Compatibilidad
* Dependencias
* Riesgos
* Requisitos
* Permisos necesarios
* Si modifica el Registro
* Si reinicia Explorer
* Si requiere Internet
* Si necesita PowerShell
* Si necesita privilegios elevados

Nunca inventes información.

---

## 2. Actualizar el Launcher

Registrar automáticamente la nueva herramienta.

Debe:

* Agregar una nueva opción.
* Mantener la numeración.
* Mantener el estilo visual.
* Ejecutar BAT o PS1 según corresponda.
* Detectar errores.
* Volver al menú principal al finalizar.
* No romper herramientas existentes.

Si existe una mejor arquitectura para el Launcher, proponla e impleméntala si mantiene compatibilidad.

---

## 3. Actualizar README

Agregar automáticamente la nueva herramienta.

Cada herramienta debe incluir:

* Descripción
* Características
* Requisitos
* Compatibilidad
* Uso
* Advertencias
* Ejemplo
* Autor
* Fecha

Mantener una tabla resumen.

---

## 4. Actualizar CHANGELOG

Seguir Semantic Versioning.

Registrar:

* Nuevas herramientas
* Mejoras
* Correcciones
* Refactorizaciones

---

## 5. Documentar el código

Agregar comentarios cuando sean necesarios.

Documentar:

* Variables
* Funciones
* Bloques importantes
* Validaciones
* Errores

No comentar código obvio.

---

## 6. Mejorar calidad

Buscar automáticamente:

* Código duplicado
* Variables innecesarias
* Código muerto
* Riesgos
* Problemas de seguridad
* Compatibilidad

Aplicar mejoras únicamente cuando no cambien el funcionamiento.

---

## 7. Mantener consistencia

Todos los scripts deben incluir un encabezado como:

* Nombre
* Descripción
* Autor
* Versión
* Fecha
* Licencia
* Requisitos
* Compatibilidad

---

## 8. Launcher

El Launcher debe ser el punto central del proyecto.

Siempre debe:

* Detectar automáticamente nuevas herramientas.
* Mostrar nombres amigables.
* Poder crecer sin modificar grandes bloques de código.
* Tener una interfaz limpia.
* Manejar errores correctamente.

Si es posible, evitar agregar nuevas opciones manualmente. Prefiere una generación automática del menú.

---

## 9. Documentación

Mantener actualizados:

* README.md
* CHANGELOG.md
* Docs/
* Comentarios del código

La documentación debe ser suficiente para que cualquier persona pueda utilizar el proyecto sin ayuda.

---

## 10. Calidad del código

Priorizar siempre:

* Legibilidad
* Modularidad
* Compatibilidad
* Seguridad
* Mantenimiento
* Escalabilidad

---

## 11. Estilo

Utilizar:

* Inglés para nombres de archivos.
* Inglés para variables.
* Español o inglés en documentación según el archivo existente, manteniendo consistencia.
* Comentarios claros y concisos.

---

## 12. Antes de finalizar cualquier cambio

Verificar:

* El proyecto compila o ejecuta correctamente.
* El Launcher funciona.
* README actualizado.
* CHANGELOG actualizado.
* No existen enlaces rotos.
* No existen opciones duplicadas.
* No se rompió compatibilidad.

---

# Objetivo final

Mantener Windows-Toolkit como un repositorio de referencia para administradores de sistemas, personal de soporte técnico y usuarios avanzados, con herramientas de alta calidad, documentación completa y un launcher centralizado que evolucione automáticamente conforme crece el proyecto.
