# Documentación Técnica: Playbook Maestro (TFG CRIMSA)

## 1. Descripción General
Este script de Bash actúa como el **orquestador central** del proyecto CRIMSA. Su función principal es la monitorización y el mantenimiento automatizado del entorno, garantizando la disponibilidad de los servicios críticos y la actualización de los indicadores de estado en el panel de control.

## 2. Flujo de Operación
El playbook ejecuta un ciclo de tres fases principales mediante una estructura secuencial:

| Fase | Tarea | Script Asociado | Objetivo |
| :--- | :--- | :--- | :--- |
| **1** | **Vigilancia de BD** | `check_and_fix_db.sh` | Detectar anomalías en la base de datos y aplicar correcciones automáticas. |
| **2** | **Control de Recursos** | `check_recursos.sh` | Monitorizar CPU, RAM y almacenamiento para prevenir caídas por saturación. |
| **3** | **Actualización** | `generar_dashboard.sh` | Reflejar los datos obtenidos en la interfaz visual del usuario. |

## 3. Especificaciones Técnicas
* **Directorio Raíz:** `/mnt/TFG_CRIMSA/01_PROYECTO/scripts`
* **Lenguaje:** Bash Shell
* **Interfaz:** Salida por consola con códigos de colores (ANSI) para facilitar la lectura de estados:
    * **Amarillo:** Procesos en ejecución.
    * **Verde:** Finalización exitosa del ciclo.
    * **Rojo:** Definido para alertas (integrado en los scripts secundarios).
