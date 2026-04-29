# Documentación Técnica: Registro de Almacenamiento (`check_sistema.sh`)

## 1. Descripción General
Este script funciona como un **agente de auditoría de almacenamiento**. Se encarga de capturar el espacio en disco utilizado por el directorio principal del proyecto y registrar esta métrica de forma estructurada en el log centralizado. Esto permite tener un histórico del crecimiento de los datos y anticiparse a posibles problemas de falta de espacio.

## 2. Flujo de Operación
El script es directo y eficiente, ejecutando las siguientes tareas de forma secuencial:

* **Captura de Tiempo:** Genera una marca de tiempo (timestamp) estandarizada (`YYYY-MM-DD HH:MM:SS`) para asegurar la trazabilidad cronológica del evento.
* **Extracción de Métricas de Disco:** Utiliza el comando `df -h` enfocado específicamente en el volumen `/mnt/TFG_CRIMSA`. A través de `awk`, aísla únicamente el dato que importa: el porcentaje de uso actual.
* **Registro Tabulado:** Utiliza la función `printf` para dar un formato de tabla con anchos de columna fijos. Esto garantiza que el archivo de log sea visualmente limpio, estructurado y fácil de parsear por otras herramientas si fuera necesario. Posteriormente, anexa esta línea al archivo de registro.

## 3. Especificaciones Técnicas
* **Directorio Monitorizado:** `/mnt/TFG_CRIMSA`
* **Archivo de Log de Destino:** `/mnt/TFG_CRIMSA/05_SISTEMA/LOGS/historial_conexiones.log`
* **Comandos y Utilidades:** `date`, `df` (Disk Free), `awk`, `printf`.
* **Estructura del Log:** Formato de longitud fija por columnas:
  `[Timestamp (20 chars)] | [Categoría: SYSTEM] | [Origen: Internal] | [Métrica: DAS %]`
