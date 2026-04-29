# Documentación Técnica: Reparación Automática de BD (`check_and_fix_db.sh`)

## 1. Descripción General
Este script monitoriza el estado del contenedor de la base de datos PostgreSQL (`crisma_db`). Funciona como un sistema de **auto-sanación (auto-healing)**: detecta si el servicio está caído o bloqueado e intenta restaurarlo automáticamente, dejando constancia de todos los incidentes en un archivo de log unificado.

## 2. Flujo de Operación
El script evalúa la salud del sistema en dos capas de profundidad secuenciales:

* **Capa 1: Estado del Contenedor (Docker)**
    * Comprueba si el contenedor `crisma_db` está en ejecución mediante `docker inspect`.
    * **Acción correctiva:** Si está apagado, registra la caída en el log y ejecuta `docker start` para levantarlo de inmediato.
* **Capa 2: Disponibilidad del Servicio (PostgreSQL)**
    * Si el contenedor está encendido, verifica si el motor de base de datos responde internamente utilizando el comando `pg_isready`.
    * **Acción correctiva:** Si el servicio no responde (indicando un posible bloqueo o *freeze*), registra el error y ejecuta `docker restart` para forzar el reinicio completo del contenedor.

## 3. Especificaciones Técnicas
* **Contenedor Objetivo:** `crisma_db`
* **Archivo de Log:** `/mnt/TFG_CRIMSA/05_SISTEMA/LOGS/historial_conexiones.log`
* **Dependencias y Herramientas:** * Daemon de Docker (`docker inspect`, `docker exec`, `docker start`, `docker restart`).
  * Utilidad `pg_isready` (nativa de PostgreSQL).
* **Feedback Visual (ANSI):** * **Verde:** Funcionamiento normal o recuperación exitosa.
  * **Amarillo:** Inicio de comprobaciones.
  * **Rojo:** Detección de errores o fallos fatales de recuperación.
