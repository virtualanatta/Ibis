#  Ibis Campus — Documentación Completa del Proyecto

**Proyecto de Fin de Grado — ASIR 2026 | David y Gerard | Ibis Campus**

Documentación técnica completa de una plataforma educativa privada, 100% Docker, 100% Open Source, sin dependencias externas, hosteada en servidor físico con 4 TB de almacenamiento RAID 1.

---

##  Tabla de Contenidos

1. **[Guías de Instalación](01-guias-instalacion)**
2. **[Infraestructura](02-infraestructura)**
3. **[Backend](03-backend)**
4. **[Frontend](04-frontend)**
5. **[Servicios](05-servicios)**
6. **[Seguridad](06-seguridad)**
7. **[Automatización](07-automatizacion)**
8. **[Troubleshooting](08-troubleshooting)**
9. **[Referencias](09-referencias)**
10. **[Scripts](scripts-bash)**
11. 
---

##  Visión General del Proyecto

Ibis Campus es un ecosistema de servicios integrados que conforma una plataforma educativa completa para centros de formación. El nombre hace referencia al dios egipcio Thot, patrón de la sabiduría y el conocimiento.

### Características Principales

-  **100% Autoalojado** — Sin dependencias de proveedores cloud externos
-  **Aislamiento Total** — Acceso remoto exclusivo mediante Tailscale (VPN WireGuard)
-  **25+ Contenedores Docker** — Arquitectura modular y escalable
-  **4 TB RAID 1** — Almacenamiento redundante y seguro
-  **SSO Unificado** — Autenticación centralizada mediante Authentik
-  **Monitorización Activa** — Sistema de alertas automáticas por Telegram

### Servicios Principales

| Servicio | Dominio | Función |
|---|---|---|
| **Campus Virtual** | `ibis.local` | Aula virtual (React + Node.js) |
| **Authentik** | `auth.ibis.local` | Identity Provider (OIDC/SSO) |
| **Nextcloud** | `nube.ibis.local` | Almacenamiento colaborativo |
| **Mattermost** | `chat.ibis.local` | Comunicación en tiempo real |
| **Mailcow** | `mail.ibis.local` | Servidor de correo institucional |
| **n8n** | `100.107.56.81:5678` | Automatización y workflows |
| **PostgreSQL** | `crisma_db` | Base de datos principal |
| **Nginx** | `global-proxy` | Reverse proxy con SSL |

---

##  Estructura de la Documentación

### 01-Guías-Instalación
**Cómo instalar Ibis Campus desde cero, paso a paso.**

- `00-requisitos-previos.md` — Hardware, SO, Docker, credenciales
- `01-configuracion-inicial.md` — Tailscale, firewall, DNS
- `02-instalacion-docker.md` — Instalación y configuración de Docker
- `03-primer-despliegue.md` — Levantamiento del primer contenedor

### 02-Infraestructura
**Hardware, redes, almacenamiento y arquitectura del servidor.**

- `00-hardware.md` — Intel NUC, 4TB DAS QNAP, especificaciones
- `01-ubuntu-server.md` — Instalación y hardening del SO
- `02-docker-introduccion.md` — Conceptos, redes Docker, volúmenes
- `03-tailscale-vpn.md` — Configuración de acceso remoto seguro
- `04-firewall-ufw.md` — Seguridad perimetral, reglas UFW
- `05-nginx-proxy.md` — Reverse proxy, terminación SSL
- `06-samba-almacenamiento.md` — Acceso a los 4TB desde el cliente

### 03-Backend
**Desarrollo y configuración del API REST en Node.js.**

- `00-nodejs-express.md` — Setup del servidor, estructura del proyecto
- `01-base-de-datos.md` — PostgreSQL, esquema de tablas, migraciones
- `02-autenticacion.md` — JWT, bcrypt, flujo OIDC con Authentik
- `03-endpoints-api.md` — Documentación de rutas y ejemplos curl
- `04-integracion-servicios.md` — Cómo el backend se comunica con otros servicios

### 04-Frontend
**Interfaz de usuario con React y Vite.**

- `00-react-vite.md` — Setup, hot reload, optimización
- `01-arquitectura-componentes.md` — Structure, pages, contexts, services
- `02-autenticacion-frontend.md` — Login SSO, JWT en localStorage
- `03-integracion-backend.md` — Axios, servicios, errores CORS
- `04-guia-estilos.md` — Paleta de colores, componentes reutilizables

### 05-Servicios
**Instalación y configuración de cada microservicio.**

- `00-authentik-sso.md` — Identity Provider, aplicaciones OIDC
- `01-nextcloud-almacenamiento.md` — Almacenamiento colaborativo, WebDAV
- `02-mattermost-chat.md` — Chat institucional, canales, moderación
- `03-mailcow-correo.md` — Servidor SMTP/IMAP, gestión de buzones
- `04-n8n-automatizacion.md` — Workflows, webhooks, integraciones
- `05-configuracion-ssl.md` — Certificados autofirmados, HTTPS

### 06-Seguridad
**Auditoría, firewall, acceso y protección.**

- `00-modelo-seguridad.md` — Principios de seguridad aplicados
- `01-auditoria-activa.md` — Logs, bot Telegram, detección de anomalías
- `02-firewall-infraestructura.md` — UFW, iptables, puertos
- `03-credenciales-secrets.md` — Gestión segura de contraseñas y tokens
- `04-ssl-certificados.md` — Certificados autofirmados, renovación

### 07-Automatización
**Scripts, cron jobs, monitorización en tiempo real.**

- `00-ibisscripts-sistema.md` — Sistema de scripts Bash, orquestación
- `01-monitor-contenedores.md` — Vigilancia de servicios, auto-reinicio
- `02-backups-restauracion.md` — Estrategia de copias de seguridad
- `03-alertas-telegram.md` — Notificaciones en tiempo real
- `04-cron-scheduling.md` — Tareas programadas, automatización

### 08-Troubleshooting
**Errores comunes y cómo resolverlos.**

- `00-problemas-por-servicio.md` — Campus, Nextcloud, Mattermost, etc.
- `01-errores-docker.md` — Contenedores, redes, volúmenes
- `02-errores-base-datos.md` — PostgreSQL, conexiones, migraciones
- `03-errores-red.md` — DNS, firewall, SSL, proxies
- `04-diagnostico-avanzado.md` — Logs, debug, herramientas

### 09-Referencias
**Comandos útiles, enlaces y documentación externa.**

- `00-comandos-docker.md` — Docker, docker-compose, troubleshooting
- `01-comandos-linux.md` — Ubuntu, bash, systemctl, ufw
- `02-sql-postgresql.md` — Consultas frecuentes, backups
- `03-curl-api.md` — Testing de endpoints, ejemplos
- `04-enlaces-externos.md` — Documentación oficial de tecnologías

---

##  Cómo Usar Esta Documentación

### Para Implementar Ibis Campus desde Cero

1. **Lee primero:** `01-guias-instalacion/00-requisitos-previos.md`
2. **Prepara el hardware:** `02-infraestructura/00-hardware.md`
3. **Instala el SO:** `02-infraestructura/01-ubuntu-server.md`
4. **Configura Docker:** `02-infraestructura/02-docker-introduccion.md`
5. **Despliega servicios:** Sigue cada carpeta de `05-servicios/`
6. **Desarrolla:** `03-backend/` y `04-frontend/`

### Para Entender la Arquitectura

- Lee: `02-infraestructura/02-docker-introduccion.md` + `02-infraestructura/05-nginx-proxy.md`
- Luego: `05-servicios/00-authentik-sso.md` para el flujo de autenticación

### Para Resolver Problemas

1. Dirígete a `08-troubleshooting/`
2. Busca tu error en `00-problemas-por-servicio.md`
3. Si es de contenedores: `01-errores-docker.md`
4. Si es de red: `03-errores-red.md`

---

##  Estadísticas del Proyecto

- **Contenedores Docker:** 25+
- **Líneas de Documentación:** 10,000+
- **Servicios Integrados:** 8 (Campus, Authentik, Nextcloud, Mattermost, Mailcow, n8n, PostgreSQL, Nginx)
- **Scripts de Automatización:** 15+
- **Tiempo de Desarrollo:** 6 meses
- **Almacenamiento Total:** 4 TB (RAID 1)

---

##  Notas Importantes

### Credenciales y Seguridad

>  **ADVERTENCIA:** Este repositorio contiene documentación técnica pero NO contiene credenciales reales. Las contraseñas y tokens se almacenan únicamente en archivos locales del servidor, protegidos con permisos restrictivos.

### Configuración de Ejemplo

Algunos valores mostrados son ejemplos. En tu instalación deberás:
- Cambiar contraseñas por defecto
- Generar nuevos tokens JWT
- Configurar certificados SSL propios
- Ajustar cuotas de almacenamiento

---

##  Enlaces Rápidos

- **Documentación Oficial de Tecnologías**
  - [Docker Docs](https://docs.docker.com/)
  - [Authentik](https://goauthentik.io/)
  - [Nextcloud](https://docs.nextcloud.com/)
  - [Mattermost](https://docs.mattermost.com/)
  - [Mailcow](https://mailcow.github.io/mailcow-dockerized-docs/)

- **Herramientas Útiles**
  - [Tailscale](https://tailscale.com/)
  - [n8n](https://n8n.io/)
  - [PostgreSQL](https://www.postgresql.org/docs/)

---

##  Contacto y Soporte

Este proyecto es un TFG de ASIR 2026

---

**Última actualización:** Mayo 2026  
**Licencia:** Open Source — Libre para uso educativo y no comercial  
**Estado:**  Documentación Completa y Operativa
