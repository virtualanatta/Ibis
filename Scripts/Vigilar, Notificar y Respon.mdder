# Vigilar, Notificar y Responder: Sistema de Seguridad Activa IbisScripts

## Visión General

El sistema **IbisScripts** es la capa de automatización defensiva del Campus Ibis. Está compuesto por un conjunto de scripts Bash organizados en tres bloques funcionales: seguridad activa, monitorización y dashboard, y mantenimiento y backups. Todos los scripts residen en:

```text
/mnt/TFG_CRIMSA/01_PROYECTO/scripts/IbisScripts/
```

Cada script está diseñado bajo el principio de responsabilidad única: hace una sola cosa, la hace bien, y se comunica con el resto a través de `bot.sh`.

## Bloque 1: Sistema de Seguridad Activa

### 1. bot.sh — El Emisor de Alertas

Actúa como el núcleo de comunicación de todo el sistema. Centraliza el envío de mensajes a Telegram cargando las credenciales desde un archivo seguro en el sistema de archivos, evitando que el Token o el Chat ID queden expuestos en el código fuente.

**Archivo de credenciales (nunca incluir en el repositorio):**

```text
/home/gerard/.config/crimsa/env
```

Contenido:

```bash
TELEGRAM_TOKEN=<tu_token_aquí>
ID_CHAT=<tu_chat_id_aquí>
```

**Código clave:**

```bash
source /home/gerard/.config/crimsa/env   # Carga Token y ChatID de forma segura
curl -s -X POST "https://api.telegram.org/bot${TELEGRAM_TOKEN}/sendMessage" \
     -d "chat_id=${ID_CHAT}" \
     --data-urlencode "text=${MENSAJE}"
```

**Uso desde otros scripts:**

```bash
bash /mnt/TFG_CRIMSA/01_PROYECTO/scripts/IbisScripts/bot.sh "Mensaje de alerta"
```

Decisión de diseño: centralizar el envío en un único script garantiza que cualquier cambio de credenciales solo deba hacerse en un lugar.

### 2. guardian.sh — El Analista de Amenazas

Consulta el log del kernel a través de `auditd` para detectar comportamientos anómalos. El caso principal de uso es la detección de scraping (lectura masiva de archivos en un corto período de tiempo), que podría indicar un usuario explorando ficheros sensibles del servidor.

**Lógica de detección:**

```bash
# Cuenta cuántas veces se ejecutó 'cat' en el último minuto
CAT_BURST=$(sudo ausearch -k ibiscommands --start recent 2>/dev/null \
    | grep "exe=/bin/cat" | wc -l)

if [ "$CAT_BURST" -gt 15 ]; then
    bash "$BOT" "⚠️ ALERTA FISGÓN: ${CAT_BURST} lecturas detectadas en el último minuto."
fi
```

El umbral de 15 ejecuciones por minuto puede ajustarse según el perfil de uso normal del servidor.

**Prerequisito:** `auditd` debe estar instalado y activo con las reglas de vigilancia configuradas (ver sección Comandos Críticos de Configuración).

### 3. defensa.sh — El Brazo Ejecutor

Recibe órdenes parametrizadas y las ejecuta con privilegios de sistema. Está diseñado para ser invocado por n8n cuando el administrador aprueba una acción defensiva desde el móvil mediante Telegram.

| Acción        | Efecto                                                                 |
|---------------|------------------------------------------------------------------------|
| `bloquear <IP>` | Inserta una regla `deny` en UFW con prioridad máxima (posición 1) |
| `expulsar <usuario>` | Termina todas las sesiones activas del usuario con `pkill`       |
| `nuclear`     | Resetea completamente el firewall UFW                                  |

**Código clave (bloqueo de IP):**

```bash
case "$ACCION" in
    bloquear)
        sudo ufw insert 1 deny from "$OBJETO"
        bash "$BOT" "🛡️ IP BLOQUEADA: ${OBJETO} baneada en el Firewall."
        ;;
esac
```

Seguridad: el script valida el formato de IP antes de ejecutar cualquier regla de firewall, evitando inyecciones de comandos.

## Bloque 2: Monitorización y Dashboard

### 4. monitor.sh — Vigilante de Contenedores

Comprueba cada 5 minutos si los tres servicios principales del Campus están activos. Incorpora un sistema anti-spam con flags para evitar recibir una alerta por cada ejecución del cron cuando un servicio está caído: solo envía una notificación cuando el servicio cae, y otra cuando se recupera.

**Contenedor vigilado | Alias**

- `crisma_db` — Base de Datos PostgreSQL
- `crismaback` — Backend Node.js
- `ibis-campus-react` — Frontend React

**Lógica anti-spam:**

```bash
FLAG="/tmp/crimsa_flags/alerta_${NOMBRE}.flag"

if [ "$VIVO" -eq 0 ]; then
    if [ ! -f "$FLAG" ]; then       # Solo alerta la primera vez
        bash "$BOT" "🔴 CONTENEDOR CAÍDO: ${ALIAS}"
        touch "$FLAG"
    fi
else
    if [ -f "$FLAG" ]; then         # Alerta de recuperación al volver
        bash "$BOT" "✅ CONTENEDOR RECUPERADO: ${ALIAS}"
        rm -f "$FLAG"
    fi
fi
```

Los logs se guardan en:

```text
/mnt/TFG_CRIMSA/05_SISTEMA/LOGS/ibis_monitor.log
```

El archivo se rota automáticamente al superar las 1000 líneas, conservando siempre las 500 más recientes.

### 5. check_and_fix_db.sh — Autoreparación de Base de Datos

Si el contenedor `crisma_db` se apaga o Postgres deja de aceptar conexiones, este script lo detecta y ejecuta un reinicio automático. Es seguro ejecutarlo frecuentemente: un `docker restart` sobre Postgres no borra datos, solo interrumpe el proceso y lo reinicia (cualquier transacción activa recibe un rollback limpio).

**Flujo de ejecución:**

```text
pg_isready → ¿responde?
    ├── SÍ  → salida silenciosa (no hace nada)
    └── NO  → docker restart crisma_db → espera 5s → segunda verificación
                  ├── OK  → Telegram: "✅ Reiniciado y operativo"
                  └── KO  → Telegram: "🚨 CRÍTICO: intervención manual necesaria"
```

**Código clave:**

```bash
if ! docker exec crisma_db pg_isready -h localhost -U Crisma -q 2>/dev/null; then
    docker restart crisma_db
    sleep 5
    # Segunda verificación tras el reinicio...
fi
```

### 6. generar_dashboard.sh — Integración con el Frontend

Extrae el estado del sistema (disco del DAS de 4 TB, RAM disponible, estado de la base de datos) y lo vuelca en un archivo JSON que el Frontend React consume para mostrar el estado en tiempo real en el panel de administración.

**Código clave (generación de JSON):**

```bash
cat > "$SALIDA" << EOF
{
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "storage": {
    "total": "${DISK_TOTAL}",
    "used": "${DISK_USED}",
    "percent": ${DISK_PERC}
  },
  "ram": {
    "total_mb": ${RAM_TOTAL},
    "available_mb": ${RAM_DISP},
    "available_percent": ${RAM_PERC}
  },
  "database": "${DB_STATUS}"
}
EOF
```

El archivo de salida se ubica en:

```text
/mnt/TFG_CRIMSA/01_PROYECTO/CODIGO/frontend/public/estado_sistema.json
```

## Bloque 3: Mantenimiento y Backups

### 7. ejecutar_backup.sh — Respaldo Integral del Sistema

Genera una copia completa y verificada de todos los datos críticos del Campus Ibis. Cada ejecución crea una carpeta nueva con marca de tiempo, garantizando que nunca se sobreescriba un backup anterior.

**Estructura del backup generado:**

```text
/home/gerard/Backups/semanal_YYYYMMDD_HHMM/
├── db/
│   ├── danet_completo.sql     ← Volcado completo de la base de datos
│   ├── roles_globales.sql     ← Usuarios y roles de PostgreSQL
│   └── estadisticas.txt       ← Conteo de filas por tabla (verificación)
├── codigo/
│   └── backend/               ← Código fuente sin node_modules
├── uploads/                   ← Archivos entregados por alumnos
└── backup.log                 ← Log detallado de la ejecución
```

**Código clave (volcado seguro de la BD):**

```bash
# La contraseña se pasa como variable de entorno, nunca como argumento de línea de comandos
docker exec \
    -e PGPASSWORD="$DB_PASS" \
    "$DB_CONTAINER" \
    pg_dump -U "$DB_USER" --format=plain --no-owner --no-acl "$DB_NAME" \
    > "$DESTINO/db/danet_completo.sql"
```

Validación del dump: el script verifica que el archivo SQL contiene al menos un bloque `COPY` (indicador de que hay datos reales exportados). Si el conteo es 0, envía una alerta de fallo por Telegram.

**Política de retención:** se conservan los 5 backups más recientes. El sexto más antiguo se elimina automáticamente. Este número es configurable editando la línea:

```bash
ls -1dt /home/gerard/Backups/semanal_* | tail -n +6 | while read OLD; do rm -rf "$OLD"; done
```

### 8. restaurar_backup.sh — Restauración con Menú Interactivo

Permite restaurar la base de datos desde cualquier backup disponible mediante un menú numerado. Muestra el tamaño y las estadísticas guardadas de cada backup para facilitar la elección.

**Flujo de restauración:**

```text
Selección de backup (menú o argumento)
    → Validación del archivo SQL
    → Confirmación explícita ("escribe 'si' para continuar")
    → Cierre de conexiones activas a la BD
    → DROP + CREATE DATABASE
    → psql -f restore_danet.sql
    → Verificación final con conteo de filas
```

Advertencia: la restauración es destructiva. Borra y recrea completamente la base de datos `danet`. Usar siempre con confirmación deliberada.

## Comandos Críticos de Configuración

Esta sección documenta las configuraciones previas necesarias para que el sistema funcione correctamente.

### Vigilancia del Sistema con auditd

`auditd` es el demonio de auditoría del kernel Linux. Se instala y se configuran reglas para vigilar la carpeta del proyecto y detectar ejecuciones de comandos.

```bash
# Instalación
sudo apt install auditd -y
sudo systemctl enable --now auditd

# Escritura de reglas (requiere sudo tee, no redirección directa)
sudo tee /etc/audit/rules.d/ibis_security.rules << 'EOF'
# Vigilar ejecuciones de comandos en el directorio del proyecto
-w /mnt/TFG_CRIMSA/01_PROYECTO/ -p rwxa -k ibiscommands
# Vigilar llamadas execve (ejecución de procesos)
-a always,exit -F arch=b64 -S execve -k ibiscommands
EOF

# Aplicar las reglas sin reiniciar
sudo augenrules --load
sudo systemctl restart auditd
```

Error superado: intentar escribir las reglas con `cat >` o redirección directa daba error de permisos. La solución es usar `sudo tee` que escribe con privilegios elevados.

### Permisos de Ejecución Automática (visudo)

Para que n8n pueda invocar `defensa.sh` y aplicar bloqueos de firewall sin requerir la contraseña del usuario, se añade una excepción en sudoers:

```bash
sudo visudo
```

Añadir al final del archivo:

```text
gerard ALL=(ALL) NOPASSWD: /mnt/TFG_CRIMSA/01_PROYECTO/scripts/IbisScripts/defensa.sh
```

Principio de mínimo privilegio: solo se concede acceso sin contraseña a ese script específico, no a todos los comandos `sudo`.

### Arreglo de Permisos Docker para n8n

El contenedor de n8n fallaba al arrancar con error `EACCES` (acceso denegado) porque el directorio de datos pertenecía a `root` y el proceso interno del contenedor corre con UID 1000.

```bash
# Corregir la propiedad del directorio de datos de n8n
sudo chown -R 1000:1000 /mnt/TFG_CRIMSA/05_SISTEMA/n8n_data
```

Tras este cambio, el contenedor arranca sin errores de permisos.

### Notificación SSH Silenciosa

Se añade un script en `/etc/profile.d/` para recibir una alerta Telegram cada vez que un humano abre una sesión SSH interactiva. La condición `[[ $- == *i* ]]` filtra los procesos automáticos (`cron`, scripts no interactivos) y solo dispara la alerta cuando hay una terminal real activa.

```bash
sudo tee /etc/profile.d/ibis_notify.sh << 'EOF'
#!/bin/bash
# Solo actúa en sesiones interactivas reales (no en cron ni scripts)
[[ $- == *i* ]] || return

BOT="/mnt/TFG_CRIMSA/01_PROYECTO/scripts/IbisScripts/bot.sh"
USUARIO=$(whoami)
IP_ORIGEN=$(who am i | awk '{print $5}' | tr -d '()')
HORA=$(date "+%d/%m/%Y %H:%M")

bash "$BOT" "🔐 ACCESO SSH: ${USUARIO} ha iniciado sesión desde ${IP_ORIGEN} a las ${HORA}"
EOF

sudo chmod +x /etc/profile.d/ibis_notify.sh
```

### Automatización con Cron

Todos los scripts se ejecutan automáticamente mediante entradas en el crontab del usuario `gerard`:

```bash
crontab -e
```

Contenido:

```text
# ── Monitor de contenedores (cada 5 min) ──────────────────────
*/5 * * * * /bin/bash /mnt/TFG_CRIMSA/01_PROYECTO/scripts/playbook_crimsa.sh
*/5 * * * * /bin/bash /mnt/TFG_CRIMSA/01_PROYECTO/scripts/IbisScripts/monitor.sh

# ── Dashboard JSON de estado (cada 10 min) ────────────────────
*/10 * * * * /bin/bash /mnt/TFG_CRIMSA/01_PROYECTO/scripts/IbisScripts/generar_dashboard.sh

# ── Autoreparación DB (cada 15 min) ───────────────────────────
*/15 * * * * /bin/bash /mnt/TFG_CRIMSA/01_PROYECTO/scripts/IbisScripts/check_and_fix_db.sh

# ── Backup semanal (domingos a las 3:00 AM) ───────────────────
0 3 * * 0 /bin/bash /mnt/TFG_CRIMSA/01_PROYECTO/scripts/IbisScripts/ejecutar_backup.sh
```

| Script                                | Frecuencia       | Motivo |
|---------------------------------------|------------------|--------|
| `monitor.sh`                          | Cada 5 min       | Detección rápida de caídas de servicio |
| `generar_dashboard.sh`                | Cada 10 min      | El estado no necesita resolución en tiempo real |
| `check_and_fix_db.sh`                 | Cada 15 min      | Evita reinicios excesivos ante inestabilidad transitoria |
| `ejecutar_backup.sh`                  | Domingos 3 AM    | Momento de mínima actividad, frecuencia semanal suficiente |
