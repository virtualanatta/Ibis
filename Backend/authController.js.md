#  Documentación Técnica: authController.js

Este archivo es la puerta principal de seguridad de la plataforma. Gestiona la autenticación de usuarios y la generación de tokens de acceso seguro.

---

## 1. Importaciones

```javascript
const db = require('../config/db');
const jwt = require('jsonwebtoken');
const bcrypt = require('bcryptjs');
```

- **`jwt` (JSON Web Token)**: Librería utilizada para generar un "pase" digital que acredita quién es el usuario una vez que ha iniciado sesión con éxito.
- **`bcryptjs`**: Usado aquí para comparar la contraseña ingresada con la encriptada.

---

## 2. Proceso de Login

```javascript
const login = async (req, res) => { ... }
```

El flujo de esta función es crítico y sigue estos pasos:

1. **Búsqueda Normalizada**: Busca el correo usando `LOWER(TRIM(email))` en SQL. Esto previene errores comunes si el usuario introduce espacios en blanco o mayúsculas sin querer.
2. **Validación de Credenciales**: Utiliza `bcrypt.compare()` para verificar de forma segura que la contraseña en texto plano introducida en React coincida con el *hash* almacenado en PostgreSQL.
3. **Generación del Token**:
   - Si todo es correcto, firma un JWT con el ID y el ROL del usuario.
   - Utiliza una variable de entorno `process.env.JWT_SECRET` (o una clave por defecto en su ausencia) para que el token no pueda ser falsificado.
   - Establece una caducidad de `8h` para forzar que la sesión expire y mejorar la seguridad.

---

##  Valor Técnico del Archivo
La combinación de **Bcrypt** para las contraseñas y **JWT** para el control de sesiones representa el estándar actual en el desarrollo de APIs modernas (Stateless Authentication). Además, los `console.log` implementados ayudan enormemente en la auditoría y monitoreo de los intentos de acceso.
