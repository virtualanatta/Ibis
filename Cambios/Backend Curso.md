## Backend – Gestión de cursos

Durante el desarrollo se detectó que el sistema no disponía de endpoints que permitieran obtener los cursos asociados a profesores y alumnos. Esto impedía que el frontend pudiera mostrar información real procedente de la base de datos.

Para solucionar este problema, se implementaron nuevos endpoints en el backend orientados a la obtención de cursos en función del usuario autenticado.

### Endpoints implementados

Se añadieron las siguientes rutas:

#### Cursos del profesor

```
GET /api/cursos/profesor/:id
```
Este endpoint devuelve todos los cursos asociados a un profesor concreto.
La consulta utilizada es:
```
SELECT c.id, c.codigo_alfanumerico, c.titulo, m.nombre AS materia
FROM cursos c
JOIN materias m ON m.id = c.materia_id
WHERE c.profesor_id = $1
ORDER BY c.id;
```
Permite que cada profesor visualice únicamente los cursos que imparte.
---
#### Cursos del alumno
```
GET /api/cursos/alumno/:id
```

Este endpoint devuelve los cursos en los que está matriculado un alumno.

La consulta utilizada es:

```
SELECT c.id, c.codigo_alfanumerico, c.titulo, m.nombre AS materia
FROM matriculas ma
JOIN cursos c ON c.id = ma.curso_id
JOIN materias m ON m.id = c.materia_id
WHERE ma.estudiante_id = $1
ORDER BY c.id; 
```
Permite que cada alumno acceda únicamente a sus asignaturas.
---
#### Integración en el servidor
Las rutas fueron integradas en el archivo principal del backend (index.js) mediante:
```
app.use('/api/cursos', cursosRoutes);
```
Esto permite centralizar todas las operaciones relacionadas con cursos bajo el prefijo /api/cursos.
Resultado
Gracias a estos endpoints, el sistema pasa de trabajar con datos estáticos a utilizar información real de la base de datos, permitiendo:
Consultas dinámicas por usuario
Separación clara entre profesor y alumno
Escalabilidad para futuras funcionalidades (tareas, entregas, etc.)

