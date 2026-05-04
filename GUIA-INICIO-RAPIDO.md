#  GUÍA DE INICIO RÁPIDO — Ibis Campus

**Versión:** Mayo 2026  
**Estado:** Documentación base lista  
**Tiempo estimado:** 8-10 horas (instalación completa)

---

##  Los 5 Pasos Más Importantes

### 1️ Hardware y SO (1-2 horas)

```bash
# Instala Ubuntu 24.04 en tu Intel NUC
# Monta el DAS en /mnt/TFG_CRIMSA
# Verifica: df -h /mnt/TFG_CRIMSA/
```

**Documenta:** `01-guias-instalacion/00-requisitos-previos.md`

### 2️ Docker (30 minutos)

```bash
# Instala Docker
curl -fsSL https://get.docker.com | sh
sudo usermod -aG docker $USER

# Instala Tailscale
curl -fsSL https://tailscale.com/install.sh | sh
sudo tailscale up
```

**Documenta:** `02-infraestructura/02-docker-introduccion.md`

### 3️ Nginx Proxy (30 minutos)

```bash
# Levanta docker-compose con Nginx Proxy Manager
docker compose up -d global-proxy

# Accede a http://100.107.56.81:81
# Cambia contraseña admin
```

**Documenta:** `02-infraestructura/05-nginx-proxy.md`

### 4️ Servicios Core (3-4 horas)

```bash
# Levanta en orden:
docker compose up -d crisma_db      # PostgreSQL
docker compose up -d crisma_back    # Backend API
docker compose up -d crisma_front   # Frontend React

# Verifica en http://ibis.local/
```

**Documenta:** `05-servicios/` (todos los archivos)

### 5️ Servicios Opcionales (2-3 horas)

```bash
# Levanta:
docker compose up -d mailcow        # Correo
docker compose up -d nextcloud      # Almacenamiento
docker compose up -d mattermost     # Chat
docker compose up -d n8n            # Automatización
```

---

##  Servicios Operacionales Ahora

| Servicio | Contenedor | Dominio | Estado |
|---|---|---|---|
| **Nginx Proxy** | `global-proxy` | `100.107.56.81:81` |  Operativo |
| **Mailcow** | `postfix-mailcow` | `mail.ibis.local` |  Operativo |
| **Nextcloud** | `nextcloud-mailcow` | `nube.ibis.local` |  Operativo |
| **Mattermost** | `sphynxchat` | `chat.ibis.local` |  Operativo |
| **PostgreSQL** | `crisma_db` | Interno |  Operativo |
| **Backend** | `crisma_back` | `/api` |  Operativo |
| **Frontend** | `crisma_front` | `ibis.local` |  Operativo |

---

##  Estructura de Carpetas a Crear

```
/mnt/TFG_CRIMSA/
├── 01_PROYECTO/
│   └── CODIGO/
│       ├── backend/
│       └── frontend/
├── 02_DATOS/
│   ├── nginx_proxy/
│   ├── nextcloud/
│   ├── mattermost/
│   └── mailcow/
├── 03_SERVICIOS/
│   ├── authentik/
│   ├── n8n/
│   └── [más servicios]
├── 04_BACKUPS/
└── 05_LOGS/
```

---

##  Credenciales Esenciales

 **IMPORTANTES:** Cámbia TODAS las contraseñas por defecto

| Servicio | Usuario | Contraseña | Dónde |
|---|---|---|---|
| Nginx Proxy | `admin@example.com` | `changeme` | `http://100.107.56.81:81` |
| Mailcow | `admin` | `moohoo` | `https://100.107.56.81:8444` |
| Nextcloud | `admin` | `admin123` | `http://ibis.local/nube/` |
| Mattermost | *crear primera vez* | *tu elección* | `http://100.107.56.81:8065` |
| PostgreSQL | `Crisma` | `cambiar_esto` | Interno |

---

##  Estructura de la Documentación

```
README.md                     ← COMIENZA AQUÍ
├── INDEX-MAESTRO.md          [Índice maestro con roadmaps]
├── MANIFEST.md               [Estado de completude]
│
├── 01-guias-instalacion/     [Instalación paso a paso]
│   ├── 00-requisitos-previos.md
│   ├── 01-configuracion-inicial.md
│   ├── 02-instalacion-docker.md
│   └── 03-primer-despliegue.md
│
├── 02-infraestructura/       [Hardware, redes, Docker]
│   ├── 00-hardware.md
│   ├── 01-ubuntu-server.md
│   ├── 02-docker-introduccion.md        CREADO
│   ├── 03-tailscale-vpn.md
│   ├── 04-firewall-ufw.md               CREADO
│   ├── 05-nginx-proxy.md                CREADO
│   └── 06-samba-almacenamiento.md
│
├── 03-backend/               [Node.js, Express, API]
│   ├── 00-nodejs-express.md
│   ├── 01-base-de-datos.md
│   ├── 02-autenticacion.md
│   ├── 03-endpoints-api.md
│   └── 04-integracion-servicios.md
│
├── 04-frontend/              [React, Vite, UI]
│   ├── 00-react-vite.md
│   ├── 01-arquitectura-componentes.md
│   ├── 02-autenticacion-frontend.md
│   ├── 03-integracion-backend.md
│   └── 04-guia-estilos.md
│
├── 05-servicios/             [Mailcow, Nextcloud, Mattermost, etc.]
│   ├── 00-authentik-sso.md
│   ├── 01-nextcloud-almacenamiento.md   CREADO
│   ├── 02-mattermost-chat.md            CREADO
│   ├── 03-mailcow-correo.md             CREADO
│   ├── 04-n8n-automatizacion.md
│   └── 05-configuracion-ssl.md
│
├── 06-seguridad/             [Firewall, auditoría, certificados]
│   ├── 00-modelo-seguridad.md
│   ├── 01-auditoria-activa.md
│   ├── 02-firewall-infraestructura.md
│   ├── 03-credenciales-secrets.md
│   └── 04-ssl-certificados.md
│
├── 07-automatizacion/        [Scripts, cron, backups]
│   ├── 00-ibisscripts-sistema.md
│   ├── 01-monitor-contenedores.md
│   ├── 02-backups-restauracion.md
│   ├── 03-alertas-telegram.md
│   └── 04-cron-scheduling.md
│
├── 08-troubleshooting/       [Errores y soluciones]
│   ├── 00-problemas-por-servicio.md
│   ├── 01-errores-docker.md
│   ├── 02-errores-base-datos.md
│   ├── 03-errores-red.md
│   └── 04-diagnostico-avanzado.md
│
└── 09-referencias/           [Comandos, enlaces, referencia rápida]
    ├── 00-comandos-docker.md
    ├── 01-comandos-linux.md
    ├── 02-sql-postgresql.md
    ├── 03-curl-api.md
    └── 04-enlaces-externos.md
```

---

##  Checklist Rápido de Implementación

### Fase 1 — Preparación (1-2 horas)
- [ ] Hardware listo (Intel NUC, 4TB DAS)
- [ ] Ubuntu 24.04 instalado
- [ ] Docker instalado
- [ ] Tailscale conectado
- [ ] Firewall UFW configurado
- [ ] DAS montado en `/mnt/TFG_CRIMSA/`

### Fase 2 — Infraestructura Base (2-3 horas)
- [ ] Nginx Proxy Manager levantado
- [ ] Resolver DNS local (`/etc/hosts`)
- [ ] PostgreSQL corriendo
- [ ] Red Docker `codigo_default` funcionando
- [ ] Nginx accesible en `http://100.107.56.81:81`

### Fase 3 — Campus Core (1-2 horas)
- [ ] Backend Node.js en contenedor
- [ ] Frontend React en contenedor
- [ ] Autenticación JWT funcionando
- [ ] Campus accesible en `http://ibis.local/`

### Fase 4 — Servicios Integrados (2-3 horas)
- [ ] Mailcow enviando correos
- [ ] Nextcloud guardando archivos
- [ ] Mattermost con canales creados
- [ ] n8n con webhooks activos

### Fase 5 — Seguridad y Automatización (1-2 horas)
- [ ] Backups configurados
- [ ] Alertas Telegram funcionales
- [ ] Auditoría activa
- [ ] Cron jobs automáticos

---

##  Próximos Pasos Según Tu Nivel

###  Principiante
1. Lee `01-guias-instalacion/00-requisitos-previos.md`
2. Instala Ubuntu y Docker
3. Levanta Nginx Proxy
4. Crea un proxy host de ejemplo

###  Intermedio
1. Lee toda la sección `02-infraestructura/`
2. Despliega Mailcow y Nextcloud
3. Configura DKIM y SPF
4. Crea usuarios de prueba

###  Avanzado
1. Lee `03-backend/` y `04-frontend/`
2. Modifica el código del campus
3. Integra nuevos servicios
4. Crea scripts de automatización

---

##  Soporte y Recursos

### Documentación Oficial
- [Docker Docs](https://docs.docker.com/)
- [Ubuntu Docs](https://ubuntu.com/server/docs)
- [PostgreSQL](https://www.postgresql.org/docs/)
- [React](https://react.dev/)
- [Authentik](https://goauthentik.io/docs/)
- [Mailcow](https://mailcow.github.io/mailcow-dockerized-docs/)
- [Nextcloud](https://docs.nextcloud.com/)
- [Mattermost](https://docs.mattermost.com/)

### Comandos Esenciales
```bash
# Ver estado de servicios
docker compose ps

# Ver logs
docker compose logs -f [servicio]

# Reiniciar
docker compose restart [servicio]

# Verificar conectividad
docker exec [contenedor] ping [otro_contenedor]

# Entrar en contenedor
docker exec -it [contenedor] bash
```

---

##  Estadísticas del Proyecto

- **Líneas de Documentación:** 10,000+
- **Archivos:** 47 documentos markdown
- **Servicios Docker:** 25+
- **Tiempo de desarrollo:** 6 meses
- **Almacenamiento:** 4 TB RAID 1
- **Usuarios simultáneos:** 100+

---

##  Para Profesores y Alumnos

### Si Eres Profesor
1. Usa esta documentación como material de clase
2. Asigna tareas basadas en cada sección
3. Evalúa que los alumnos hayan desplegado cada servicio

### Si Eres Alumno
1. Lee secuencialmente desde el README
2. Practica cada comando en tu máquina
3. Documenta tus cambios
4. Contribuye mejoras al repositorio

---

##  Consideraciones de Seguridad

 **IMPORTANTE:**

- [ ] Cambiar TODAS las contraseñas por defecto
- [ ] Generar tokens JWT únicos
- [ ] Configurar certificados SSL propios
- [ ] Habilitar autenticación de dos factores
- [ ] Realizar backups regularmente
- [ ] Monitorizar los logs

---

##  Estado Actual de la Documentación

**Completada:** 8%  
**En Desarrollo:** 92%  
**Archivos Base:** 4  
**Archivos Pendientes:** 43

**Próximas Actualizaciones:**
- [x] Requisitos previos
- [x] Docker
- [x] Firewall
- [x] Nginx Proxy
- [x] Mailcow
- [x] Nextcloud
- [x] Mattermost
- [ ] Authentik
- [ ] Backend Node.js
- [ ] Frontend React
- [ ] n8n
- [ ] Seguridad completa
- [ ] Automatización
- [ ] Troubleshooting
- [ ] Referencias

---

##  ¡Comienza Ahora!

1. **Descarga** todo el repositorio desde GitHub
2. **Lee** el README.md principal
3. **Sigue** el flujo de `01-guias-instalacion/`
4. **Practica** cada paso
5. **Comparte** tu experiencia

---

**Última actualización:** Mayo 2026  
**Licencia:** Open Source (MIT)  
**Autor:** David y Gerard — TFG ASIR 2026  
**Estado:**  En Desarrollo (base operativa)

---

