# Backups y Restauración — Copias de Seguridad

##  Qué se Respalda

- Base de datos PostgreSQL (danet)
- Código fuente (backend + frontend)
- Archivos subidos por alumnos
- Configuraciones de servicios

##  Ubicación

`/home/gerard/Backups/semanal_YYYYMMDD_HHMM/`

## Frecuencia

- **Semanal:** Domingos 3:00 AM
- **Retención:** Últimos 5 backups

## Restaurar

```bash
/mnt/TFG_CRIMSA/01_PROYECTO/scripts/IbisScripts/restaurar_backup.sh
```

Muestra menú de backups disponibles.

