# Docker — Virtualización y Orquestación de Contenedores

##  Introducción a Docker

Docker es la base de toda la arquitectura de Ibis Campus. Permite encapsular cada servicio en un contenedor aislado, garantizando que todo funcione igual en cualquier servidor sin conflictos de dependencias.

---

##  Por Qué Docker

### El Problema Sin Docker

Instalar software directamente en el SO cause:
- Conflictos de versiones de librerías
- Dependencias que rompen otros servicios
- Dificultad para replicar el entorno
- Configuración frágil y no reproducible

### La Solución: Docker

-  Cada servicio en su propia "burbuja"
-  Aislamiento total de procesos
-  Portabilidad garantizada
-  Fácil de replicar en otro servidor

---

##  Instalación de Docker en Ubuntu 24.04

### Instalación del Motor de Docker

```bash
# Actualizar repositorios
sudo apt update && sudo apt install ca-certificates curl gnupg

# Añadir clave GPG oficial de Docker
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Configurar repositorio estable
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Instalar Docker y Docker Compose
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

### Verificación

```bash
# Ver versión
docker --version
docker compose version

# Test de funcionamiento
sudo docker run hello-world
```

### Permitir Usar Docker sin sudo

```bash
# Crear grupo docker
sudo groupadd docker

# Añadir usuario al grupo
sudo usermod -aG docker $USER

# Aplicar cambios (sin reiniciar)
newgrp docker

# Verificar
docker run hello-world  # Sin sudo
```

---

## 🏗️ Conceptos Fundamentales

### 1. Imagen vs Contenedor

| Concepto | Definición | Analogía |
|---|---|---|
| **Imagen** | Plantilla de solo lectura | ISO de instalación |
| **Contenedor** | Instancia viva de una imagen | VM ejecutándose |

### 2. Docker Hub

Repositorio central donde se almacenan imágenes públicas:
- `nginx:latest` — Servidor web Nginx
- `postgres:15` — Base de datos PostgreSQL
- `node:20` — Runtime de Node.js

Puedes descargar con:
```bash
docker pull nginx:latest
```

### 3. Dockerfile

Archivo de configuración que define cómo construir una imagen personalizada:

```dockerfile
FROM node:20-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 3005
CMD ["npm", "start"]
```

### 4. Docker Compose

Orquestador que permite definir múltiples contenedores en un solo archivo `docker-compose.yml`:

```yaml
version: '3.8'
services:
  backend:
    image: node:20
    ports:
      - "3005:3005"
    volumes:
      - ./backend:/app
  db:
    image: postgres:15
    environment:
      POSTGRES_PASSWORD: secreto
```

---

##  Redes Docker — Aislamiento por Diseño

### Redes Internas

En Ibis Campus, **no exponemos puertos al host innecesariamente**. Los servicios se comunican internamente usando nombres de dominio:

```yaml
services:
  backend:
    networks:
      - crisma_network
  database:
    networks:
      - crisma_network

networks:
  crisma_network:
    driver: bridge
```

Así el backend accede a la BD simplemente con:
```
http://database:5432
```

### Flujo de Tráfico

```
[Cliente en Tailscale IP: 100.107.56.81]
         ↓
[Nginx Proxy Manager — Puerto 80/443]
         ↓
[Backend — Inaccesible directamente]
         ↓
[PostgreSQL — Completamente aislado]
```

Solo el proxy tiene puertos abiertos al exterior.

---

##  Volúmenes — Persistencia de Datos

### El Problema

Los contenedores son efímeros: si los borras, TODO desaparece.

### Bind Mounts (Lo que usamos)

Mapear carpetas del host dentro del contenedor:

```yaml
services:
  nextcloud:
    volumes:
      - /mnt/TFG_CRIMSA/services/nextcloud/data:/var/www/html/data
      - /mnt/TFG_CRIMSA/services/nextcloud/config:/var/www/html/config
```

Así:
- El software corre en Docker
- Los datos viven en el RAID 1 del DAS
- Si reinicio un contenedor, los datos persisten

---

##  Comandos Esenciales

### Gestión de Contenedores

```bash
# Ver contenedores activos
docker ps

# Ver TODOS los contenedores (incluidos apagados)
docker ps -a

# Ver detalles de un contenedor
docker inspect nombre_contenedor

# Ver logs en tiempo real
docker logs -f nombre_contenedor

# Ejecutar comando dentro de un contenedor
docker exec -it nombre_contenedor bash

# Detener/iniciar
docker stop nombre_contenedor
docker start nombre_contenedor

# Eliminar
docker rm nombre_contenedor  # Solo si está apagado
docker rm -f nombre_contenedor  # Forzar
```

### Gestión de Imágenes

```bash
# Ver imágenes descargadas
docker images

# Descargar una imagen
docker pull ubuntu:24.04

# Construir desde Dockerfile
docker build -t mi-imagen:1.0 .

# Eliminar
docker rmi nombre_imagen
```

### Gestión de Docker Compose

```bash
# En el directorio del docker-compose.yml:

# Levantar servicios
docker compose up -d

# Ver estado
docker compose ps

# Ver logs
docker compose logs -f

# Detener
docker compose down

# Detener y eliminar volúmenes
docker compose down -v

# Reconstruir sin caché
docker compose up -d --build
```

### Monitorización

```bash
# Ver uso de recursos en tiempo real
docker stats

# Ver eventos del sistema
docker events
```

---

##  Troubleshooting Común de Docker

### El contenedor no inicia

```bash
# Ver por qué falló
docker logs nombre_contenedor

# Común: puerto ya en uso
docker ps -a | grep :puerto
```

### Permisos de volúmenes

```bash
# El contenedor no puede escribir en el volumen
# Solución: cambiar propietario
sudo chown -R 1000:1000 /mnt/TFG_CRIMSA/services/xxxx/
```

### Red no conecta

```bash
# Verificar que está en la red correcta
docker inspect nombre_contenedor | grep Network

# Probar conectividad interna
docker exec contenedor1 ping contenedor2
```

---

##  Estructura de Docker Compose para Ibis Campus

```yaml
version: '3.8'

services:
  # Reverse Proxy (único punto de entrada)
  nginx-proxy:
    image: jc21/nginx-proxy-manager:latest
    container_name: global-proxy
    restart: unless-stopped
    ports:
      - "80:80"
      - "81:81"
      - "443:443"
    volumes:
      - /mnt/TFG_CRIMSA/services/nginx_proxy/data:/data
    networks:
      - codigo_default

  # Backend API
  backend:
    build: ./backend
    container_name: crisma_back
    restart: unless-stopped
    environment:
      - DB_HOST=crisma_db
      - DB_USER=${DB_USER}
      - DB_PASSWORD=${DB_PASSWORD}
    volumes:
      - /mnt/TFG_CRIMSA/uploads:/app/uploads
    networks:
      - codigo_default
    depends_on:
      - database

  # Base de Datos
  database:
    image: postgres:15-alpine
    container_name: crisma_db
    restart: unless-stopped
    environment:
      - POSTGRES_USER=${DB_USER}
      - POSTGRES_PASSWORD=${DB_PASSWORD}
      - POSTGRES_DB=${DB_NAME}
    volumes:
      - /mnt/TFG_CRIMSA/postgres_data:/var/lib/postgresql/data
    networks:
      - codigo_default

networks:
  codigo_default:
    driver: bridge
```

---

##  Buenas Prácticas

### 1. Usar Tags Específicos

 **Mal:**
```yaml
image: postgres  # ¿Qué versión es?
```

 **Bien:**
```yaml
image: postgres:15-alpine  # Versión explícita
```

### 2. No Correr como Root

 **Mal:**
```dockerfile
# Corre con root por defecto
RUN npm install
```

 **Bien:**
```dockerfile
RUN useradd -m appuser
USER appuser
RUN npm install
```

### 3. Usar .dockerignore

```
# .dockerignore
node_modules
.git
.env
tests
```

### 4. Health Checks

```yaml
healthcheck:
  test: ["CMD", "curl", "-f", "http://localhost:3005"]
  interval: 30s
  timeout: 10s
  retries: 3
```

---

##  Siguientes Pasos

1. **Lee:** `02-infraestructura/03-tailscale-vpn.md` para acceso remoto
2. **Lee:** `02-infraestructura/05-nginx-proxy.md` para el proxy inverso
3. **Practica:** Levanta tu primer `docker-compose up -d`

---

**Tiempo de lectura:** 30 minutos  
**Experiencia requerida:** Principiante  
**Comando para verificar:** `docker --version && docker compose version`
