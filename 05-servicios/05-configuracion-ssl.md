# Configuración SSL/TLS — HTTPS Seguro

##  Certificados Autofirmados

Para desarrollo, Nginx Proxy Manager genera automáticamente:

1. Tab **SSL**
2. Click en **Generate Self Signed**
3. El navegador mostrará advertencia
4. La conexión está cifrada

##  Certificados Let's Encrypt

Para producción con dominio real:

1. Tab **SSL**
2. Click en **Request Certificate**
3. Ingresa email y dominio
4. Let's Encrypt genera automáticamente
5. Se renueva cada 90 días

##  Forzar HTTPS

En cada proxy host:

1. Tab **SSL**
2. Marca **Force SSL**
3. Todos los visitantes son redirigidos a HTTPS

