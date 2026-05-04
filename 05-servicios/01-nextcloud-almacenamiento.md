# Nextcloud — Almacenamiento Colaborativo (Nube Ibis)

##  ¿Qué es Nextcloud?

Una plataforma de **almacenamiento privado** que permite:
- Guardar archivos en el DAS (4 TB)
- Compartir documentos entre alumnos
- Colaborar en tiempo real (con Collabora)
- Sincronizar archivos como Dropbox

---

##  Instalación Rápida

### docker-compose.yml

```yaml
version: '3'
services:
  nextcloud-db:
    image: mariadb:11
    container_name: nextcloud-mysql
    restart: always
    volumes:
      - /mnt/TFG_CRIMSA/services/nextcloud/db:/var/lib/mysql
    environment:
      MYSQL_DATABASE: nextcloud
      MYSQL_USER: nextcloud
      MYSQL_PASSWORD: cambiar_esto
      MYSQL_ROOT_PASSWORD: cambiar_esto

  nextcloud:
    image: nextcloud:latest
    container_name: nextcloud-mailcow
    restart: always
    depends_on:
      - nextcloud-db
    volumes:
      - /mnt/TFG_CRIMSA/services/nextcloud/data:/var/www/html/data
      - /mnt/TFG_CRIMSA/services/nextcloud/config:/var/www/html/config
    environment:
      MYSQL_DATABASE: nextcloud
      MYSQL_USER: nextcloud
      MYSQL_PASSWORD: cambiar_esto
      MYSQL_HOST: nextcloud-mysql
      NEXTCLOUD_ADMIN_USER: admin
      NEXTCLOUD_ADMIN_PASSWORD: admin123
    networks:
      - mailcow-network
```

### Despliegue

```bash
docker compose up -d
docker compose logs -f  # Esperar a que termine (2-3 min)
```

---

##  Configuración Post-Instalación

### Acceder

```
URL: http://100.107.56.81/nube.ibis.local/
Usuario: admin
Contraseña: admin123
```

### Crear Usuarios

**Menú:** Admin → Users

Crear un usuario por alumno/profesor:

```
Username: alumno1
Email: alumno1@ibis.local
Password: generada automáticamente
```

### Crear Carpetas Compartidas

**Menú:** Admin → Group Folders

Para ASIR 2:

```
Folder Name: 2509_ASIX_0378_Seguretat
Quota: 100 GB
Groups: [Asigna el grupo de alumnos]
```

---

##  Problemas Comunes y Soluciones

### Error "Trusted Domains"

**Síntoma:** "Access through untrusted domain"

**Solución:**

```bash
docker exec --user www-data nextcloud-mailcow php occ config:system:set trusted_domains 1 --value="nube.ibis.local"
docker exec --user www-data nextcloud-mailcow php occ config:system:set trusted_proxies 0 --value="100.107.56.81"
```

### Permisos www-data (UID 33)

**Síntoma:** "Error interno del servidor" al subir archivos

**Solución:**

```bash
sudo chown -R 33:33 /mnt/TFG_CRIMSA/services/nextcloud/data
sudo chown -R 33:33 /mnt/TFG_CRIMSA/services/nextcloud/config
```

### Limite de Subida (413 Entity Too Large)

En Nginx, configurar en "Advanced":

```nginx
client_max_body_size 512M;
```

---

##  Siguientes Pasos

1. Crea usuarios de prueba
2. Sube un archivo
3. Comparte una carpeta
4. Prueba sincronización desde tu PC

---

**Tiempo de lectura:** 15 minutos  
**Experiencia requerida:** Principiante  
**Verificación:** `docker exec nextcloud-mailcow curl localhost`
