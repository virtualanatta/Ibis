# Comandos Docker — Referencia Rápida

## Contenedores

```bash
docker ps                           # Listar activos
docker ps -a                        # Listar todos
docker logs -f contenedor           # Ver logs
docker exec -it contenedor bash     # Entrar en bash
docker stop contenedor              # Detener
docker start contenedor             # Iniciar
docker restart contenedor           # Reiniciar
docker rm contenedor                # Eliminar
docker stats                        # Ver recursos
```

## Docker Compose

```bash
docker compose up -d                # Levantar
docker compose down                 # Detener
docker compose ps                   # Ver estado
docker compose logs -f              # Ver logs
docker compose exec servicio bash   # Entrar en servicio
docker compose restart servicio     # Reiniciar servicio
docker compose build                # Construir imágenes
docker compose pull                 # Descargar imágenes
```

## Imágenes

```bash
docker images                       # Listar imágenes
docker pull imagen:tag              # Descargar
docker build -t nombre .            # Construir
docker rmi imagen                   # Eliminar
docker image inspect imagen         # Detalles
```

## Redes y Volúmenes

```bash
docker network ls                   # Listar redes
docker network create nombre        # Crear red
docker volume ls                    # Listar volúmenes
docker volume inspect volumen       # Ver detalles
```

## Limpieza

```bash
docker system prune                 # Limpiar todo
docker container prune              # Contenedores
docker image prune                  # Imágenes
docker volume prune                 # Volúmenes
```

