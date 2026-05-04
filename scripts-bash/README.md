#  Scripts Bash — Automatización Ibis Campus

##  Contenido

Este directorio contiene todos los scripts operacionales de Ibis Campus, listos para usar.

### Scripts Principales

#### 1. **bot.sh** — Núcleo de Notificaciones
Envía alertas a Telegram de forma centralizada.

```bash
bash bot.sh " Nuevo acceso SSH desde 192.168.1.100"
```

**Requisitos:**
- Archivo de configuración: `~/.config/crimsa/env`
- Variables: `TELEGRAM_TOKEN`, `ID_CHAT`

---

#### 2. **monitor.sh** — Vigilancia de Contenedores
Vigila 3 contenedores clave cada 5 minutos.

```bash
# Cron: */5 * * * * /bin/bash /path/to/monitor.sh
```

**Vigila:**
- `crisma_db` — PostgreSQL
- `crisma_back` — Backend Node.js
- `crisma_front` — Frontend React

**Características:**
- Anti-spam: solo alerta en cambios de estado
- Logs automáticos en `/mnt/TFG_CRIMSA/05_LOGS/ibis_monitor.log`

---

#### 3. **check_and_fix_db.sh** — Auto-Reparación PostgreSQL
Detecta y reinicia PostgreSQL si no responde.

```bash
# Cron: */15 * * * * /bin/bash /path/to/check_and_fix_db.sh
```

**Flujo:**
1. Verifica si contenedor está corriendo
2. Si está UP, verifica si PostgreSQL responde (`pg_isready`)
3. Si no responde → reinicia contenedor
4. Segunda verificación post-reinicio
5. Notifica por Telegram

---

#### 4. **generar_dashboard.sh** — Datos del Dashboard
Genera JSON con estado del sistema para el frontend.

```bash
# Cron: */10 * * * * /bin/bash /path/to/generar_dashboard.sh
```

**Genera en:**
```
/mnt/TFG_CRIMSA/01_PROYECTO/CODIGO/frontend/public/estado_sistema.json
```

**Datos:**
- Uso de disco (DAS 4TB)
- Memoria RAM disponible
- Estado de PostgreSQL
- Conteo de tablas en BD

---

#### 5. **ejecutar_backup.sh** — Backup Integral
Realiza copias completas y verificadas del sistema.

```bash
# Cron: 0 3 * * 0 /bin/bash /path/to/ejecutar_backup.sh
# Ejecución: Domingos 3:00 AM
```

**Respalda:**
- PostgreSQL completo (volcado SQL)
- Roles y usuarios de BD
- Código fuente (backend + frontend)
- Archivos de alumnos

**Salida:**
```
/home/gerard/Backups/semanal_YYYYMMDD_HHMM/
├── db/
│   ├── danet_completo.sql
│   ├── roles_globales.sql
│   └── estadisticas.txt
├── codigo/
│   ├── backend/
│   └── frontend/
├── uploads/
│   └── [archivos alumnos]
└── backup.log
```

**Rotación:** Mantiene últimos 5 backups

---

#### 6. **limpiar_backups.sh** — Mantenimiento
Elimina backups más antiguos de 30 días.

```bash
# Cron: 0 4 * * 0 /bin/bash /path/to/limpiar_backups.sh
# Ejecución: Domingos 4:00 AM
```

---

##  Instalación y Configuración

### 1. Crear Directorio de Scripts

```bash
sudo mkdir -p /mnt/TFG_CRIMSA/01_PROYECTO/scripts/IbisScripts
cd /mnt/TFG_CRIMSA/01_PROYECTO/scripts/IbisScripts
```

### 2. Copiar Scripts

```bash
# Desde este repositorio
cp bot.sh monitor.sh check_and_fix_db.sh generar_dashboard.sh ejecutar_backup.sh limpiar_backups.sh /mnt/TFG_CRIMSA/01_PROYECTO/scripts/IbisScripts/

# Hacer ejecutables
chmod +x /mnt/TFG_CRIMSA/01_PROYECTO/scripts/IbisScripts/*.sh
```

### 3. Configurar Credenciales Telegram

```bash
mkdir -p ~/.config/crimsa
cat << 'ENV' > ~/.config/crimsa/env
TELEGRAM_TOKEN="tu_token_aqui"
ID_CHAT="tu_chat_id_aqui"
ENV

chmod 600 ~/.config/crimsa/env
```

### 4. Configurar Cron Jobs

```bash
crontab -e
```

Añade estas líneas:

```bash
# Monitor de contenedores (cada 5 min)
*/5 * * * * /bin/bash /mnt/TFG_CRIMSA/01_PROYECTO/scripts/IbisScripts/monitor.sh

# Dashboard JSON (cada 10 min)
*/10 * * * * /bin/bash /mnt/TFG_CRIMSA/01_PROYECTO/scripts/IbisScripts/generar_dashboard.sh

# Check y reparación BD (cada 15 min)
*/15 * * * * /bin/bash /mnt/TFG_CRIMSA/01_PROYECTO/scripts/IbisScripts/check_and_fix_db.sh

# Backup semanal (domingos 3 AM)
0 3 * * 0 /bin/bash /mnt/TFG_CRIMSA/01_PROYECTO/scripts/IbisScripts/ejecutar_backup.sh

# Limpieza de backups (domingos 4 AM)
0 4 * * 0 /bin/bash /mnt/TFG_CRIMSA/01_PROYECTO/scripts/IbisScripts/limpiar_backups.sh
```

### 5. Verificar Ejecución

```bash
# Probar bot
bash bot.sh "🧪 Test: Scripts funcionando correctamente"

# Ver logs
tail -f /mnt/TFG_CRIMSA/05_LOGS/*.log

# Ver estado cron
grep CRON /var/log/syslog | tail -20
```

---

##  Variables Configurables

Edita estos valores según tu entorno:

### bot.sh
```bash
source "$HOME/.config/crimsa/env"  # Archivo de credenciales
```

### monitor.sh
```bash
# Contenedores a vigilar (modificar según tu setup)
declare -A CONTENEDORES=(
    ["crisma_db"]="  PostgreSQL"
    ["crisma_back"]=" Backend API"
    ["crisma_front"]=" Frontend React"
)
```

### check_and_fix_db.sh
```bash
DB_CONTAINER="crisma_db"      # Nombre del contenedor
DB_USER="Crisma"              # Usuario PostgreSQL
DB_PASSWORD="Ucq8Oal7g4zN"    # Contraseña (cambiar en producción)
DB_NAME="danet"               # Nombre de BD
```

### generar_dashboard.sh
```bash
SALIDA="/mnt/TFG_CRIMSA/01_PROYECTO/CODIGO/frontend/public/estado_sistema.json"
```

### ejecutar_backup.sh
```bash
DESTINO="/home/gerard/Backups/semanal_$(date +%Y%m%d_%H%M)"
```

---

## 🚨 Troubleshooting

### Los scripts no se ejecutan

```bash
# Verificar permisos
ls -l /mnt/TFG_CRIMSA/01_PROYECTO/scripts/IbisScripts/*.sh

# Hacer ejecutables si no lo son
chmod +x /mnt/TFG_CRIMSA/01_PROYECTO/scripts/IbisScripts/*.sh

# Probar manualmente
bash /mnt/TFG_CRIMSA/01_PROYECTO/scripts/IbisScripts/bot.sh "Test"
```

### Telegram no envía notificaciones

```bash
# Verificar configuración
cat ~/.config/crimsa/env

# Probar curl directamente
curl -X POST "https://api.telegram.org/botTOKEN/sendMessage" \
  -d "chat_id=CHAT_ID" \
  -d "text=Test"
```

### Cron jobs no se ejecutan

```bash
# Ver cron jobs configurados
crontab -l

# Ver logs de cron
sudo tail -100 /var/log/syslog | grep CRON

# Verificar que el usuario tiene permisos
sudo -l
```

---

##  Monitoreo de Ejecución

Ver logs en tiempo real:

```bash
# Monitor
tail -f /mnt/TFG_CRIMSA/05_LOGS/ibis_monitor.log

# Dashboard
tail -f /mnt/TFG_CRIMSA/05_LOGS/dashboard.log

# Backups
tail -f /mnt/TFG_CRIMSA/05_LOGS/db_check.log

# Limpieza
tail -f /mnt/TFG_CRIMSA/05_LOGS/limpieza_backups.log
```

---

##  Seguridad

-  Nunca guardar credenciales en el código
-  Usar `~/.config/crimsa/env` con permisos 600
-  Auditar logs regularmente
-  Hacer backups criptografiados fuera del servidor

---

**¡Scripts listos para producción! **
