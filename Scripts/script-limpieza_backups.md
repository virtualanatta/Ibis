# Script de Mantenimiento y Rotación de Backups

## Código base

<img width="930" height="198" alt="image" src="https://github.com/user-attachments/assets/3bdee20c-72ff-4214-82be-a5f4785eac5c" />


## Explicación

Este script de mantenimiento automatiza la eliminación de backups semanales con más de 30 días de antigüedad, optimizando el almacenamiento en el DAS.

### 1. Configuración de entorno y registro

Al inicio, el script establece las rutas clave para operar:

- **RUTA_BACKUPS**: define la ubicación donde se encuentran las carpetas de seguridad generadas previamente.
- **LOG_LIMPIEZA**: archivo donde se registra cada ejecución para mantener una trazabilidad del mantenimiento del sistema.
- **Encabezado de log**: utiliza `echo` con `$(date)` para estampar la fecha y hora exacta en la que inicia el proceso de limpieza.

### 2. Lógica `find`

Busca en `$RUTA_BACKUPS` sin descender en subdirectorios (`-maxdepth 1`).

- Filtra solo directorios (`-type d`).
- Selecciona carpetas nombradas como `semanal_*`.
- Aplica el criterio de antigüedad: más de 30 días (`-mtime +30`).
- Ejecuta el borrado de los elementos encontrados (`-exec rm -rf {} \;`).

### 3. Redirección de salida y cierre

- **Registro**: redirige la salida y errores (`2>&1`) al log, incluyendo la marca de tiempo de inicio y fin.

