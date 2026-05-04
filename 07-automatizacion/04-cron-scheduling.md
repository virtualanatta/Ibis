# Cron Scheduling — Tareas Programadas

##  Tabla de Cron Actual

```bash
# Monitor cada 5 min
*/5 * * * * /bin/bash monitor.sh

# Dashboard cada 10 min
*/10 * * * * /bin/bash generar_dashboard.sh

# Check BD cada 15 min
*/15 * * * * /bin/bash check_and_fix_db.sh

# Backup semanal (dom 3 AM)
0 3 * * 0 /bin/bash ejecutar_backup.sh

# Limpiar backups antiguos (dom 4 AM)
0 4 * * 0 /bin/bash limpiar_backups.sh
```

## Editar Cron

```bash
crontab -e
```

## Ver Logs de Cron

```bash
grep CRON /var/log/syslog
```

