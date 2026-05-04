#!/bin/bash
# monitor.sh - Vigilancia de contenedores Docker

BOT="/mnt/TFG_CRIMSA/01_PROYECTO/scripts/IbisScripts/bot.sh"
LOG_FILE="/mnt/TFG_CRIMSA/05_LOGS/ibis_monitor.log"

# Crear directorio de flags si no existe
mkdir -p /tmp/crimsa_flags

# Contenedores a vigilar
declare -A CONTENEDORES=(
    ["crisma_db"]="🗄️  PostgreSQL"
    ["crisma_back"]="🔌 Backend API"
    ["crisma_front"]="🎨 Frontend React"
)

echo "[$(date '+%Y-%m-%d %H:%M:%S')] === Inicio de monitorización ===" >> "$LOG_FILE"

for CONTENEDOR in "${!CONTENEDORES[@]}"; do
    ALIAS="${CONTENEDORES[$CONTENEDOR]}"
    FLAG="/tmp/crimsa_flags/alerta_${CONTENEDOR}.flag"
    
    # Verificar si el contenedor está corriendo
    if docker inspect "$CONTENEDOR" > /dev/null 2>&1; then
        ESTADO=$(docker inspect -f '{{.State.Running}}' "$CONTENEDOR")
        
        if [ "$ESTADO" = "true" ]; then
            # Contenedor está UP
            if [ -f "$FLAG" ]; then
                # Se había caído, ahora se recuperó
                bash "$BOT" " RECUPERADO: ${ALIAS} está operativo nuevamente"
                echo "[$(date '+%Y-%m-%d %H:%M:%S')] ✅ ${ALIAS} recuperado" >> "$LOG_FILE"
                rm -f "$FLAG"
            fi
        else
            # Contenedor está DOWN
            if [ ! -f "$FLAG" ]; then
                bash "$BOT" " CAÍDA DETECTADA: ${ALIAS} no está respondiendo"
                echo "[$(date '+%Y-%m-%d %H:%M:%S')]  ${ALIAS} caído" >> "$LOG_FILE"
                touch "$FLAG"
            fi
        fi
    else
        # Contenedor no existe
        if [ ! -f "$FLAG" ]; then
            bash "$BOT" "  CRÍTICO: ${ALIAS} no encontrado"
            echo "[$(date '+%Y-%m-%d %H:%M:%S')]   ${ALIAS} no existe" >> "$LOG_FILE"
            touch "$FLAG"
        fi
    fi
done

# Rotación de logs (mantener últimas 500 líneas)
if [ -f "$LOG_FILE" ]; then
    LINEAS=$(wc -l < "$LOG_FILE")
    if [ "$LINEAS" -gt 1000 ]; then
        tail -500 "$LOG_FILE" > "${LOG_FILE}.tmp"
        mv "${LOG_FILE}.tmp" "$LOG_FILE"
    fi
fi

echo " Monitorización completada"
