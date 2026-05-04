# Nginx Proxy Manager — Gestión de Tráfico y Seguridad

##  ¿Qué es un Reverse Proxy?

Un reverse proxy es el **portero de tu servidor**. Recibe las peticiones externas y las redirige internamente a los servicios correctos.

```
Cliente en Tailscale (100.107.56.81:443)
              ↓
      [Nginx Proxy Manager]
              ↓
     Decide a quién enviar...
        ↙    ↓    ↘
    Frontend Backend Nextcloud
```

Sin proxy, cada servicio necesitaría su propio puerto (3005, 8080, 8065...), lo cual es caótico.

---

##  Por Qué Nginx Proxy Manager

### Alternativas

| Opción | Ventajas | Inconvenientes |
|---|---|---|
| **Nginx Manual** | Total control | Editar archivos, reiniciar |
| **Traefik** | Moderno, automático | Curva de aprendizaje |
| **Nginx Proxy Manager** | Interfaz web, fácil | Menos flexible |

**Para Ibis:** Elegimos **Nginx Proxy Manager (NPM)** porque ofrece equilibrio entre facilidad y control.

---

##  Instalación de Nginx Proxy Manager

### Docker Compose

```yaml
version: '3.8'

services:
  nginx-proxy:
    image: 'jc21/nginx-proxy-manager:latest'
    container_name: global-proxy
    restart: unless-stopped
    ports:
      - '80:80'      # HTTP
      - '81:81'      # Panel Admin
      - '443:443'    # HTTPS
    volumes:
      - /mnt/TFG_CRIMSA/services/nginx_proxy/data:/data
      - /mnt/TFG_CRIMSA/services/nginx_proxy/letsencrypt:/etc/letsencrypt
    networks:
      - crisma_network

networks:
  crisma_network:
    driver: bridge
```

### Despliegue

```bash
cd /mnt/TFG_CRIMSA/services/
docker compose -f docker-compose-nginx.yml up -d

# Verificar
docker ps | grep global-proxy
```

---

##  Configuración Inicial

### Acceder al Panel

```
URL: http://100.107.56.81:81
Usuario: admin@example.com
Contraseña: changeme
```

### Cambiar Contraseña

 **CRÍTICO:** Cámbiala inmediatamente tras el primer login.

---

##  Crear Hosts Proxy

### Paso 1: Acceder a "Proxy Hosts"

En el panel de NPM: `Proxy Hosts` → `Add Proxy Host`

### Paso 2: Configurar para el Campus

| Campo | Valor |
|---|---|
| Domain Names | `ibis.local` |
| Scheme | `http` |
| Forward Hostname/IP | `crisma_front` |
| Forward Port | `8080` |
| Cache Assets |  Sí |

### Paso 3: Configurar SSL

Aunque usemos certificados autofirmados:
1. Click en tab "SSL"
2. Genera certificado autofirmado
3. Habilita "Force SSL"

### Configuración Avanzada Crítica

En la pestaña "Advanced", añade:

```nginx
proxy_connect_timeout 600s;
proxy_send_timeout 600s;
proxy_read_timeout 600s;
client_max_body_size 512M;

# Para WebSockets (necesario para chat)
proxy_http_version 1.1;
proxy_set_header Upgrade $http_upgrade;
proxy_set_header Connection "upgrade";
```

---

##  Configurar Subdominios (nip.io)

### ¿Qué es nip.io?

Un servicio de DNS dinámico gratuito que permite usar dominios basados en IP:

```
campus.100.107.56.81.nip.io
nube.100.107.56.81.nip.io
chat.100.107.56.81.nip.io
```

### Configuración en NPM

Crear 3 hosts proxy:

| Servicio | Dominio | Forward To |
|---|---|---|
| Frontend | `campus.100.107.56.81.nip.io` | `crisma_front:8080` |
| Nextcloud | `nube.100.107.56.81.nip.io` | `nextcloud:80` |
| Mattermost | `chat.100.107.56.81.nip.io` | `mattermost:8065` |

---

##  WebSockets — Crítico para Chat

Mattermost envía mensajes en tiempo real usando WebSockets. Sin configurar esto correctamente, los mensajes no aparecen hasta refrescar.

### Problema

```
Mensaje enviado ← Cliente
                ↓
          Nginx bloquea
                ↓
        Conexión persistente muere
```

### Solución

En cada host proxy de Mattermost:
1. Tab "Advanced"
2. Añade los headers:

```nginx
proxy_http_version 1.1;
proxy_set_header Upgrade $http_upgrade;
proxy_set_header Connection "upgrade";
```

### Verificación

Los mensajes deben aparecer instantáneamente, sin refrescar.

---

##  Aumentar Límite de Subida

### Problema

Intenta subir un archivo de 100 MB a Nextcloud → Error "413 Request Entity Too Large"

### Solución

En la configuración avanzada del host Nextcloud:

```nginx
client_max_body_size 512M;
```

---

##  Certificados SSL

### Para Desarrollo (Autofirmados)

NPM puede generar certificados autofirmados:
1. Tab "SSL"
2. "Generate Self Signed"
3. Marca "Force SSL"

El navegador mostrará advertencia, pero la conexión está cifrada.

### Para Producción (Let's Encrypt)

Si abrierás al público (no recomendado):

1. Tab "SSL"
2. "Request a new SSL Certificate"
3. Ingresa email y dominio
4. Let's Encrypt genera automáticamente

---

##  Problemas Comunes y Soluciones

### Error 502 Bad Gateway

**Síntoma:** "Bad Gateway" al acceder a un host

**Causas posibles:**
1. El contenedor backend está apagado
2. IP/puerto incorrecto en la configuración
3. Problema de red entre contenedores

**Solución:**

```bash
# Verificar que el contenedor está UP
docker ps | grep crisma_front

# Verificar conectividad
docker exec global-proxy ping crisma_front

# Ver logs del proxy
docker logs global-proxy
```

### WebSockets no funcionan (Chat congelado)

**Síntoma:** Mensajes en Mattermost no aparecen sin refrescar

**Causa:** Faltan headers de WebSocket en la configuración

**Solución:** Añade en "Advanced":

```nginx
proxy_http_version 1.1;
proxy_set_header Upgrade $http_upgrade;
proxy_set_header Connection "upgrade";
```

### Límite de subida rechaza archivos grandes

**Síntoma:** "413 Request Entity Too Large"

**Solución:** Aumenta en "Advanced":

```nginx
client_max_body_size 512M;
```

---

##  Configuración Completa de Ejemplo

```nginx
# Para el Campus (Frontend)
upstream crisma_frontend {
    server crisma_front:8080;
}

server {
    listen 80;
    listen 443 ssl;
    server_name ibis.local campus.100.107.56.81.nip.io;
    
    client_max_body_size 512M;
    proxy_connect_timeout 600s;
    
    location / {
        proxy_pass http://crisma_frontend;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
    
    location /api/ {
        proxy_pass http://crisma_back:3005/api/;
        proxy_set_header Host $host;
    }
}

# Para Mattermost (Chat)
upstream mattermost_backend {
    server mattermost:8065;
}

server {
    listen 80;
    listen 443 ssl;
    server_name chat.100.107.56.81.nip.io;
    
    location / {
        proxy_pass http://mattermost_backend;
        proxy_set_header Host $host;
        
        # WebSockets
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
    }
}
```

---

## ¡ Verificación

Accede a cada servicio:

```bash
# Campus
curl -I http://100.107.56.81/

# Nextcloud
curl -I http://100.107.56.81/nube.ibis.local/

# Mattermost
curl -I http://100.107.56.81/chat/

# Verificar WebSockets en Mattermost
# Abre la consola del navegador (F12)
# Ve a "Network" → "WS" (WebSocket)
# Debería mostrar una conexión ws:// activa
```

---

##  Siguientes Pasos

1. Lee: `05-servicios/00-authentik-sso.md` para autenticación centralizada
2. Lee: `05-servicios/01-nextcloud-almacenamiento.md` para almacenamiento
3. Practica: Crea un proxy host en NPM

---

**Tiempo de lectura:** 30 minutos  
**Experiencia requerida:** Intermedio  
**Verificación:** `docker logs -f global-proxy` mientras pruebas
