# Documentación Técnica: Monitorización de Recursos (`check_recursos.sh`)

## 1. Descripción General
Este script se encarga de la **monitorización activa del rendimiento del sistema**, enfocándose en la memoria RAM disponible. Su propósito es prevenir caídas del servidor por saturación de memoria (*Out Of Memory*), evaluando el estado en tiempo real y enviando alertas críticas automatizadas a través de Telegram cuando se supera un umbral de riesgo.

## 2. Flujo de Operación
El script sigue un proceso de evaluación y notificación de tres pasos:

* **Paso 1: Extracción de Métricas**
    * Utiliza el comando `free -m` junto con `awk` para obtener la Memoria RAM Total y la Memoria RAM Disponible real del sistema (en Megabytes).
* **Paso 2: Cálculo de Capacidad**
    * Calcula el porcentaje exacto de memoria RAM que aún está libre y disponible para ser utilizada por los servicios.
* **Paso 3: Evaluación de Umbral y Alerta**
    * Comprueba si el porcentaje disponible cae por debajo del umbral crítico establecido (**15%**).
    * **Si el estado es crítico (< 15%):** Carga las variables de entorno de forma segura y utiliza la API de Telegram (`curl`) para enviar un mensaje de alerta inmediata al administrador.
    * **Si el estado es nominal (>= 15%):** Registra por consola que no se requiere ninguna acción, manteniendo el silencio operativo.

## 3. Especificaciones Técnicas
* **Comandos del Sistema:** `free`, `awk`, `curl`, `date`
* **Umbral de Alerta:** < 15% de RAM disponible.
* **Integraciones:** API de Telegram Bots (Notificaciones Push).
* **Gestión de Credenciales:** Las credenciales del bot de Telegram y el ID del chat se cargan desde un archivo oculto y externo al script (`/home/gerard/.config/crimsa/env`), aplicando el principio de **seguridad por separación de configuración** (evitando *hardcodear* tokens sensibles en el código).
