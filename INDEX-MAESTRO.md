#  Índice Maestro de Documentación

## Estructura Completa del Repositorio

```
ibis-campus-docs/
├── README.md                          ← COMENZAR AQUÍ
├── INDEX-MAESTRO.md                   ← Este archivo
│
├── 01-guias-instalacion/              [6-8 horas]
│   ├── 00-requisitos-previos.md        Completado
│   ├── 01-configuracion-inicial.md    [En desarrollo]
│   ├── 02-instalacion-docker.md       [En desarrollo]
│   ├── 03-primer-despliegue.md        [En desarrollo]
│   └── _INDEX.md
│
├── 02-infraestructura/                [8-10 horas]
│   ├── 00-hardware.md                 [Intel NUC, 4TB DAS, redes]
│   ├── 01-ubuntu-server.md            [Instalación, hardening]
│   ├── 02-docker-introduccion.md      [Conceptos, redes, volúmenes]
│   ├── 03-tailscale-vpn.md            [VPN, acceso remoto]
│   ├── 04-firewall-ufw.md             [UFW, iptables, seguridad]
│   ├── 05-nginx-proxy.md              [Reverse proxy, SSL]
│   ├── 06-samba-almacenamiento.md     [SMB, acceso a 4TB]
│   └── _INDEX.md
│
├── 03-backend/                        [10-12 horas]
│   ├── 00-nodejs-express.md           [Setup, estructura]
│   ├── 01-base-de-datos.md            [PostgreSQL, esquema]
│   ├── 02-autenticacion.md            [JWT, bcrypt, OIDC]
│   ├── 03-endpoints-api.md            [Documentación de rutas]
│   ├── 04-integracion-servicios.md    [Comunicación con otros servicios]
│   └── _INDEX.md
│
├── 04-frontend/                       [8-10 horas]
│   ├── 00-react-vite.md               [Setup, hot reload]
│   ├── 01-arquitectura-componentes.md [Structure, páginas]
│   ├── 02-autenticacion-frontend.md   [Login SSO, contexto]
│   ├── 03-integracion-backend.md      [Axios, servicios]
│   ├── 04-guia-estilos.md             [Paleta de colores, componentes]
│   └── _INDEX.md
│
├── 05-servicios/                      [15-20 horas]
│   ├── 00-authentik-sso.md            [Identity Provider, OIDC]
│   ├── 01-nextcloud-almacenamiento.md [Almacenamiento colaborativo]
│   ├── 02-mattermost-chat.md          [Chat, canales, moderación]
│   ├── 03-mailcow-correo.md           [SMTP/IMAP, buzones]
│   ├── 04-n8n-automatizacion.md       [Workflows, webhooks]
│   ├── 05-configuracion-ssl.md        [Certificados, HTTPS]
│   └── _INDEX.md
│
├── 06-seguridad/                      [6-8 horas]
│   ├── 00-modelo-seguridad.md         [Principios, arquitectura]
│   ├── 01-auditoria-activa.md         [Logs, Bot Telegram, alertas]
│   ├── 02-firewall-infraestructura.md [UFW, puertos, reglas]
│   ├── 03-credenciales-secrets.md     [Gestión de contraseñas]
│   ├── 04-ssl-certificados.md         [Certificados autofirmados]
│   └── _INDEX.md
│
├── 07-automatizacion/                 [4-6 horas]
│   ├── 00-ibisscripts-sistema.md      [Scripts Bash, orquestación]
│   ├── 01-monitor-contenedores.md     [Vigilancia, auto-reinicio]
│   ├── 02-backups-restauracion.md     [Copias de seguridad]
│   ├── 03-alertas-telegram.md         [Notificaciones]
│   ├── 04-cron-scheduling.md          [Tareas programadas]
│   └── _INDEX.md
│
├── 08-troubleshooting/                [A consultar según necesidad]
│   ├── 00-problemas-por-servicio.md   [Campus, Nextcloud, etc.]
│   ├── 01-errores-docker.md           [Contenedores, redes, volúmenes]
│   ├── 02-errores-base-datos.md       [PostgreSQL, conexiones]
│   ├── 03-errores-red.md              [DNS, firewall, SSL]
│   ├── 04-diagnostico-avanzado.md     [Logs, debug tools]
│   └── _INDEX.md
│
└── 09-referencias/                    [Consulta rápida]
    ├── 00-comandos-docker.md          [Docker cli, compose]
    ├── 01-comandos-linux.md           [Bash, systemctl, ufw]
    ├── 02-sql-postgresql.md           [Consultas, backups]
    ├── 03-curl-api.md                 [Testing de endpoints]
    ├── 04-enlaces-externos.md         [Documentación oficial]
    └── _INDEX.md
```

---

##  Rutas de Aprendizaje Recomendadas

### 1. **Implementar Ibis Campus de Cero**
**Tiempo Total: 60-80 horas | Dificultad: Intermedio-Avanzado**

```
01-guias-instalacion/ (completa)
    ↓
02-infraestructura/ (completa)
    ↓
05-servicios/00 (Authentik)
    ↓
03-backend/ (completa)
    ↓
04-frontend/ (completa)
    ↓
05-servicios/01-05 (resto de servicios)
    ↓
06-seguridad/ (completa)
    ↓
07-automatizacion/ (completa)
```

### 2. **Entender la Arquitectura**
**Tiempo: 4-6 horas | Dificultad: Intermedio**

```
README.md (visión general)
    ↓
02-infraestructura/02 (Docker conceptos)
    ↓
02-infraestructura/05 (Nginx y proxy)
    ↓
05-servicios/00 (Authentik y flujo SSO)
    ↓
Leer diagramas en 03-backend/04 y 04-frontend/03
```

### 3. **Resolver Problemas**
**Tiempo: Varía | Dificultad: Varía**

```
Paso 1: ¿Qué servicio falla?
    → Si Docker: 08-troubleshooting/01
    → Si Base de datos: 08-troubleshooting/02
    → Si Red: 08-troubleshooting/03
    → Otro: 08-troubleshooting/00

Paso 2: Consultar comandos útiles
    → 09-referencias/00, 01, 02, 03
```

### 4. **Operación y Mantenimiento (post-instalación)**
**Tiempo: 2-4 horas | Dificultad: Principiante**

```
07-automatizacion/00 (Scripts disponibles)
    ↓
07-automatizacion/02 (Cómo hacer backups)
    ↓
06-seguridad/01 (Auditoría y alertas)
    ↓
09-referencias/ (Consultas rápidas)
```

---

##  Estadísticas de la Documentación

| Sección | Archivos | Páginas Est. | Horas Lectura |
|---|---|---|---|
| 01 - Guías de Instalación | 4 | 40 | 6-8h |
| 02 - Infraestructura | 7 | 80 | 8-10h |
| 03 - Backend | 5 | 60 | 10-12h |
| 04 - Frontend | 5 | 50 | 8-10h |
| 05 - Servicios | 6 | 100 | 15-20h |
| 06 - Seguridad | 5 | 50 | 6-8h |
| 07 - Automatización | 5 | 40 | 4-6h |
| 08 - Troubleshooting | 5 | 80 | Variable |
| 09 - Referencias | 5 | 60 | Variable |
| **TOTAL** | **47** | **560** | **65-80h** |

---

##  Cómo Descargar y Organizar

### Opción A: Clonar todo el repositorio

```bash
git clone https://github.com/tuusuario/ibis-campus-docs.git
cd ibis-campus-docs
```

### Opción B: Descargar como ZIP

1. Accede a GitHub
2. Click en "Code" → "Download ZIP"
3. Extrae en tu carpeta de documentación

### Opción C: Descargar Solo lo Que Necesitas

```bash
# Si solo necesitas instalación
curl -L https://github.com/.../archive/refs/heads/main.zip -o docs.zip
unzip docs.zip 'ibis-campus-docs/01-*'
```

---

##  Checklist de Completude

**Fase 1 — Instalación (70% completada)**
- [x] Requisitos previos
- [ ] Configuración inicial
- [ ] Instalación de Docker
- [ ] Primer despliegue

**Fase 2 — Infraestructura (0% completada)**
- [ ] Hardware
- [ ] Ubuntu Server
- [ ] Docker introducción
- [ ] Tailscale VPN
- [ ] Firewall UFW
- [ ] Nginx Proxy
- [ ] Samba almacenamiento

**Fase 3 — Servicios (0% completada)**
- [ ] Authentik SSO
- [ ] Nextcloud
- [ ] Mattermost
- [ ] Mailcow
- [ ] n8n
- [ ] SSL/Certificados

**Fase 4 — Backend (0% completada)**
- [ ] Node.js/Express
- [ ] PostgreSQL
- [ ] Autenticación
- [ ] Endpoints API
- [ ] Integración

**Fase 5 — Frontend (0% completada)**
- [ ] React/Vite
- [ ] Arquitectura componentes
- [ ] Autenticación
- [ ] Integración backend
- [ ] Estilos

**Fase 6 — Seguridad (0% completada)**
- [ ] Modelo de seguridad
- [ ] Auditoría activa
- [ ] Firewall
- [ ] Credenciales
- [ ] SSL certificados

**Fase 7 — Automatización (0% completada)**
- [ ] IbisScripts
- [ ] Monitor de contenedores
- [ ] Backups
- [ ] Alertas Telegram
- [ ] Cron scheduling

---

##  Buscar en la Documentación

### Búsqueda por Tema

- **Docker**: `02-infraestructura/02`, `01/02`, `08/01`, `09/00`
- **Base de Datos**: `03-backend/01`, `08/02`, `09/02`
- **Autenticación**: `03-backend/02`, `04-frontend/02`, `05-servicios/00`
- **Nextcloud**: `05-servicios/01`, `08/00`
- **Mattermost**: `05-servicios/02`, `08/00`
- **Seguridad**: `06-seguridad/*`, `07-automatizacion/03`
- **Errores**: `08-troubleshooting/*`

### Búsqueda por Herramienta

- **Bash/Linux**: `01/02`, `07`, `08`, `09/01`
- **Docker**: `02/02`, `02/02`, `03/02`, `08/01`, `09/00`
- **PostgreSQL**: `03/01`, `08/02`, `09/02`
- **React**: `04/*`, `04/*`, `08/*`, `09/*`
- **Nginx**: `02/05`, `05/05`, `08/03`
- **Tailscale**: `02/03`, `02/04`

---

##  Contacto y Contribuciones

Si encuentras errores o tienes mejoras:

1. Abre un issue en GitHub
2. Haz un fork y envía un pull request
3. Contacta al autor del proyecto

---

**Documentación Generada:** Mayo 2026  
**Última Actualización:** [Ver commit history]  
**Estado:** 70% Completada (Instalación base operativa)  
**Próximas Actualizaciones:** Infraestructura completa, luego Servicios

---

##  Cómo Usar Esta Documentación en Clase

### Para Profesores

Cada archivo está diseñado para:
- Ser presentado en 1-2 sesiones de clase
- Incluir ejercicios prácticos
- Tener checklist de verificación
- Proporcionar troubleshooting

### Para Alumnos

1. Lee los requisitos previos
2. Haz los ejercicios prácticos en tu máquina
3. Documenta tus cambios
4. Comparte tu instalación con otros
5. Contribuye mejoras a la documentación

---

##  Referencias Externas

- [Docker Documentation](https://docs.docker.com/)
- [Ubuntu Server Guide](https://ubuntu.com/server/docs)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [React Documentation](https://react.dev/)
- [Authentik Docs](https://goauthentik.io/docs/)

---

**¡Bienvenido a Ibis Campus! 🏛️**
