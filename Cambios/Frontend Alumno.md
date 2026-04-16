## Frontend – Vista de alumno

Inicialmente, la vista del alumno estaba construida utilizando datos estáticos definidos directamente en el código, lo que impedía mostrar información real procedente de la base de datos.

### Problema detectado

El componente `AlumnoPage.jsx` utilizaba un array fijo de asignaturas:

```
const asignaturas = [...]
```
Esto provocaba que:
- Los alumnos vieran siempre las mismas asignaturas
- No existiera relación con los datos reales de la base de datos
- El sistema no reflejara el estado real de las matriculaciones
---
### Solución aplicada
Se implementó una conexión dinámica con el backend mediante un servicio específico:
```
alumnoService.js
```
Este servicio realiza una petición al endpoint:
```
/api/cursos/alumno/:id
```
permitiendo obtener los cursos en los que está matriculado cada alumno.
---
### Implementación
Se realizaron los siguientes cambios en el frontend:
- Creación del servicio alumnoService.js utilizando axios
- Uso de useEffect para cargar los cursos al iniciar el componente
- Almacenamiento de los datos en un estado (cursos)
- Sustitución del array estático por datos dinámicos mediante:

```
const asignaturas = cursos.map(...)
```
---
### Resultado
Tras la implementación:
Cada alumno visualiza únicamente sus asignaturas reales
La información se obtiene directamente desde la base de datos
Se elimina completamente el uso de datos estáticos
Esto permite que la vista del alumno funcione de forma dinámica y coherente con el sistema académico definido.

