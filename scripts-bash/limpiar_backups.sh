#!/bin/bash
# limpiar_backups.sh - Rotación y limpieza de backups viejos

RUTA_BACKUPS="/home/gerard/Backups"
DIAS=30
LOG_LIMPIEZA="/mnt/TFG_CRIMSA/05_LOGS/limpieza_backups.log"

{
    echo "=== Limpieza de backups $(date) ==="
    echo "Buscando backups más antiguos de $DIAS días en $RUTA_BACKUPS"
    
    # Encontrar y eliminar
    ELIMINADOS=0
    while IFS= read -r -d '' DIR; do
        echo "  Eliminando: $(basename "$DIR")"
        rm -rf "$DIR"
        ((ELIMINADOS++))
    done < <(find "$RUTA_BACKUPS" -maxdepth 1 -type d -name "semanal_*" -mtime +$DIAS -print0)
    
    echo " Limpieza completada: $ELIMINADOS directorios eliminados"
    
    # Mostrar backups restantes
    echo ""
    echo "Backups restantes:"
    ls -lhd "$RUTA_BACKUPS"/semanal_* 2>/dev/null | tail -5
    
} | tee -a "$LOG_LIMPIEZA"
