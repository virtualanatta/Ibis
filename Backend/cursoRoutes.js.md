# Documentación Técnica: cursosRoutes.js

Este archivo es un módulo fundamental del sistema. Gestiona todo lo relacionado con las clases, los materiales, la subida de archivos físicos y las listas de matriculados.

---

## 1. Importaciones y Configuración (Multer)

```javascript
const express = require('express');
const router = express.Router();
const db = require('../config/db');
const multer = require('multer');
const path = require('path');
const fs = require('fs');

// Configuración de Multer para guardar archivos localmente
const storage = multer.diskStorage({ ... });
const upload = multer({ storage });
```

- **Librerías Nativas (`path`, `fs`)**: Se utilizan para manejar rutas de carpetas de forma segura y para crear la carpeta `/uploads/materiales/` automáticamente si no existe (vital en contenedores Docker).
- **Multer (`diskStorage`)**: Actúa como un interceptor. Configura exactamente dónde se van a guardar los archivos físicos en el disco y les asigna un nombre único usando la fecha en milisegundos (`Date.now()`) para evitar que si se suben dos archivos con el mismo nombre se sobrescriban.

---

## 2. Subida y Consulta de Materiales

```javascript
router.post('/:cursoId/materiales/upload', upload.single('archivo'), async (req, res) => { ... });
router.get('/:cursoId/materiales', async (req, res) => { ... });
```

- **Subida (`.post`)**: 
  - Usa el middleware `upload.single('archivo')` para procesar el PDF/imagen antes de ejecutar el código.
  - Guarda el archivo físico y hace un `INSERT INTO material_clase` en PostgreSQL guardando la ruta lógica (`archivo_url`) para poder enlazarlo en el Frontend.
- **Listado (`.get`)**: Devuelve al Frontend todos los materiales de un curso específico, ordenados por fecha.

---

## 3. Obtención de Cursos (Lógica de Roles)

```javascript
router.get('/profesor/:id', async (req, res) => { ... });
router.get('/alumno/:id', async (req, res) => { ... });
```

- **Vista Profesor**: Ejecuta un `SELECT` para obtener todos los cursos que imparte ese profesor (`c.profesor_id = $1`), incluyendo una subconsulta para contar (`COUNT`) los alumnos matriculados en sus clases.
- **Vista Alumno**: Utiliza un `LEFT JOIN` con las materias y un `JOIN` con la tabla `matriculas` para devolver **únicamente** las asignaturas a las que ese alumno en particular tiene acceso.

---

## 4. Listado de Alumnos por Curso

```javascript
router.get('/:cursoId/alumnos', async (req, res) => { ... });
```

- **Propósito**: Generar el "acta" o listado de clase para los profesores.
- **Lógica SQL**: Utiliza un `INNER JOIN` entre la tabla `usuarios` y la tabla `matriculas` para extraer los nombres y correos de los estudiantes, ordenados alfabéticamente.

---

## 5. Exportación

```javascript
module.exports = router;
```

- Empaqueta todas estas rutas (subidas, vistas de profesor, vistas de alumno) en un solo módulo que `index.js` importará bajo el prefijo `/api/cursos`.
