# n8n — Automatización y Workflows

##  ¿Qué es n8n?

Plataforma de automatización que permite:
- Crear workflows visuales
- Conectar servicios (Webhook, API, etc.)
- Automatizar tareas repetitivas
- Reaccionar a eventos

##  Despliegue

```bash
docker run -d \
  --name n8n_ibis \
  -p 5678:5678 \
  -v /mnt/TFG_CRIMSA/services/n8n:/home/node/.n8n \
  n8nio/n8n
```

##  Workflows Disponibles

1. **Validar-login** — Bridge bcrypt PostgreSQL
2. **Crear-buzón** — Mailcow + Mattermost
3. **Notificar-material** — Anuncios automáticos
4. **Filtro-lenguaje** — Moderación de chat

##  Webhooks

Cada workflow expone un endpoint:

```
POST http://100.107.56.81:5678/webhook/crear-buzon
POST http://100.107.56.81:5678/webhook/validar-login
```

