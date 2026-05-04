# Mattermost — Plataforma de Comunicación en Tiempo Real

##  ¿Qué es Mattermost?

Una plataforma de **chat institucional privada** estilo Slack con:
- Canales por tema/asignatura
- Mensajería privada
- Compartir archivos
- Integraciones (webhooks, bots)

---

##  Instalación Rápida

### docker-compose.yml

```yaml
version: '3'
services:
  db-mattermost:
    image: postgres:13-alpine
    container_name: db_mattermost
    restart: always
    environment:
      POSTGRES_USER: mmuser
      POSTGRES_PASSWORD: cambiar_esto
      POSTGRES_DB: mattermost
    volumes:
      - /mnt/TFG_CRIMSA/services/mattermost/db:/var/lib/postgresql/data

  mattermost:
    image: mattermost/mattermost-team-edition:latest
    container_name: sphynxchat
    restart: always
    depends_on:
      - db-mattermost
    environment:
      MM_SQLSETTINGS_DRIVERNAME: postgres
      MM_SQLSETTINGS_DATASOURCE: postgres://mmuser:cambiar_esto@db-mattermost:5432/mattermost?sslmode=disable
      MM_SERVICESETTINGS_SITEURL: http://100.107.56.81:8065
    volumes:
      - /mnt/TFG_CRIMSA/services/mattermost/config:/mattermost/config
      - /mnt/TFG_CRIMSA/services/mattermost/data:/mattermost/data
      - /mnt/TFG_CRIMSA/services/mattermost/logs:/mattermost/logs
```

### Despliegue

```bash
docker compose up -d
docker compose logs -f mattermost  # Esperar a que esté UP
```

---

##  Configuración Inicial

### Acceder

```
URL: http://100.107.56.81:8065
```

Crea cuenta de administrador en el primer acceso.

### Crear Equipo

1. **Panel Admin** → **Teams** → **Create Team**
2. Nombre: "CRIMSA"
3. Tipo: Abierto (para que todos puedan unirse)

### Crear Canales

Para ASIR 2:

```
- general
- seguridad
- servicios-red
- administracion-so
- anuncios
- preguntas
```

### Agregar Usuarios

1. **Panel Admin** → **Users**
2. **Invite Users**
3. Correos separados por comas

---

##  Limitaciones de la Versión Team

 **Importante:** Mattermost Team Edition (gratuita) tiene limitaciones:

| Función | Disponible |
|---|---|
| OAuth 2.0 genérico |  No |
| Tokens PAT de sistema |  No |
| Bots cuenta sistema |  No |
| WebSockets |  Sí |
| Canales públicos/privados |  Sí |

**Solución:** Usar webhooks entrantes para notificaciones desde n8n.

---

##  Crear Bot con Incoming Webhook

### Paso 1: Generar Webhook

1. **Admin Console** → **Integrations** → **Incoming Webhooks**
2. **Add Incoming Webhook**
3. Channel: #anuncios
4. Copiar URL (ej: `http://100.107.56.81:8065/hooks/xxxxx`)

### Paso 2: Usar desde n8n o Backend

```bash
curl -X POST http://100.107.56.81:8065/hooks/xxxxx \
  -H 'Content-Type: application/json' \
  -d '{"text":"Nueva tarea publicada"}'
```

---

##  Problemas Comunes

### Permisos UID 2000

**Síntoma:** Error de escritura en configuración

**Solución:**

```bash
sudo chown -R 2000:2000 /mnt/TFG_CRIMSA/services/mattermost/
```

### WebSockets Bloqueados

**Síntoma:** Mensajes no aparecen sin refrescar

**Causa:** Nginx sin soporte WebSocket

**Solución:** En la configuración de Nginx (NPM):

```nginx
proxy_http_version 1.1;
proxy_set_header Upgrade $http_upgrade;
proxy_set_header Connection "upgrade";
```

### Contraseña Débil

**Síntoma:** `INVALID_PASSWORD` al crear usuario

**Solución:** Usar contraseña > 8 caracteres con mayúsculas, minúsculas, números

---

##  Siguientes Pasos

1. Crea 3 canales de prueba
2. Invita alumnos
3. Publica un mensaje
4. Verifica WebSockets (F12 → Network → WS)

---

**Tiempo de lectura:** 15 minutos  
**Experiencia requerida:** Principiante  
**Verificación:** `docker logs sphynxchat | grep "Listening"`
