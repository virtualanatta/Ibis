# IbisScripts — Sistema de Automatización

##  Qué son los IbisScripts

Scripts Bash que automatizan:
- Monitorización de contenedores
- Backups diarios
- Alertas por Telegram
- Mantenimiento de bases de datos

Ubicación: `/mnt/TFG_CRIMSA/01_PROYECTO/scripts/IbisScripts/`

## Estructura

```
bot.sh                  — Núcleo de notificaciones
monitor.sh              — Vigila contenedores
check_and_fix_db.sh     — Auto-reparación de BD
generar_dashboard.sh    — Datos para el frontend
ejecutar_backup.sh      — Copias de seguridad
limpiar_backups.sh      — Elimina backups viejos
```

## Ejecución con Cron

```bash
*/5 * * * * /bin/bash /mnt/TFG_CRIMSA/01_PROYECTO/scripts/IbisScripts/monitor.sh
0 3 * * 0 /bin/bash /mnt/TFG_CRIMSA/01_PROYECTO/scripts/IbisScripts/ejecutar_backup.sh
```

