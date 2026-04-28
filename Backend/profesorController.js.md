#  Documentación Técnica: profesorController.js

Este controlador centraliza la lógica para que los docentes puedan obtener información detallada sobre las clases que imparten.

---

## 1. Función: getMisCursos

```javascript
const getMisCursos = async (req, res) => { ... }
```

Esta es una de las funciones más complejas a nivel de base de datos debido a las relaciones que necesita gestionar.

### Desglose de la Consulta SQL
La consulta define la estructura que React necesita para construir las tarjetas ("cards") del panel del profesor:

1. **Datos base (`JOIN`)**: Cruza la tabla relacional `cursos_profesores` con la tabla `cursos` para obtener solo las asignaturas asignadas al profesor pasado por parámetro.
2. **Materia (`LEFT JOIN`)**: Obtiene el nombre de la materia global sin fallar si el curso aún no tiene una materia asignada.
3. **Estadísticas Dinámicas (`COUNT`)**:
   - Usa un `LEFT JOIN` con `matriculas`.
   - Utiliza `COUNT(DISTINCT mat.estudiante_id)` agrupado por curso (`GROUP BY`). 
   - Esto le dice al profesor exactamente cuántos alumnos únicos hay inscritos en su clase en tiempo real, en un solo viaje a la base de datos.

---

##  Valor Técnico del Archivo
Este archivo ilustra un excelente dominio del lenguaje SQL y el diseño de APIs eficientes. En lugar de pedir los cursos y luego hacer 5 llamadas diferentes al servidor para contar los alumnos de cada uno, condensa toda la lógica en una sola consulta estructurada, optimizando drásticamente los tiempos de carga del Frontend.
