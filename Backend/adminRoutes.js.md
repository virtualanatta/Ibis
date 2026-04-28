# Documentación Técnica: adminRoutes.js

Este archivo define el módulo de rutas encargado de todas las operaciones administrativas de la plataforma Hogwarts. Su función principal es gestionar el ciclo de vida de los usuarios (alumnos, profesores y administradores).

---

## 1. Importaciones del Enrutador

```javascript
const express = require('express');
const router = express.Router();
const adminController = require('../controllers/adminController');
```

- **`express`**: El framework principal para el manejo de peticiones HTTP.
- **`router`**: Instancia de `express.Router()` que permite empaquetar estas rutas de forma modular, manteniendo el archivo principal (`index.js`) limpio.
- **`adminController`**: Importa la lógica de negocio. Siguiendo el patrón **MVC (Modelo-Vista-Controlador)**, las rutas no tocan la base de datos directamente; simplemente llaman a las funciones de este controlador.

---

## 2. Definición de las Rutas de Administración

Estas rutas cubren las operaciones críticas de gestión de usuarios en el sistema:

```javascript
// Gestión de Usuarios
router.get('/users', adminController.getUsers);
router.post('/users', adminController.createUser);
router.put('/users/:id/role', adminController.updateUserRole);
router.put('/users/:id/password', adminController.updateUserPassword);
router.put('/users/:id/deactivate', adminController.deactivateUser);
```

### Detalle de cada Endpoint:
- **`GET /users`**: Recupera la lista completa de usuarios. Es la base para el panel de control del administrador.
- **`POST /users`**: Permite la creación manual de usuarios, definiendo nombre, email y rol inicial.
- **`PUT /users/:id/role`**: Endpoint específico para cambiar el rango de un usuario (ej. convertir a un 'alumno' en 'profesor').
- **`PUT /users/:id/password`**: Función de utilidad para que el administrador pueda resetear contraseñas en caso de olvido o bloqueo.
- **`PUT /users/:id/deactivate`**: Implementa el **borrado lógico**. En lugar de eliminar la fila de la DB (lo que rompería la integridad de datos de cursos pasados), simplemente marca al usuario como inactivo.

---

## 3. Exportación y Conectividad

```javascript
module.exports = router;
```

- **Modularización**: El objeto `router` se exporta para que `index.js` pueda integrarlo usando `app.use('/api/admin', adminRoutes)`.
- **Nomenclatura**: El uso del parámetro `:id` en las rutas permite que estas sean dinámicas y escalables para cualquier cantidad de usuarios.

---

## 💡 Valor Técnico del Archivo (Para la Presentación)

- **Seguridad Centralizada**: Al tener todas las rutas de administración en un solo archivo, es más fácil aplicar en el futuro un middleware de verificación (ej. `isAdmin`) para proteger estos puntos de acceso.
- **Abstracción de Lógica**: El archivo de rutas se encarga únicamente de la "navegación", delegando la complejidad de las consultas SQL al controlador.
- **Escalabilidad**: Esta estructura permite añadir nuevas funciones administrativas (como reportes o auditorías) de forma rápida y sin interferir con las rutas de los alumnos o profesores.
