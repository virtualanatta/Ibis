# Script de Auditoría de Conexiones y Estado del Almacenamiento

## Código

<img width="909" height="277" alt="image" src="https://github.com/user-attachments/assets/c75c7601-20c6-40c7-9bd6-563dd5617368" />


## Explicación

Este script de monitorización registra quién accede al sistema y el estado de ocupación del almacenamiento DAS en tiempo real, facilitando la auditoría y prevención de llenado del disco.

### 1. Captura de Variables de Sesión

El script recolecta cuatro datos clave en cada ejecución:

- **AHORA**: Registra fecha y hora exacta con precisión de segundos usando `date "+%Y-%m-%d %H:%M:%S"`.
- **USUARIO**: Identifica la cuenta activa mediante el comando `whoami`.
- **IP_REMOTA**: Extrae la dirección de origen desde `$SSH_CONNECTION`.
- **Lógica condicional**: Si la variable está vacía, asigna el valor `"Local"` para indicar acceso físico al servidor.

### 2. Monitorización del Espacio (`df`)

Utiliza el comando `df -h` para supervisar la salud del volumen de datos:

- **ESPACIO**: Filtra la salida mediante `awk 'NR==2 {print $5}'` para obtener exclusivamente el porcentaje de uso del punto de montaje `/mnt/TFG_CRIMSA`.

### 3. Registro Estructurado (`printf`)

A diferencia de un log simple, utiliza `printf` para generar un historial profesional:

- **Formateo de columnas**: Define anchos fijos para que todas las líneas queden alineadas.
- **Persistencia (`>>`)**: Añade la información al final de `historial_conexiones.log` sin sobreescribir registros anteriores, permitiendo un análisis histórico del uso del sistema.
