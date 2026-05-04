# Diagnóstico Avanzado — Logs y Herramientas

##  Ver Logs en Tiempo Real

```bash
# Todo en un servicio
docker compose logs -f servicio

# Con filtro
docker compose logs -f backend | grep ERROR

# Últimas 50 líneas
docker compose logs --tail 50 servicio

# Con timestamp
docker compose logs -f --timestamps servicio
```

##  Herramientas de Diagnóstico

```bash
# Ver uso de recursos
docker stats

# Inspeccionar contenedor
docker inspect nombre_contenedor

# Ver eventos del sistema
docker events

# Analizar imagen
docker history imagen

# Verificar imagen
docker image inspect imagen
```

##  Pruebas de Conectividad

```bash
# Ping dentro de red Docker
docker exec contenedor ping otro_contenedor

# Curl a un servicio
docker exec nginx curl http://backend:3005

# Verificar puerto abierto
sudo lsof -i :puerto
```

##  Limpieza de Sistema

```bash
# Eliminar contenedores detenidos
docker container prune

# Eliminar imágenes sin usar
docker image prune

# Limpiar todo (CUIDADO)
docker system prune
```

