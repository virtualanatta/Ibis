# Script de Backup con rsync

## Código base

<img width="763" height="314" alt="image" src="https://github.com/user-attachments/assets/ff38d2a5-e60c-43b5-b0fa-c144b3416670" />


## Explicación

El script de backup en Bash utiliza `rsync` para realizar una copia.

### 1. Variables y rutas

Define:

- **ORIGEN**: directorios a respaldar.
- **DESTINO**: ruta con carpeta de fecha, por ejemplo `semanal_20260318`.
- **LOG**: archivo de historial.

### 2. Preparación

Crea el directorio de destino y sus carpetas superiores si no existen:

```bash
mkdir -p "$DESTINO"
```

### 3. Respaldo (`rsync -az`)

```bash
rsync -az "$ORIGEN" "$DESTINO"
```

Opciones usadas:

- **`-a` (archive)**: mantiene permisos, propietarios y fechas.
- **`-z` (compress)**: comprime los datos para acelerar la transferencia.

Se omite el modo verbose (`-v`) para facilitar la automatización.

### 4. Logging y control de errores (`$?`)

- **0 (éxito)**: registra `"COPIA CORRECTA"` en el log.
- **Otro valor (fallo)**: registra `"ERROR EN LA COPIA"` para revisión.
