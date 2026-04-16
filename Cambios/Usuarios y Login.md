## Usuarios y autenticación

Durante el desarrollo del sistema se realizó una reorganización completa de la gestión de usuarios con el objetivo de garantizar un funcionamiento coherente y estable del sistema de autenticación.

### Limpieza de usuarios

Se eliminaron los usuarios innecesarios generados durante fases previas de desarrollo, manteniendo únicamente los usuarios esenciales para pruebas y validación del sistema:

- admin@test.com
- profesor@test.com
- alumno@test.com

Esto permitió trabajar sobre una base de datos limpia y controlada.

### Sistema de roles

Se detectó la existencia de múltiples mecanismos de gestión de roles:

- Campo `role_id` en la tabla `usuarios`
- Campo `rol` en la tabla `usuarios`
- Tabla intermedia `usuarios_roles`

Para evitar inconsistencias durante el desarrollo, se decidió no unificar el sistema en esta fase, pero sí asegurar la coherencia entre ellos para garantizar el correcto funcionamiento del sistema.

### Autenticación

El sistema de autenticación utiliza cifrado de contraseñas mediante `bcrypt`.

Para simplificar la creación de usuarios iniciales, se reutilizó el hash de contraseña del usuario administrador, asignándolo al resto de usuarios generados. Esto permite acceder con una contraseña común en entorno de desarrollo.

El proceso de login devuelve un token JWT junto con la información básica del usuario autenticado, incluyendo su identificador (`id`), necesario para el resto de operaciones del sistema.

