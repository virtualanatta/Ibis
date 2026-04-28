# Documentación Técnica: profesorRoutes.js

Este archivo define el módulo de rutas dedicado exclusivamente a las operaciones de los profesores, respetando el principio de responsabilidad única.

---

## 1. Importaciones del Enrutador

```
const express = require("express");
const router = express.Router();
const profesorController = require("../controllers/profesorController");
```

- `express` Volvemos a llamar al motor del servidor porque necesitamos una de sus herramientas específicas.
- `express.Router()` Crea un enrutador independiente que es exclusiva a los trámites de los profesores.
- `profesorController` Importamos el archivo que contiene la lógica. Esta searada poara que sea facil de leer


## 2. Definición de las Rutas

```
router.get("/mis-cursos/:id", profesorController.getMisCursos);
```

- `.get` Indica que esta ruta sirve para leer o pedir información (no para crear ni borrar)
- `/mis-cursos/:id` Define el camino exacto.
- `profesorController.getMisCursos` Este archivo no hace la consulta a la base de datos. Simplemente coge la petición que acaba de llegar y se la pasa a la función ''getMisCursos`


## 3. Exportación del Módulo

```
module.exports = router;
```

- Esto empaqueta las rutas y las hace públicas para que `index.js` pueda importarlas y conectarlas con el servidor principal


### Conclusión:

Este archivo es importante porque nos permite añadir rutas sin tener que estar buscando en el archivo grande `index.js`. Los separamos para mantener cada cosa en su lugar y hacer el proyecto escalable.



















