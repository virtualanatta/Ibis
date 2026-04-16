## Frontend – Vista de profesor

Durante el desarrollo se detectó que la vista del profesor no mostraba información real de la base de datos, debido a una mala configuración en la conexión con el backend.

### Problema detectado

El frontend realizaba peticiones a una ruta incorrecta:

```
/api/profesor/mis-cursos/:id
```
Sin embargo, el backend no disponía de este endpoint, lo que provocaba que no se mostraran los cursos del profesor.
---
### Solución aplicada
Se corrigió la ruta en el servicio encargado de las peticiones (profesorService.js), adaptándola al endpoint real del backend:
```
/api/cursos/profesor/:id
```
---
### Implementación
Se configuró el servicio para realizar la petición mediante axios:
```
export const getMisCursos = async (profesorId) => {
 const response = await axios.get(
   `http://localhost:3005/api/cursos/profesor/${profesorId}`
 );
 return response.data;
};
```
La vista del profesor utiliza este servicio para obtener los cursos dinámicamente al cargar la página.
---
### Resultado
Tras la corrección:
Cada profesor visualiza únicamente los cursos que imparte
Los datos se cargan directamente desde la base de datos
Se elimina la dependencia de datos estáticos en el frontend

