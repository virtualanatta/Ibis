# Comandos Linux — Bash y Utilidades

## Navegación

```bash
ls -la                              # Listar archivos
cd directorio                       # Cambiar directorio
pwd                                 # Directorio actual
find . -name "*.log"                # Buscar archivos
```

## Archivos

```bash
cat archivo                         # Mostrar contenido
nano archivo                        # Editar archivo
chmod 600 archivo                   # Cambiar permisos
chown usuario:grupo archivo         # Cambiar propietario
```

## Sistema

```bash
sudo systemctl status ssh           # Ver servicio
sudo systemctl restart ssh          # Reiniciar servicio
sudo ufw status                     # Ver firewall
sudo ufw allow 22                   # Permitir puerto
mount                               # Ver montajes
df -h                               # Espacio en disco
free -h                             # Memoria disponible
```

## Red

```bash
ping 8.8.8.8                        # Prueba conectividad
curl http://ejemplo.com             # Hacer petición HTTP
netstat -tlnp                       # Puertos escuchando
ss -tlnp                            # Alternativa netstat
```

## Usuarios

```bash
whoami                              # Usuario actual
sudo su -                           # Convertirse en root
sudo usermod -aG docker usuario     # Añadir a grupo
```

## Procesos

```bash
ps aux | grep procesos              # Listar procesos
top                                 # Monitor en tiempo real
htop                                # Top mejorado
kill -9 PID                         # Matar proceso
```

