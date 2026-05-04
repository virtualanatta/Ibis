# Primer Despliegue — Nginx Proxy

##  Crear docker-compose.yml

Ver contenido completo en: `02-infraestructura/05-nginx-proxy.md`

##  Desplegar

```bash
mkdir -p /mnt/TFG_CRIMSA/services/nginx_proxy/{data,letsencrypt}
cd /mnt/TFG_CRIMSA/services/

# Crear y ejecutar
docker compose up -d global-proxy

# Verificar
docker ps | grep global-proxy
```

##  Acceso

```
http://100.107.56.81:81
Usuario: admin@example.com
Contraseña: changeme

  Cambiar contraseña inmediatamente
```

##  Verificación

Crea tu primer proxy host apuntando a un servicio dummy.

