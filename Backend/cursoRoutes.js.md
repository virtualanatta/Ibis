# Documentación Técnica: cursosRoutes.js

Este archivo es un módulo fundamental del sistema. Gestiona todo lo relacionado con las clases, los materiales, la subida de archivos físicos y las listas de matriculados.

---

## 1. index.js

El `index.js` es el punto de entrada principal. Configura el servidor, los middlewares de seguridad y reparte el tráfico hacia las rutas específicas.

### Middlewares Principales
- **CORS & Helmet**: Protegen la API y permiten la comunicación con el Frontend (React).
- **express.json() & cookieParser()**: Permiten procesar datos en formato JSON y gestionar las cookies de sesión.
- **express.static**: Convierte la carpeta `/uploads` en pública para que los PDFs de tareas y materiales sean accesibles vía URL.

### Gestión de Contenidos
El servidor combina consultas SQL de `material_clase` y `tareas` para entregar al alumno una lista unificada de contenidos mediante el operador *spread* de JavaScript.

### Subida de Archivos (Multer)
Utiliza **Multer** para interceptar archivos físicos, renombrarlos con un sello de tiempo (`Date.now()`) para evitar duplicados y guardarlos en el disco duro antes de registrar su ruta en PostgreSQL.

---

## 2. routes/profesorRoutes.js (Gestión de Profesores)

Este archivo utiliza un enrutador independiente para organizar las peticiones exclusivas del personal docente.

### Estructura
- **Modularización**: Separa las rutas de la lógica de negocio importando `profesorController`.
- **Rutas Dinámicas**: 
  - `GET /mis-cursos/:id`: Captura el ID del profesor desde la URL para filtrar sus clases específicas en la base de datos.

**Valor Técnico:** Aplica el principio de responsabilidad única, facilitando la escalabilidad del proyecto sin saturar el archivo principal.

---

## 3. routes/cursosRoutes.js (Gestión Académica y Archivos)

Es el módulo más robusto, encargado de la relación entre alumnos, profesores y materiales físicos.

### Configuración de Almacenamiento
- **Multer Avanzado**: Implementa `diskStorage` para organizar las subidas en carpetas dinámicas. Usa `fs.mkdirSync` para asegurar que las carpetas existan en el servidor (crucial para entornos Docker).

### Endpoints Clave
1. **Subida de Material (`POST /:cursoId/materiales/upload`)**: 
   - Procesa el archivo físico.
   - Registra metadatos en la DB (tamaño, tipo de archivo, URL lógica).
2. **Vistas de Rol (`GET /profesor/:id` y `GET /alumno/:id`)**:
   - **Profesor**: Usa `LEFT JOIN` y subconsultas para contar alumnos matriculados.
   - **Alumno**: Filtra mediante un `JOIN` con la tabla `matriculas` para mostrar solo sus clases asignadas.
3. **Listado de Alumnos (`GET /:cursoId/alumnos`)**: 
   - Realiza un `INNER JOIN` entre `usuarios` y `matriculas` para generar actas de clase ordenadas alfabéticamente.

