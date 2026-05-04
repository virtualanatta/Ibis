#!/bin/bash
# generar_dashboard.sh - Generador de datos para dashboard

SALIDA="/mnt/TFG_CRIMSA/01_PROYECTO/CODIGO/frontend/public/estado_sistema.json"
LOG_FILE="/mnt/TFG_CRIMSA/05_LOGS/dashboard.log"

echo "[$(date '+%Y-%m-%d %H:%M:%S')] Generando estado del sistema..." >> "$LOG_FILE"

# Extraer datos del sistema
TIMESTAMP=$(date -u +%Y-%m-%dT%H:%M:%SZ)
DISK_TOTAL=$(df /mnt/TFG_CRIMSA | tail -1 | awk '{print $2}')
DISK_USED=$(df /mnt/TFG_CRIMSA | tail -1 | awk '{print $3}')
DISK_PERC=$(df /mnt/TFG_CRIMSA | tail -1 | awk '{print $5}' | sed 's/%//')

RAM_TOTAL=$(free -m | awk '/^Mem:/{print $2}')
RAM_DISP=$(free -m | awk '/^Mem:/{print $7}')
RAM_PERC=$((RAM_DISP * 100 / RAM_TOTAL))

# Verificar estado de la base de datos
if docker exec crisma_db pg_isready -h localhost -U Crisma -q 2>/dev/null; then
    DB_STATUS="operational"
    TABLAS=$(docker exec -e PGPASSWORD=Ucq8Oal7g4zN crisma_db psql -U Crisma -d danet -c "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema='public';" -t 2>/dev/null | xargs)
else
    DB_STATUS="down"
    TABLAS="0"
fi

# Generar JSON
cat > "$SALIDA" << EOJSON
{
  "timestamp": "$TIMESTAMP",
  "storage": {
    "total_mb": $((DISK_TOTAL / 1024)),
    "used_mb": $((DISK_USED / 1024)),
    "percent": $DISK_PERC
  },
  "ram": {
    "total_mb": $RAM_TOTAL,
    "available_mb": $RAM_DISP,
    "available_percent": $RAM_PERC
  },
  "database": {
    "status": "$DB_STATUS",
    "tables_count": $TABLAS
  }
}
EOJSON

echo " [$(date '+%Y-%m-%d %H:%M:%S')] Dashboard generado exitosamente" >> "$LOG_FILE"
