# Firewall e Infraestructura de Red — Seguridad Perimetral

##  Estrategia de Seguridad: Exposición Cero

Ibis Campus está diseñado bajo el principio de **Exposición Cero**. El servidor es invisible para Internet. No hay puertos abiertos en el router. Nadie puede entrar si no tiene las llaves digitales.

---

##  Los Tres Muros de Defensa

```
                    INTERNET
                       ↓
            [1. Router ISP — Firewall]
                       ↓
                    TAILSCALE VPN
                       ↓
         [2. UFW — Firewall Ubuntu]
                       ↓
                    LOCALHOST
                       ↓
        [3. Docker — Aislamiento de Procesos]
                       ↓
               [Servicios Internos]
```

---

## 1️ El Router ISP — Seguridad de Fábrica

### Configuración

- **Puertos Abiertos:** NINGUNO
- **DMZ:** Deshabilitada
- **UPnP:** Deshabilitada
- **Firewall:** Activo (bloquea peticiones entrantes no solicitadas)

### Ventaja

Aunque alguien logre acceder a nuestra red WiFi local, no puede entrar al servidor porque los puertos están cerrados en el router.

---

## 2️ Tailscale — El Túnel Privado VPN

### ¿Qué es Tailscale?

Una VPN basada en WireGuard que crea una red privada virtual. Solo los dispositivos que están en tu cuenta de Tailscale pueden comunicarse.

### Instalación en el Servidor

```bash
# Descargar e instalar
curl -fsSL https://tailscale.com/install.sh | sh

# Conectar a tu cuenta Tailscale
sudo tailscale up

# Obtener la IP asignada
tailscale ip -4
# Ejemplo de salida: 100.107.56.81
```

### Instalación en Cliente (Windows/Mac/Linux)

1. Descarga desde https://tailscale.com/download
2. Instala y ejecuta
3. Loguea con tu cuenta Tailscale
4. Verifica la conexión:

```bash
ping 100.107.56.81  # IP del servidor
```

### Ventaja de Tailscale

-  Acceso remoto sin abrir puertos
-  Cifrado end-to-end
-  Funciona atravesando firewalls
-  Gratuito para uso personal (hasta 3 dispositivos)

---

## 3️⃣ UFW — Firewall del Sistema

### Instalación

```bash
# Instalar UFW
sudo apt install ufw

# Establecer políticas por defecto
sudo ufw default deny incoming  # Bloquea TODO entrante
sudo ufw default allow outgoing # Permite TODO saliente
```

### Reglas de Ibis Campus

```bash
#  CRITICIDAD: PERMITE SSH PRIMERO (para no quedarse fuera)
sudo ufw allow ssh

# Permitir tráfico HTTP/HTTPS (necesarios para Nginx)
sudo ufw allow http
sudo ufw allow https

# Permitir TODO el tráfico de Tailscale
sudo ufw allow in on tailscale0

# Activar el firewall
sudo ufw enable

# Verificar reglas
sudo ufw status verbose
```

### Output Esperado

```
Status: active

     To                         Action      From
     --                         ------      ----
22/tcp                         ALLOW       Anywhere
80/tcp                         ALLOW       Anywhere
443/tcp                        ALLOW       Anywhere
Anywhere on tailscale0         ALLOW       Anywhere
```

### Conceptos Clave

| Término | Significado |
|---|---|
| **Incoming** | Tráfico que entra al servidor |
| **Outgoing** | Tráfico que sale del servidor |
| **Allow** | Permitir paso |
| **Deny** | Rechazar paso |
| **on tailscale0** | Solo en la interfaz de Tailscale |

---

##  Inventario de Puertos Docker

Aunque los puertos Docker están abiertos **dentro del localhost**, UFW garantiza que solo son accesibles a través de Tailscale.

| Servicio | Contenedor | Puerto Interno | Acceso |
|---|---|---|---|
| Nginx Proxy | `global-proxy` | 80, 443 | Tailscale |
| Frontend React | `crisma_front` | 8080 | Solo desde Proxy |
| Backend API | `crisma_back` | 3005 | Solo desde Proxy |
| PostgreSQL | `crisma_db` | 5432 | Sin Exposición |
| Authentik | `authentik-server` | 9000 | Nginx |
| Nextcloud | `nextcloud` | 80 | Nginx |
| Mattermost | `mattermost` | 8065 | Nginx |
| n8n | `n8n_ibis` | 5678 | Tailscale |

---

##  Samba — Acceso al DAS (SMB)

### ¿Por Qué Samba?

Permite acceder a los 4 TB del DAS como si fueran una carpeta de red en Windows/Mac/Linux.

### Configuración

```bash
# Instalar Samba
sudo apt install samba

# Editar configuración
sudo nano /etc/samba/smb.conf
```

### Contenido de `/etc/samba/smb.conf`

```ini
[global]
   # Solo escucha en Tailscale
   interfaces = lo tailscale0
   bind interfaces only = yes
   
   # Fuerza SMB3 (cifrado moderno)
   server min protocol = SMB3

[TFG_CRIMSA]
   path = /mnt/TFG_CRIMSA
   valid users = gerard
   read only = no
   create mask = 0755
```

### Acceso desde Windows

1. Abre el Explorador de Archivos
2. Escribe en la barra de direcciones:

```
\\100.107.56.81\TFG_CRIMSA
```

3. Te pedirá usuario y contraseña (la del servidor)

### Troubleshooting: "Samba es invisible"

**Problema:** El portátil no ve el servidor en la red local.

**Causa:** El router educativo bloquea NetBIOS (descubrimiento de red).

**Solución:** Conecta directamente por IP de Tailscale, no por nombre de red.

---

##  Problemas Encontrados y Soluciones

### El Bloqueo Accidental (UFW Lockout)

**Situación:** Activamos UFW remotamente pero olvidamos permitir Tailscale.

**Resultado:** Nos quedamos fuera del servidor. No podemos conectar ni por SSH.

**Solución:** 

1. Conectar físicamente el NUC a un monitor y teclado
2. Ejecutar:

```bash
sudo ufw allow in on tailscale0
sudo ufw reload
```

**Lección:** SIEMPRE permitir la VPN antes de activar el firewall.

### Puertos en Conflicto (Mailcow)

**Problema:** Mailcow intentaba usar los puertos 80 y 443, que ya estaba usando Nginx.

**Solución:** Editar `mailcow.conf`:

```bash
HTTP_PORT=8181
HTTPS_PORT=8444
```

Luego configurar Nginx para redirigir `mail.ibis.local` → `localhost:8181`.

### Samba "Mudo"

**Problema:** El ordenador no encontraba la carpeta compartida aunque la VPN estuviera activa.

**Causa:** El router bloqueaba paquetes de descubrimiento de red (NetBIOS).

**Solución:** Usar dirección IP directa en lugar de nombre de red.

---

##  Diagrama de Flujo de Seguridad

```
Cliente (Windows/Mac)
        │
        └─→ Tailscale IP: 100.107.56.81
                │
                └─→ UFW [Permite Tailscale]
                        │
                        └─→ Nginx Proxy (puerto 443)
                                │
                                ├─→ http://crisma_back:3005
                                ├─→ http://nextcloud:80
                                ├─→ http://mattermost:8065
                                └─→ http://authentik:9000
```

**Seguridad en capas:** Aunque alguien comprometa un servicio, no puede acceder a otros.

---

##  Checklist de Seguridad de Red

- [ ] Router ISP: Firewall activo, sin puertos abiertos
- [ ] Tailscale: Instalado y conectado en servidor y cliente
- [ ] UFW: Activo con reglas permitidas para Tailscale
- [ ] Samba: Escucha solo en Tailscale
- [ ] Nginx: Configurado como único proxy inverso
- [ ] Docker: Servicios internos sin puertos públicos
- [ ] Resolución DNS: `/etc/hosts` con entradas locales

---

##  Siguientes Pasos

1. **Configura:** `02-infraestructura/03-tailscale-vpn.md`
2. **Lee:** `02-infraestructura/05-nginx-proxy.md` para el proxy
3. **Practica:** Intenta acceder con Samba desde tu portátil

---

**Tiempo de lectura:** 25 minutos  
**Experiencia requerida:** Intermedio  
**Verificación:** `sudo ufw status` && `tailscale ip -4`
