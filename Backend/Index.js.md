#  Documentación Técnica Backend: Plataforma Hogwarts

Este documento detalla la arquitectura, rutas y lógica de negocio del servidor desarrollado en Node.js/Express para el sistema de gestión de aprendizaje (LMS) de Hogwarts.

---

##  1. index.js (El Núcleo del Servidor)

Es el punto de entrada principal que levanta el servicio y coordina todos los módulos.

### Middlewares y Seguridad
- **CORS & Helmet**: Permiten la comunicación segura con el Frontend (React) y protegen las cabeceras HTTP.
- **Morgan**: Sistema de logs para monitorear peticiones en tiempo real.
- **express.static**: Define la carpeta `/uploads` como pública para servir los archivos PDF de forma directa.

### Funcionalidades Clave
- **Autenticación**: Gestiona el endpoint de login y utiliza `cookieParser` para el manejo de sesiones.
- **Contenidos Mixtos**: Implementa rutas que fusionan materiales y tareas en una sola respuesta JSON para facilitar el renderizado en React.
- **Visibilidad Dinámica**: Permite a los profesores ocultar o mostrar contenido con un solo clic mediante una ruta genérica de actualización.

---

##  2. routes/profesorRoutes.js (Rutas Docentes)

Módulo encargado de las vistas específicas para el personal docente.

### Endpoints
- **`GET /mis-cursos/:id`**: Devuelve la lista de asignaturas asignadas a un profesor específico.

**Valor Técnico:** Sigue el principio de **Responsabilidad Única**, delegando la lógica de las consultas SQL al controlador de profesores para mantener un código limpio y escalable.

---

##  3. routes/cursosRoutes.js (Gestión Académica y Multer)

Este es el módulo más complejo, ya que gestiona la relación entre usuarios, cursos y archivos físicos.

### Configuración de Multer (Gestión de Archivos)
```javascript
const storage = multer.diskStorage({
  destination: (req, file, cb) => { /* Crea carpetas automáticamente */ },
  filename: (req, file, cb) => { /* Evita duplicados con Date.now() */ }
});
```
Implementa una lógica robusta que asegura la existencia de carpetas en el servidor (vital para contenedores **Docker**) y previene la sobrescritura de archivos.

### Endpoints Destacados
- **Gestión de Materiales**: Permite subir PDFs (`POST`) y listar contenidos (`GET`) vinculando el archivo físico con un registro en PostgreSQL.
- **Vistas por Rol**:
  - **Profesor**: Obtiene cursos con conteo de alumnos matriculados.
  - **Alumno**: Utiliza `JOIN` con la tabla `matriculas` para mostrar solo las clases asignadas al estudiante.
- **Actas de Clase**: Genera listas de alumnos por curso ordenadas alfabéticamente por apellido.

---

##  4. routes/adminRoutes.js (Gestión de Usuarios)

Define las operaciones críticas para los administradores del sistema.

### Operaciones CRUD de Usuarios
```javascript
router.get('/users', adminController.getUsers);
router.post('/users', adminController.createUser);
router.put('/users/:id/role', adminController.updateUserRole);
router.put('/users/:id/password', adminController.updateUserPassword);
router.put('/users/:id/deactivate', adminController.deactivateUser);
```

### Funcionalidades:
- **Control de Roles**: Permite cambiar el rango de cualquier usuario (ej. de alumno a profesor).
- **Seguridad**: Ruta de emergencia para reseteo de contraseñas.
- **Borrado Lógico**: La función de desactivación impide el acceso al usuario sin eliminar sus registros históricos (notas, asistencias), manteniendo la integridad referencial de la base de datos.

---

##  Resumen de Desafíos Técnicos Superados

1. **Persistencia de Datos**: Configuración de volúmenes en Docker para evitar la pérdida de los archivos subidos en `/uploads`.
2. **Optimización de Consultas**: Uso de `LEFT JOIN` en PostgreSQL para asegurar que los cursos aparezcan aunque no tengan materias o alumnos asignados.
3. **Seguridad de Acceso**: Implementación de `Bcrypt` para asegurar que las contraseñas nunca se guarden en texto plano.
4. **Modularización MVC**: Separación estricta entre Rutas, Controladores y Configuración de DB, facilitando el mantenimiento del proyecto.


