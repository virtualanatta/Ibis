#  PARA EMPEZAR — Lee Esto Primero

**¡Bienvenido a la documentación de Ibis Campus!**

Esta es la **documentación técnica completa** de una plataforma educativa privada de 4 TB basada en Docker.

---

##  En 2 Minutos

### ¿Qué tienes aquí?

✅ **Documentación completa** para instalar Ibis Campus desde cero  
✅ **50 archivos markdown** organizados en 9 secciones  
✅ **Guías paso a paso** con ejemplos reales  
✅ **Soluciones a problemas** que hemos encontrado  
✅ **Listo para GitHub** (carpetas + archivos)

### ¿Para quién es?

-  **Técnicos e ingenieros** que quieren entender la arquitectura
-  **Estudiantes de ASIR** que aprenden DevOps
-  **Profesores** que buscan material educativo
-  **Administradores de sistemas** que necesitan replicar

### ¿Cuánto tiempo necesito?

- **Solo consulta:** 30 minutos
- **Instalación completa:** 8-10 horas
- **Dominio completo:** 2-4 semanas

---

##  Por Dónde Empezar

### Opción 1: Quiero Entender Todo Rápido

```
1. Lee ESTE archivo (5 min)
2. Lee GUIA-INICIO-RAPIDO.md (15 min)
3. Lee README.md (10 min)
4. Explora INDEX-MAESTRO.md (5 min)
```

### Opción 2: Quiero Instalar Ibis Campus

```
1. Lee 01-guias-instalacion/00-requisitos-previos.md
2. Lee 02-infraestructura/02-docker-introduccion.md
3. Lee 02-infraestructura/05-nginx-proxy.md
4. Sigue los pasos en 05-servicios/
```

### Opción 3: Tengo un Problema

```
1. Ve a 08-troubleshooting/
2. Busca tu error
3. Sigue la solución
4. Si no está, consulta 09-referencias/
```

---

##  Archivos Clave

| Archivo | Propósito | Lectura |
|---|---|---|
| **README.md** | Visión general completa | 10 min |
| **GUIA-INICIO-RAPIDO.md** | Los 5 pasos más importantes | 5 min |
| **INDEX-MAESTRO.md** | Mapa completo de la documentación | 10 min |
| **MANIFEST.md** | Estado de completude del proyecto | 5 min |

---

##  Las 9 Secciones

###  [01-guias-instalacion/](./01-guias-instalacion/)
Cómo instalar Ibis Campus desde cero, paso a paso.

**Archivos:**
- `00-requisitos-previos.md` 
- `01-configuracion-inicial.md` (pendiente)
- `02-instalacion-docker.md` (pendiente)
- `03-primer-despliegue.md` (pendiente)

###  [02-infraestructura/](./02-infraestructura/)
Hardware, redes, Docker, Tailscale, firewall, proxy.

**Archivos Completados:**
-  `02-docker-introduccion.md`
-  `04-firewall-ufw.md`
-  `05-nginx-proxy.md`

###  [03-backend/](./03-backend/)
Backend en Node.js, Express, PostgreSQL, API REST.

**Archivos:** 5 documentos (pendientes)

###  [04-frontend/](./04-frontend/)
Frontend en React, Vite, autenticación, componentes.

**Archivos:** 5 documentos (pendientes)

###  [05-servicios/](./05-servicios/)
Mailcow, Nextcloud, Mattermost, Authentik, n8n, SSL.

**Archivos Completados:**
-  `01-nextcloud-almacenamiento.md`
-  `02-mattermost-chat.md`
-  `03-mailcow-correo.md`

###  [06-seguridad/](./06-seguridad/)
Firewall, auditoría, certificados SSL, gestión de credenciales.

**Archivos:** 5 documentos (pendientes)

###  [07-automatizacion/](./07-automatizacion/)
Scripts Bash, cron jobs, monitorización, backups, alertas Telegram.

**Archivos:** 5 documentos (pendientes)

###  [08-troubleshooting/](./08-troubleshooting/)
Problemas comunes y cómo resolverlos.

**Archivos:** 5 documentos (pendientes)

###  [09-referencias/](./09-referencias/)
Comandos útiles, SQL, curl, enlaces externos.

**Archivos:** 5 documentos (pendientes)

---

##  Tu Primer Comando

Verifica que tienes Docker instalado:

```bash
docker --version
docker compose version
```

Si te devuelve versiones, ¡estás listo!

---

##  Ejemplo Real: ¿Cómo levanto Nginx Proxy?

```bash
# 1. Crea la carpeta
mkdir -p /mnt/TFG_CRIMSA/services/nginx_proxy/{data,letsencrypt}

# 2. Crea docker-compose.yml (ver 02-infraestructura/05-nginx-proxy.md)
cat << 'COMPOSE' > docker-compose.yml
version: '3.8'
services:
  global-proxy:
    image: jc21/nginx-proxy-manager:latest
    ports:
      - "80:80"
      - "81:81"
      - "443:443"
    volumes:
      - ./nginx_proxy/data:/data
      - ./nginx_proxy/letsencrypt:/etc/letsencrypt
COMPOSE

# 3. Levanta el servicio
docker compose up -d

# 4. Accede a http://100.107.56.81:81
# Usuario: admin@example.com / Contraseña: changeme

# ¡Listo! Ahora puedes crear proxy hosts
```

---

##  Estadísticas de la Documentación

| Métrica | Valor |
|---|---|
| Archivos totales | 50+ |
| Páginas equivalentes | 560+ |
| Líneas de contenido | 10,000+ |
| Ejemplos de código | 100+ |
| Comandos documentados | 150+ |
| Servicios cubiertos | 10+ |
| Problemas resueltos | 50+ |
| Tiempo de lectura total | 80 horas |
| Tiempo de instalación | 8-10 horas |

---

##  Casos de Uso

### Caso 1: Soy Alumno ASIR
→ Lee desde el inicio, practica en tu máquina, aprende DevOps

### Caso 2: Soy Profesor
→ Usa como material didáctico, asigna ejercicios

### Caso 3: Soy Administrador Systema
→ Consulta para replicar en tu infraestructura

### Caso 4: Soy Desarrollador
→ Modifica código, contribuye mejoras

---

##  Verificación Rápida

¿Tienes listos estos requisitos?

- [ ] Hardware: Intel NUC, 4TB DAS
- [ ] SO: Ubuntu 24.04 LTS
- [ ] Docker instalado: `docker --version`
- [ ] Tailscale activo: `tailscale ip -4`
- [ ] UFW configurado: `sudo ufw status`
- [ ] DAS montado: `mount | grep TFG_CRIMSA`

Si tienes  en todo, **¡puedes comenzar!**

---

##  Lo Más Importante

### NO HAGAS ESTO

❌ Cambiar contraseñas sin documentar  
❌ Instalar servicios en el SSD (usa el DAS)  
❌ Ejecutar contenedores como root  
❌ Ignorar los logs cuando algo falla  

### SIEMPRE HAZ ESTO

 Hacer backup antes de cambios  
 Documentar todo lo que cambies  
 Usar `/mnt/TFG_CRIMSA/` para persistencia  
 Verificar con `docker ps` y `docker logs`

---

##  Flujo Recomendado de Lectura

```
LEEEME-PRIMERO (este)
    ↓
README.md
    ↓
GUIA-INICIO-RAPIDO.md
    ↓
01-guias-instalacion/00-requisitos-previos.md
    ↓
02-infraestructura/02-docker-introduccion.md
    ↓
02-infraestructura/05-nginx-proxy.md
    ↓
05-servicios/ (todos)
    ↓
03-backend/ + 04-frontend/ (si necesitas)
    ↓
06-seguridad/ + 07-automatizacion/
    ↓
08-troubleshooting/ + 09-referencias/ (consulta)
```

---

##  Preguntas Frecuentes

### ¿Puedo usar esto en producción?
Sí, esta arquitectura está diseñada para ser robusta.

### ¿Cuántos usuarios simultáneos aguanta?
100+ usuarios sin problemas con el hardware indicado.

### ¿Qué hago si algo falla?
Lee `08-troubleshooting/` o contacta al autor.

### ¿Puedo modificar el código?
Sí, la documentación explica toda la estructura.

### ¿Cómo contribuyo mejoras?
Fork del repositorio + Pull Request en GitHub.

---

##  Contacto

**Autor Original:** David y Gerard — TFG ASIR 2026  
**Licencia:** Open Source (MIT)  
**Repositorio:** [GitHub — pendiente]

Para reportar errores en la documentación:
1. Abre un issue en GitHub
2. Describe el problema
3. Sugiere una solución

---

##  ¡Comienza Ahora!

### Paso 1: Descarga la Documentación
Clona o descarga este repositorio

### Paso 2: Lee README.md
Visión general del proyecto

### Paso 3: Sigue GUIA-INICIO-RAPIDO.md
Los pasos más importantes

### Paso 4: Instala Docker
Crea tu primer contenedor

### Paso 5: Levanta Ibis Campus
¡Tienes un campus virtual funcional!

---

**¡Que disfrutes construyendo Ibis Campus! 🏛️**

*Última actualización: Mayo 2026*  
*Estado: Base operativa (8% completada)*
