#!/bin/bash
# check_and_fix_db.sh - Auto-reparación de PostgreSQL

BOT="/mnt/TFG_CRIMSA/01_PROYECTO/scripts/IbisScripts/bot.sh"
DB_CONTAINER="crisma_db"
LOG_FILE="/mnt/TFG_CRIMSA/05_LOGS/db_check.log"

echo "[$(date)] Iniciando verificación de BD..." >> "$LOG_FILE"

# Verificar si el contenedor está corriendo
if ! docker ps | grep -q "$DB_CONTAINER"; then
    echo " [$(date)] Contenedor $DB_CONTAINER no está corriendo" >> "$LOG_FILE"
    bash "$BOT" " CRÍTICO: PostgreSQL no está en ejecución"
    exit 1
fi

# Verificar si PostgreSQL responde
if ! docker exec "$DB_CONTAINER" pg_isready -h localhost -U Crisma -q 2>/dev/null; then
    echo "  [$(date)] PostgreSQL no responde, reiniciando..." >> "$LOG_FILE"
    bash "$BOT" "  PostgreSQL bloqueado, intentando reinicio..."
    
    docker restart "$DB_CONTAINER"
    sleep 5
    
    # Segunda verificación
    if docker exec "$DB_CONTAINER" pg_isready -h localhost -U Crisma -q 2>/dev/null; then
        echo " [$(date)] PostgreSQL reiniciado y operativo" >> "$LOG_FILE"
        bash "$BOT" " PostgreSQL reiniciado exitosamente"
    else
        echo " [$(date)] FALLO: PostgreSQL sigue sin responder" >> "$LOG_FILE"
        bash "$BOT" " CRÍTICO: PostgreSQL sigue sin responder tras reinicio. Intervención manual necesaria."
        exit 1
    fi
else
    echo " [$(date)] PostgreSQL operativo y respondiendo" >> "$LOG_FILE"
fi
