# Errores Docker — Contenedores y Redes

##  El Contenedor No Inicia

```bash
# Ver por qué falló
docker logs nombre_contenedor

# Común: Puerto en uso
sudo lsof -i :8080

# Solución: Cambiar puerto en docker-compose.yml
```

##  No Hay Conectividad entre Contenedores

```bash
# Verificar que está en la red
docker inspect nombre_contenedor | grep Network

# Probar ping interno
docker exec contenedor1 ping contenedor2

# Si falla: crear la red
docker network create codigo_default
```

##  Error de Permisos en Volúmenes

```bash
# Cambiar propiedad
sudo chown -R $(id -u):$(id -g) /ruta/volumen

# O para usuario específico
sudo chown -R 1000:1000 /ruta/volumen
```

##  Contenedor Consume 100% CPU/RAM

```bash
# Ver uso en tiempo real
docker stats

# Limitar recursos
memory: 2g
cpus: '1.5'
```

