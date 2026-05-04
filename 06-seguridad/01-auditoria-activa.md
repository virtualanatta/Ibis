# Auditoría Activa — Bot Telegram y Alertas

##  Sistema de Notificaciones en Tiempo Real

Cada acceso al servidor dispara una alerta instantánea a Telegram del administrador.

### Instalación del Bot

1. Busca `@BotFather` en Telegram
2. Crea bot nuevo: `/newbot`
3. Obtén token: `XXXXXXXXXX:AAG...`
4. Busca `@userinfobot` para obtener tu Chat ID
5. Guarda en `/home/gerard/.config/crimsa/env`

### Script de Notificación

```bash
#!/bin/bash
TOKEN="tu_token_aqui"
CHAT_ID="tu_chat_id"
USUARIO=$(whoami)
IP=$(echo $SSH_CONNECTION | awk '{print $1}')
HORA=$(date "+%d/%m/%Y %H:%M")

curl -s -X POST "https://api.telegram.org/bot${TOKEN}/sendMessage" \
  -d "chat_id=${CHAT_ID}" \
  --data-urlencode "text=🔐 SSH LOGIN\nUser: ${USUARIO}\nIP: ${IP}\nTiempo: ${HORA}"
```

### Integración con /etc/profile

Añade al final:

```bash
[[ $- == *i* ]] && /usr/local/bin/notificar_ssh.sh
```

---

##  Logs de Auditoría

### Archivo de Registro

`/mnt/TFG_CRIMSA/05_LOGS/historial_conexiones.log`

Contiene: Timestamp, Usuario, IP, Estado del DAS

### Inmutabilidad de Logs

```bash
sudo chattr +a /mnt/TFG_CRIMSA/05_LOGS/*.log
```

El flag `+a` permite escritura pero no borrado.

---

##  Futuros: IA para Análisis

Idea: Usar n8n + Ollama/Phi-3 para analizar logs automáticamente.

