# Problemas Comunes por Servicio

##  CAMPUS (Frontend/Backend)

| Error | Síntoma | Solución |
|---|---|---|
| Login falla | "Credenciales inválidas" | Ver `03-backend/02-autenticacion.md` |
| 502 Bad Gateway | No carga la página | Nginx apunta a IP incorrecta |
| CORS error | API no responde desde browser | Backend falta `Access-Control-*` headers |

##  MAILCOW

| Error | Síntoma | Solución |
|---|---|---|
| MySQL Errno 13 | Contenedor se reinicia | `sudo chown -R root /mnt/.../mailcow` |
| Correo no envía | El SMTP no responde | Puerto 25 bloqueado por ISP, usar 587 |
| Webmail lento | SOGo tarda en cargar | Aumentar RAM de MySQL |

##  NEXTCLOUD

| Error | Síntoma | Solución |
|---|---|---|
| "Trusted Domains" | No carga por IP | Ejecutar comando `occ config:system:set` |
| Permisos | Error interno al subir | `chown -R 33:33` carpetas |
| 413 Request Too Large | No sube archivos > 100MB | Aumentar `client_max_body_size` en Nginx |

##  MATTERMOST

| Error | Síntoma | Solución |
|---|---|---|
| Mensajes congelados | No aparecen al enviar | WebSockets bloqueados, configurar Nginx |
| Permisos UID 2000 | Contenedor no arranca | `chown -R 2000:2000` datos |
| Contraseña rechazada | "Invalid Password" | Mín 8 caracteres, mayúscula+número |

##  NGINX PROXY

| Error | Síntoma | Solución |
|---|---|---|
| 502 Bad Gateway | Host no responde | Ver `docker logs global-proxy` |
| Límite de subida | 413 Error | Aumentar `client_max_body_size` |
| SSL error | Certificado no válido | Regenerar certificado autofirmado |

##  POSTGRESQL

| Error | Síntoma | Solución |
|---|---|---|
| Conexión rechazada | Backend no conecta | Ver `docker logs crisma_db` |
| Consulta lenta | Usuarios reportan lag | Crear índices, analizar queries |
| Espacio lleno | "Disk quota exceeded" | Hacer backup + limpiar logs |

