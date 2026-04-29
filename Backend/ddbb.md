# Documentación Técnica: Modelo y Diccionario de Datos

## 1. Visión General
La base de datos principal del sistema, denominada **`Danet`**, soporta la lógica de negocio de una plataforma educativa o entorno virtual de aprendizaje. Su diseño relacional (PostgreSQL) garantiza la integridad de los datos mediante el uso estricto de claves foráneas, restricciones de unicidad y borrados en cascada.

A nivel de seguridad, el esquema destaca por el almacenamiento seguro de credenciales (uso de `password_hash` en lugar de contraseñas en texto plano) y la implementación de controles de acceso basados en roles (RBAC), incluyendo perfiles de auditoría de solo lectura.

## 2. Diccionario de Datos por Módulos

### Módulo de Identidad y Acceso (IAM)
Gestión de los actores del sistema (profesores, alumnos y administradores).

| Tabla | Descripción | Columnas Clave | Reglas y Restricciones |
| :--- | :--- | :--- | :--- |
| **`usuarios`** | Almacena los perfiles de todos los usuarios del sistema. | `id` (PK)<br>`nombre_usuario`<br>`email`<br>`password_hash`<br>`rol`<br>`role_id` | `email` y `nombre_usuario` son **UNIQUE**.<br>Auditoría de primer login (`is_first_login`) y estado de cuenta activo/inactivo. |

### Módulo de Estructura Académica
Define la jerarquía de los estudios y la asignación de usuarios a los mismos.

| Tabla | Descripción | Columnas Clave | Reglas y Restricciones |
| :--- | :--- | :--- | :--- |
| **`materias`** | Catálogo general de asignaturas. | `id` (PK)<br>`nombre` | N/A |
| **`cursos`** | Instancias específicas de una materia impartidas por un profesor. | `id` (PK)<br>`titulo`<br>`profesor_id` (FK)<br>`materia_id` | Relación con `usuarios` (Profesor).<br>Control de visibilidad (`is_visible`). |
| **`matriculas`** | Tabla puente (N:M) que vincula alumnos con cursos. | `id` (PK)<br>`estudiante_id` (FK)<br>`curso_id` (FK) | Restricción **UNIQUE** (`estudiante_id`, `curso_id`) para evitar matrículas duplicadas.<br>Borrado en cascada (ON DELETE CASCADE). |

### Módulo de Contenidos y Evaluación
Gestión de archivos, asignaciones y calificaciones.

| Tabla | Descripción | Columnas Clave | Reglas y Restricciones |
| :--- | :--- | :--- | :--- |
| **`material_clase`** | Archivos y recursos subidos por los profesores para un curso. | `id` (PK)<br>`curso_id` (FK)<br>`profesor_id` (FK)<br>`ruta_fisica`<br>`mimetype` | Trazabilidad del tamaño y tipo de archivo.<br>Borrado en cascada si se elimina el curso. |
| **`tareas`** | Asignaciones que requieren entrega por parte del alumno. | `id` (PK)<br>`curso_id` (FK)<br>`fecha_limite` | Control temporal (`fecha_limite`). |
| **`entregas_tareas`** | Archivos subidos por los alumnos como respuesta a una tarea. | `id` (PK)<br>`tarea_id` (FK)<br>`alumno_id` (FK)<br>`nota` | Trazabilidad de fecha de entrega (`entregado_en`) y *feedback* del profesor (`comentario_profesor`). |

## 3. Controles de Seguridad e Integridad Aplicados

* **Principio de Mínimo Privilegio (PoLP):** Se ha creado un rol específico llamado `readonly_auth` con permisos limitados exclusivamente a `SELECT` en la tabla de usuarios, ideal para auditorías de seguridad o integraciones de terceros sin comprometer la base de datos.
* **Protección contra Huérfanos:** Implementación de `ON DELETE CASCADE` en tablas dependientes (como `matriculas`, `material_clase` y `tareas`) para asegurar que no queden registros basura si se elimina un curso principal.
* **Seguridad Criptográfica Básica:** El sistema no almacena contraseñas en texto claro, dedicando la columna `password_hash` (`VARCHAR(255)`) para acomodar algoritmos de cifrado robustos (ej. Bcrypt o Argon2).
