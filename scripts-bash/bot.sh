#!/bin/bash
# bot.sh - Núcleo de notificaciones por Telegram

# Cargar credenciales de forma segura
if [ ! -f "$HOME/.config/crimsa/env" ]; then
    echo "❌ Archivo de configuración no encontrado: $HOME/.config/crimsa/env"
    exit 1
fi

source "$HOME/.config/crimsa/env"

# Validar variables
if [ -z "$TELEGRAM_TOKEN" ] || [ -z "$ID_CHAT" ]; then
    echo "❌ TELEGRAM_TOKEN o ID_CHAT no configurados"
    exit 1
fi

# Mensaje a enviar (pasado como argumento)
MENSAJE="$1"

# Enviar a Telegram
curl -s -X POST "https://api.telegram.org/bot${TELEGRAM_TOKEN}/sendMessage" \
    -d "chat_id=${ID_CHAT}" \
    --data-urlencode "text=${MENSAJE}" > /dev/null 2>&1

if [ $? -eq 0 ]; then
    echo "✅ Notificación enviada a Telegram"
else
    echo "❌ Error al enviar notificación"
    exit 1
fi
