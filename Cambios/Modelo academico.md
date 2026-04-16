## Modelo académico de ejemplo

Con el objetivo de simular un entorno real de uso del sistema, se ha definido un modelo académico basado en una escuela ficticia (Hogwarts). Este modelo permite validar el funcionamiento de la plataforma en un escenario estructurado similar a un centro educativo real.

### Estructura académica

El sistema se ha organizado en torno a los siguientes elementos:

- **Cursos académicos (clases):**
  - 1A
  - 1B
  - 2A
  - 2B

- **Materias:**
  - Pociones
  - Defensa Contra las Artes Oscuras
  - Encantamientos
  - Herbología
  - Transformaciones
  - Historia de la Magia

- **Profesores:**
  Se han definido seis profesores, asignando cada uno a una materia específica.

- **Alumnos:**
  Se han creado múltiples alumnos distribuidos entre las diferentes clases, simulando grupos reales.

### Relación entre entidades

El modelo académico se basa en las siguientes relaciones:

- Un **profesor imparte una materia**, definida en la tabla `profesor_materias`.
- Un **curso** representa la combinación de una clase (por ejemplo, 1A) y una materia (por ejemplo, Pociones).
- Cada curso tiene asignado un **profesor** mediante el campo `profesor_id`.
- Los **alumnos se inscriben en cursos** a través de la tabla `matriculas`.

### Ejemplo de funcionamiento

Un alumno matriculado en la clase 1A estará inscrito en seis cursos diferentes, uno por cada materia, todos ellos asociados a distintos profesores.

De este modo, el sistema permite:

- Gestionar la relación alumno–asignaturas
- Identificar los cursos impartidos por cada profesor
- Simular un entorno académico completo para pruebas y demostración

