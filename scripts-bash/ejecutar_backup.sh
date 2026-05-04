#!/bin/bash
# ejecutar_backup.sh - Backup automático de BD y datos

DB_CONTAINER="crisma_db"
DB_USER="Crisma"
DB_PASSWORD="Ucq8Oal7g4zN"
DB_NAME="danet"
DESTINO="/home/gerard/Backups/semanal_$(date +%Y%m%d_%H%M)"
BOT="/mnt/TFG_CRIMSA/01_PROYECTO/scripts/IbisScripts/bot.sh"

# Crear directorio
mkdir -p "$DESTINO/db"
mkdir -p "$DESTINO/codigo"
mkdir -p "$DESTINO/uploads"

LOG="$DESTINO/backup.log"

echo " Iniciando backup en $(date '+%Y-%m-%d %H:%M:%S')" > "$LOG"

# 1. Backup de PostgreSQL
echo " Volcando base de datos..." >> "$LOG"
docker exec \
    -e PGPASSWORD="$DB_PASSWORD" \
    "$DB_CONTAINER" \
    pg_dump -U "$DB_USER" --format=plain --no-owner --no-acl "$DB_NAME" \
    > "$DESTINO/db/${DB_NAME}_completo.sql"

if [ $? -ne 0 ]; then
    echo " Error en volcado de BD" >> "$LOG"
    bash "$BOT" " BACKUP FALLIDO: Error al volcar PostgreSQL"
    exit 1
fi

# Validar que el dump tiene datos
SQL_SIZE=$(wc -c < "$DESTINO/db/${DB_NAME}_completo.sql")
if [ "$SQL_SIZE" -lt 10000 ]; then
    echo "  Archivo SQL muy pequeño, posible error" >> "$LOG"
    bash "$BOT" "  ALERTA: Backup de BD muy pequeño, verificar"
fi

# 2. Backup de roles
echo " Exportando roles..." >> "$LOG"
docker exec -e PGPASSWORD="$DB_PASSWORD" "$DB_CONTAINER" \
    pg_dumpall -U "$DB_USER" --roles-only > "$DESTINO/db/roles_globales.sql"

# 3. Estadísticas
echo " Generando estadísticas..." >> "$LOG"
docker exec -e PGPASSWORD="$DB_PASSWORD" "$DB_CONTAINER" \
    psql -U "$DB_USER" -d "$DB_NAME" -c "
    SELECT tablename, pg_size_pretty(pg_total_relation_size(tablename::regclass)) as size
    FROM pg_tables WHERE schemaname = 'public' ORDER BY pg_total_relation_size(tablename::regclass) DESC;
    " > "$DESTINO/db/estadisticas.txt"

# 4. Backup de código
echo " Copiando código fuente..." >> "$LOG"
cp -r /mnt/TFG_CRIMSA/01_PROYECTO/CODIGO/backend "$DESTINO/codigo/" 2>/dev/null
cp -r /mnt/TFG_CRIMSA/01_PROYECTO/CODIGO/frontend "$DESTINO/codigo/" 2>/dev/null

# 5. Backup de uploads
echo " Copiando archivos de alumnos..." >> "$LOG"
if [ -d "/mnt/TFG_CRIMSA/uploads" ]; then
    cp -r /mnt/TFG_CRIMSA/uploads/* "$DESTINO/uploads/" 2>/dev/null
fi

# 6. Rotación: eliminar backups más viejos (mantener 5)
echo "🗑️  Limpiando backups antiguos..." >> "$LOG"
ls -1dt /home/gerard/Backups/semanal_* | tail -n +6 | while read OLD; do
    rm -rf "$OLD"
    echo "  Eliminado: $OLD" >> "$LOG"
done

echo " Backup completado en $(date '+%Y-%m-%d %H:%M:%S')" >> "$LOG"
echo " Ubicación: $DESTINO" >> "$LOG"

TAMAÑO=$(du -sh "$DESTINO" | awk '{print $1}')
bash "$BOT" " BACKUP SEMANAL COMPLETADO\n Tamaño: $TAMAÑO\n Ubicación: $DESTINO"
