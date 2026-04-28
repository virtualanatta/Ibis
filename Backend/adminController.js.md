#  Documentación Técnica: adminController.js

Este archivo contiene la lógica de negocio subyacente para las operaciones del panel de administración. Aquí es donde se ejecutan las consultas SQL reales que modifican el estado de los usuarios.

---

## 1. Importaciones y Dependencias

```javascript
const db = require('../config/db');
const bcrypt = require('bcryptjs');
```

- **`db`**: Instancia de la conexión a la base de datos PostgreSQL.
- **`bcryptjs`**: Librería fundamental para el cifrado criptográfico. Es esencial para evitar guardar contraseñas en texto plano.

---

## 2. Lógica de Funciones Principales

### Obtención de Usuarios
```javascript
const getUsers = async (req, res) => { ... }
```
- Realiza una consulta `SELECT` ordenando a los usuarios por su ID ascendente. Devuelve un JSON limpio que el frontend utiliza para pintar la tabla de administración.

### Creación Segura de Usuarios
```javascript
const createUser = async (req, res) => { ... }
```
- **Hashing**: Antes de guardar, genera una "sal" (`bcrypt.genSalt`) y cifra la contraseña recibida (`bcrypt.hash`).
- **Valor por defecto**: Si no se especifica el rol, se asigna `alumno` de forma predeterminada.
- **`RETURNING`**: Utiliza esta cláusula de PostgreSQL para que la base de datos devuelva el nuevo usuario creado sin necesidad de hacer un `SELECT` extra.

### Actualización de Contraseñas y Roles
```javascript
const updateUserRole = async (req, res) => { ... }
const updateUserPassword = async (req, res) => { ... }
```
- Separa estas dos acciones por seguridad.
- Al actualizar la contraseña desde el panel de admin, vuelve a aplicar el proceso de hashing con `bcrypt` para garantizar que la nueva contraseña cifrada sea válida en el login.

---

## Valor Técnico del Archivo
La implementación del cifrado de contraseñas (`bcrypt`) directo en el controlador demuestra conocimientos en seguridad y prevención contra filtraciones de datos (Data Breaches). Además, el manejo de bloques `try/catch` asegura que el servidor no se caiga si ocurre un error en SQL.
