# Mailcow — Servidor de Correo Institucional

##  ¿Por Qué Mailcow?

Mailcow es un **stack completo de correo electrónico** que incluye:
- SMTP/IMAP/POP3 para envío/recepción
- Webmail (SOGo)
- Gestión de usuarios y buzones
- Antispam, antivirus, DKIM
- Base de datos integrada (MariaDB)

---

##  Instalación de Mailcow

### Preparación

```bash
cd /mnt/TFG_CRIMSA/services/
mkdir -p mailcow && cd mailcow

# Clonar el repositorio (rama Master = estable)
git clone https://github.com/mailcow/mailcow-dockerized .

# Permisos
chmod +x generate_config.sh
```

### Generar Configuración

```bash
./generate_config.sh

# Te pide:
# FQDN: ibis.local
# TimeZone: Europe/Madrid
```

### Editar mailcow.conf

```bash
nano mailcow.conf
```

**Cambios críticos:**

```ini
# 1. Cambiar puertos (evitar conflicto con Nginx)
HTTP_PORT=8181
HTTPS_PORT=8444

# 2. Permitir acceso desde Tailscale
HTTP_BIND=0.0.0.0

# 3. Liberar RAM (opcional pero recomendado)
SKIP_CLAMD=y  # Desactiva antivirus para ahorrar 2GB RAM
```

### Despliegue

```bash
docker compose up -d

# Esperar a que levante (2-3 minutos)
docker compose logs -f

# Ver estado
docker compose ps
```

### Acceso al Webmail

```
URL: https://100.107.56.81:8444
Usuario: admin
Contraseña: moohoo (default, cámbiala)
```

---

##  Gestión de Usuarios y Buzones

### Crear Usuario

En el panel de Mailcow:

1. **Menú:** Mailboxes → Add Mailbox
2. **Email:** gerard@ibis.local
3. **Contraseña:** Generada automáticamente
4. **Cuota:** 50 GB (los 4TB permiten tamaños grandes)

### Crear Alias (Reenvío)

```
profesor@ibis.local → gerard@ibis.local
```

### Verificación

Envía un correo a través del webmail:

```
Destinatario: gerard@ibis.local
Asunto: Test Mailcow
```

Debería llegar al instante.

---

##  Configuración de DKIM y SPF

### DKIM (Firmar Correos)

Mailcow genera automáticamente la firma DKIM:

```bash
# Ver la clave pública
cat /mnt/TFG_CRIMSA/services/mailcow/data/conf/rspamd/dkim/ibis.local.txt
```

Copiar el contenido al DNS de tu dominio (si tienes uno).

### SPF (Autenticar Dominio)

Si tienes un dominio `example.com`:

```dns
example.com TXT "v=spf1 mx -all"
```

---

##  Integración con el Campus

El backend del campus envía notificaciones por correo:

```javascript
// backend/src/services/emailService.js

const nodemailer = require('nodemailer');

const transporter = nodemailer.createTransport({
    host: 'postfix-mailcow',      // Nombre del contenedor
    port: 25,                       // SMTP interno
    secure: false,
    tls: { rejectUnauthorized: false }
});

await transporter.sendMail({
    from: 'noreply@ibis.local',
    to: 'alumno@ibis.local',
    subject: 'Notificación del Campus',
    html: '<h1>Tienes una nueva tarea</h1>'
});
```

---

##  Aumentar Cuota de Almacenamiento

Por defecto, Mailcow limita cada buzón a 100MB. Los 4TB nos permiten ser generosos:

### Opción 1: Desde el Panel

1. **Mailboxes** → Selecciona usuario
2. **Quota:** Cambia a 50000 MB (50 GB)

### Opción 2: Vía API REST

```bash
curl -X PUT https://100.107.56.81:8444/api/v1/mailboxes/gerard@ibis.local \
  -H "X-API-Key: $(cat mailcow.conf | grep API_KEY)" \
  -d '{"quota": 52428800}'  # 50GB en kilobytes
```

---

##  Problemas Comunes

### MySQL Errno 13 (Permission Denied)

**Síntoma:** El contenedor mysql-mailcow se reinicia constantemente.

**Causa:** UID/GID mismatch entre host y contenedor.

**Solución:**

```bash
# Corregir permisos
sudo chown -R root:root /mnt/TFG_CRIMSA/services/mailcow
sudo chmod -R 755 /mnt/TFG_CRIMSA/services/mailcow

# Reiniciar
docker compose down -v
docker compose up -d
```

### Redirecciones Infinitas en SOGo

**Síntoma:** El webmail se redirige infinitamente.

**Causa:** Cookie de sesión falla por dirección IP.

**Solución:** Accede a través del archivo `/etc/hosts` local:

```
100.107.56.81 ibis.local mail.ibis.local
```

### Puerto 25 Bloqueado (ISP)

**Síntoma:** Los correos salientes no se envían.

**Causa:** Tu ISP bloquea el puerto 25 saliente.

**Solución:** Configurar autenticación en puerto 587 (TLS):

```javascript
const transporter = nodemailer.createTransport({
    host: 'postfix-mailcow',
    port: 587,
    secure: false,
    auth: {
        user: 'gerard@ibis.local',
        pass: 'tu_contraseña'
    }
});
```

---

##  Configuración Post-Instalación

### Tabla de Checklist

- [ ] Cambiar contraseña admin del panel
- [ ] Crear usuarios principales (admin, gerard, etc.)
- [ ] Aumentar cuota a 50GB por usuario
- [ ] Configurar DKIM en el DNS (si tienes dominio)
- [ ] Probar envío de correos desde el campus
- [ ] Verificar que llegan a la bandeja de entrada

---

##  Siguientes Pasos

1. Lee: `05-servicios/01-nextcloud-almacenamiento.md` para almacenamiento colaborativo
2. Prueba: Envía un correo desde el webmail a ti mismo
3. Integra: Conecta el backend para enviar notificaciones

---

**Tiempo de lectura:** 20 minutos  
**Experiencia requerida:** Intermedio  
**Verificación:** `docker compose ps | grep mailcow`
