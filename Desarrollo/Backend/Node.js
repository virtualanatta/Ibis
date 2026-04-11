```markdown
# 1. Arquitectura de Sistema y Estructura de Archivos

Se ha configurado el backend utilizando Node.js y el framework Express. La aplicación actúa como el núcleo de servicios que interconecta la base de datos Danet con el almacenamiento físico de 4 TB.

## Estructura de Directorios

Se ha implementado la siguiente organización de archivos en el servidor:

```

/ibis-backend (Contenedor: crisma_back)
├── config/             # Configuración de conexión (Sequelize)
├── controllers/        # Lógica de negocio (Auth, Campus)
├── models/             # Definición de esquemas de base de datos
├── routes/             # Definición de rutas de la API
├── utils/              # Utilidades (Envío de correos/Mailer)
├── .env.example        # Plantilla de variables de entorno
└── server.js           # Punto de entrada de la aplicación

````

---

# 2. Configuración de Infraestructura (Docker)

Se ha integrado el backend en el stack de contenedores bajo la red `crisma_network`. Se ha configurado la persistencia de datos directamente en el DAS.

- **Persistencia:** Mapeo del volumen físico `/mnt/TFG_CRIMSA/` al contenedor.  
- **Aislamiento:** El backend no expone puertos públicos; la gestión de tráfico se realiza internamente a través del Proxy.

## Fragmento de docker-compose.yml

```yaml
crisma_back:
  build: ./backend
  container_name: crisma_back
  restart: always
  environment:
    - DB_HOST=crisma_db
  volumes:
    # Acceso al almacenamiento masivo de 4 TB (RAID 1)
    - /mnt/TFG_CRIMSA/02_DATOS/campus_storage:/app/storage
    - /mnt/TFG_CRIMSA/04_MONITORIZACION/logs/backend:/app/logs
  networks:
    - crisma_network
````

---

# 3. Especificación Técnica de Base de Datos (Danet)

Se ha implementado el motor PostgreSQL con una estructura relacional de alta integridad.

## Diccionario de Datos (Tablas Operativas)

| Tabla    | Campo          | Tipo         | Restricciones          |
| -------- | -------------- | ------------ | ---------------------- |
| usuarios | id             | SERIAL       | PRIMARY KEY            |
| usuarios | email          | VARCHAR(255) | UNIQUE, NOT NULL       |
| usuarios | password       | TEXT         | NOT NULL (Hash Bcrypt) |
| usuarios | role_id        | INTEGER      | FK (roles.id)          |
| usuarios | is_first_login | BOOLEAN      | DEFAULT TRUE           |
| cursos   | id             | SERIAL       | PRIMARY KEY            |
| cursos   | nombre         | VARCHAR(255) | NOT NULL               |
| cursos   | profesor_id    | INTEGER      | FK (usuarios.id)       |
| cursos   | is_visible     | BOOLEAN      | DEFAULT FALSE          |

## Integridad y Seguridad

* **Restricciones:** Uso de `ON DELETE RESTRICT` para proteger la integridad de los datos académicos.
* **Optimización:** Se han creado índices B-Tree en `usuarios.email` para acelerar el proceso de autenticación.
* **Acceso:** Configuración de `pg_hba.conf` para permitir únicamente conexiones desde la subred de Docker.

---

# 4. Implementación del Backend (Código Node.js)

## Configuración de Entorno (.env.example)

```javascript
PORT=3005
DB_HOST=crisma_db
DB_USER=Crisma
DB_PASSWORD=xxxx
DB_NAME=Danet
JWT_SECRET=xxxx
```

## Punto de Entrada (server.js)

Se ha configurado el servidor para permitir la gestión de archivos de gran tamaño.

```javascript
const express = require('express');
const cors = require('cors');
const app = express();

app.use(cors());
app.use(express.json({ limit: '100mb' }));

// Rutas de la API
app.use('/api/auth', require('./routes/auth'));
app.use('/api/campus', require('./routes/campus'));

const PORT = process.env.PORT || 3005;
app.listen(PORT, () => console.log(`Servidor Ibis activo en puerto ${PORT}`));
```

## Controlador de Autenticación (authController.js)

Actualmente funciona la lógica de validación de identidad y detección de estado de usuario.

```javascript
const User = require('../models/User');
const bcrypt = require('bcryptjs');

exports.login = async (req, res) => {
    const { email, password } = req.body;
    const user = await User.findOne({ where: { email } });

    if (!user || !(await bcrypt.compare(password, user.password))) {
        return res.status(401).json({ msg: "Credenciales inválidas" });
    }

    // Validación de cambio de contraseña obligatorio
    if (user.is_first_login) {
        return res.status(403).json({ resetRequired: true });
    }

    // Entrega de token JWT (Lógica implementada)
};
```

---

# 5. Estado de la Implementación (Objetivo)

## Hecho (Implementado y Operativo)

* **Conectividad:** Enlace funcional entre Node.js y PostgreSQL (Danet) en Docker.
* **Persistencia:** Almacenamiento de archivos en el DAS de 4 TB.
* **Seguridad Base:** Autenticación mediante JWT y encriptación de claves con Bcrypt.
* **Roles:** Sistema de permisos diferenciado en la base de datos.
* **Infraestructura:** Despliegue automatizado mediante Docker Compose en `crisma_network`.

## No Hecho (Mejoras y Planteamientos Futuros)

* **MFA (Doble Factor):** Se plantea como mejora el envío de códigos de 6 dígitos vinculando el backend con Mailcow.
* **SSO (Single Sign-On):** Queda pendiente la unificación de sesiones con Nextcloud y Mattermost.
* **Sincronización:** Se plantea como mejora la creación automática de carpetas y canales mediante peticiones API desde el backend.
* **Cuotas de Disco:** Queda pendiente la implementación de límites de almacenamiento por usuario en el RAID 1.

```
```
