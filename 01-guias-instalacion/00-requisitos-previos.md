# 01 — Requisitos Previos y Preparación

Antes de instalar Ibis Campus, es fundamental verificar que tienes todos los componentes necesarios tanto en hardware como en software.

---

## Hardware Requerido

### Servidor Principal

- **Procesador:** Intel NUC 12 Gen o superior (mínimo Core i5)
- **RAM:** 16 GB DDR4/DDR5 (32 GB recomendado para 25+ contenedores)
- **SSD:** 512 GB para el sistema operativo y Docker
- **Almacenamiento Externo:** 4 TB (DAS QNAP o similar) con RAID 1 para datos críticos

### Acceso Remoto

- **VPN:** Tailscale (gratuito, basado en WireGuard)
- **Conectividad:** Conexión a Internet estable (1 Mbps mínimo)

### Cliente/Workstation

- **SO:** Windows 10/11, macOS o Linux
- **RAM:** 8 GB mínimo
- **Navegador:** Chrome/Firefox reciente

---

## Software Requerido

### Sistema Operativo

```bash
# Verificar versión
lsb_release -a

# Recomendado: Ubuntu Server 24.04 LTS
# Instalación: Descarga desde https://ubuntu.com/download/server
```

### Herramientas Esenciales

| Herramienta | Versión | Instalación |
|---|---|---|
| **Docker** | 27.0+ | `curl -fsSL https://get.docker.com \| sh` |
| **Docker Compose** | 2.20+ | Incluido en Docker Desktop |
| **Git** | 2.40+ | `sudo apt install git` |
| **curl** | 7.68+ | `sudo apt install curl` |
| **vim/nano** | Cualquiera | `sudo apt install vim` |

### Credenciales Necesarias

Antes de empezar, obtén o crea:

1. **Cuenta Tailscale**
   - Regístrate en https://tailscale.com/
   - Genera API tokens para automatización

2. **Cuenta de Docker Hub** (opcional)
   - Usamos imágenes públicas pero algunos builds personalizados requieren login
   - https://hub.docker.com/

3. **Bot de Telegram** (para notificaciones)
   - Busca `@BotFather` en Telegram
   - Crea un bot nuevo y obtén el `API_TOKEN`
   - Busca `@userinfobot` para obtener tu `CHAT_ID`

4. **Dominio o DNS Dinámico** (para HTTPS)
   - Opción A: Dominio propio (ej: midominio.com)
   - Opción B: Servicio nip.io (gratuito, no requiere dominio)
   - Opción C: Certificados autofirmados (desarrollo local)

---

## Verificación del Entorno

### Conexión a Internet

```bash
# Verificar que tienes Internet
ping 8.8.8.8

# Ver configuración de red
ip addr show
```

### Acceso a Sudo

```bash
# Verifica que tu usuario puede usar sudo
sudo whoami

# Si pide contraseña, anótala (la necesitarás frecuentemente)
```

### Espacio en Disco

```bash
# Verificar SSD del SO
df -h /

# Verificar DAS/Almacenamiento externo
df -h /mnt/

# Mínimo libre:
# - SSD: 100 GB
# - DAS: 1 TB (por si hay backups)
```

### Acceso al DAS (si está ya montado)

```bash
# Verificar que el almacenamiento está montado
mount | grep "/mnt/TFG_CRIMSA"

# Si no está montado, ver el UUID
sudo blkid

# Montarlo manualmente (temporal)
sudo mount /dev/sda1 /mnt/TFG_CRIMSA/
```

---

## Dependencias del Sistema Operativo

### Actualización de Repositorios

```bash
# Primero, actualiza el sistema completo
sudo apt update && sudo apt upgrade -y

# Instala dependencias comunes
sudo apt install -y \
    curl \
    wget \
    git \
    vim \
    htop \
    net-tools \
    openssh-server \
    openssh-client
```

### Habilitar SSH para Acceso Remoto (Crítico)

```bash
# Verificar que SSH está activo
sudo systemctl status ssh

# Habilitarlo si no está
sudo systemctl enable ssh
sudo systemctl start ssh

# Verificar que escucha en el puerto 22
sudo ss -tlnp | grep ssh
```

### Configuración del Firewall

```bash
# Instalar UFW si no está
sudo apt install ufw

# Permitir SSH primero (para no quedarse fuera)
sudo ufw allow ssh

# Permitir HTTP y HTTPS (necesarios para Nginx)
sudo ufw allow http
sudo ufw allow https

# Habilitar UFW
sudo ufw enable

# Ver reglas
sudo ufw status
```

---

## Preparación de Directorios

### Crear Estructura Base en el DAS

```bash
# Navegar al almacenamiento
cd /mnt/TFG_CRIMSA/

# Crear directorios principales
sudo mkdir -p \
    01_PROYECTO/CODIGO/{backend,frontend} \
    02_DATOS/nginx_proxy \
    03_SERVICIOS/{authentik,nextcloud,mattermost,mailcow,n8n} \
    04_BACKUPS \
    05_LOGS

# Asignar permisos al usuario actual
sudo chown -R $USER:$USER /mnt/TFG_CRIMSA/
```

### Crear Archivo .env Base

```bash
# En el directorio del proyecto
cat << 'EOF' > /mnt/TFG_CRIMSA/01_PROYECTO/.env
# Variables de Entorno Base
COMPOSE_PROJECT_NAME=ibis_campus
ENVIRONMENT=production
TZ=Europe/Madrid

# Base de Datos
DB_USER=Crisma
DB_PASSWORD=cambiar_esto_en_produccion
DB_NAME=danet
DB_PORT=5432

# JWT
JWT_SECRET=cambiar_esto_en_produccion

# Tailscale
TAILSCALE_IP=100.107.56.81

# Telegram (para notificaciones)
TELEGRAM_TOKEN=cambiar_esto
TELEGRAM_CHAT_ID=cambiar_esto
EOF

# Proteger el archivo
chmod 600 /mnt/TFG_CRIMSA/01_PROYECTO/.env
```

---

## Instalación de Tailscale (Acceso Remoto)

### En el Servidor

```bash
# Descargar e instalar
curl -fsSL https://tailscale.com/install.sh | sh

# Conectar a tu cuenta Tailscale
sudo tailscale up

# Anotar la IP asignada (ej: 100.107.56.81)
tailscale ip -4
```

### En el Cliente (Windows/Mac/Linux)

```bash
# Descargar desde https://tailscale.com/download
# Instalar y ejecutar
# Loguear con tu cuenta Tailscale

# Verificar conexión
ping 100.107.56.81  # IP del servidor
```

### Configurar Resolución de Nombres (Windows)

1. Abre `C:\Windows\System32\drivers\etc\hosts` como administrador
2. Añade estas líneas:

```
100.107.56.81 ibis.local
100.107.56.81 auth.ibis.local
100.107.56.81 nube.ibis.local
100.107.56.81 chat.ibis.local
100.107.56.81 mail.ibis.local
```

3. Guarda y ejecuta en Terminal (como Admin):

```cmd
ipconfig /flushdns
```

---

## Checklist de Verificación

Antes de continuar a la siguiente sección, verifica que tienes:

- [ ] Hardware especificado
- [ ] Ubuntu Server 24.04 LTS instalado
- [ ] Docker instalado (`docker --version`)
- [ ] Git instalado (`git --version`)
- [ ] SSH funcionando (`ssh localhost`)
- [ ] UFW configurado (`sudo ufw status`)
- [ ] DAS montado (`df -h /mnt/TFG_CRIMSA/`)
- [ ] Tailscale instalado y conectado
- [ ] Bot Telegram creado (tienes TOKEN y CHAT_ID)
- [ ] DNS local configurado (puedes hacer ping a ibis.local)
- [ ] Archivo .env creado con contraseñas cambiadas
- [ ] 100 GB libres en SSD
- [ ] 1 TB libres en DAS

---

## Siguientes Pasos

Una vez completada esta sección, dirígete a:
→ **`02-infraestructura/01-ubuntu-server.md`** para hardening del SO

---

**Tiempo estimado:** 2-3 horas  
**Dificultad:** Principiante  
**Requisitos:** Conexión a Internet, acceso físico o SSH al servidor
