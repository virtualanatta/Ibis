# Modelo de Seguridad — Estrategia Completa

## 🛡️ Principios Fundamentales

### 1. Exposición Cero
-  Ningún puerto abierto a Internet
-  Acceso únicamente vía Tailscale VPN
-  Firewall UFW bloqueando entrada por defecto

### 2. Defensa en Capas

```
Internet
   ↓
Router ISP [Firewall bloqueando]
   ↓
Tailscale VPN [Cifrado WireGuard]
   ↓
UFW Firewall [Reglas Linux]
   ↓
Docker [Aislamiento de contenedores]
   ↓
Servicios Internos [Base de datos, APIs, etc.]
```

### 3. Principio de Mínimo Privilegio
- Cada servicio solo accede a lo que necesita
- Contenedores sin permisos root
- Contraseñas complejas y únicas
- Tokens con expiración

---

##  Arquitectura de Seguridad

### Nivel 1: Perímetro (Router)
- Firewall activo
- UPnP deshabilitado
- Port forwarding deshabilitado
- Sin puertos abiertos

### Nivel 2: Red (UFW + Tailscale)
- UFW deny incoming por defecto
- Permettir solo Tailscale
- SSH accesible solo por VPN
- Samba solo en Tailscale

### Nivel 3: Aplicación (Docker)
- Redes internas privadas
- Contenedores sin permisos root
- Volúmenes con permisos restrictivos
- Variables de entorno para secretos

### Nivel 4: Datos (Base de Datos)
- PostgreSQL sin exposición
- Contraseñas hasheadas (bcrypt)
- JWT para autenticación
- SSL/TLS para comunicaciones

---

##  Gestión de Credenciales

### Dónde NO Guardar
 En el código fuente
 En git
 En URLs visibles
 En logs públicos

### Dónde SÍ Guardar
 Variables de entorno (.env)
 Archivos con permisos 600
 Secrets en contenedores
 Vault/gestores de secretos

### Ejemplo Correcto

```bash
# .env (permisos 600)
DB_PASSWORD=cambiar_esto_en_produccion

# docker-compose.yml
environment:
  - DB_PASSWORD=${DB_PASSWORD}

# Nunca exponer en logs
```

---

##  Checklist de Seguridad

- [ ] Router: Firewall activo, sin puertos abiertos
- [ ] UFW: Configurado, allow Tailscale
- [ ] Tailscale: Instalado y conectado
- [ ] Docker: Redes internas privadas
- [ ] Contraseñas: Complejas, cambiadas por defecto
- [ ] SSH: Solo por Tailscale
- [ ] Certificados: SSL válidos o autofirmados
- [ ] Backups: Encriptados y fuera del servidor
- [ ] Auditoría: Logs activos
- [ ] Monitorización: Alertas configuradas

---

##  Incidentes Detectados y Resueltos

### Acceso SSH No Autorizado
**Síntoma:** Notificación de Telegram de login desde IP desconocida
**Solución:** Firewall + Tailscale bloqueó el acceso
**Lección:** Nunca abras SSH directamente

### Intento de Brute Force
**Síntoma:** 100+ intentos de login fallidos
**Solución:** fail2ban habría bloqueado, pero UFW previene el acceso
**Lección:** Los logs revelan ataques

### Overflow de Almacenamiento
**Síntoma:** Disco lleno, servicios degradados
**Solución:** Limpieza automática de backups antiguos
**Lección:** Monitorizar espacio continuamente

---

##  Siguientes Pasos

Lee: `06-seguridad/01-auditoria-activa.md`
