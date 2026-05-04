# Errores de Red — DNS, Firewall, SSL

##  No Resuelve Dominio

```bash
# Verificar /etc/hosts
cat /etc/hosts

# Debe contener:
100.107.56.81 ibis.local

# Limpiar caché (Windows)
ipconfig /flushdns

# Limpiar caché (Linux)
sudo systemctl restart systemd-resolved
```

##  UFW Bloquea Tráfico

```bash
# Ver reglas
sudo ufw status verbose

# Permitir puerto
sudo ufw allow 80/tcp

# Recargar
sudo ufw reload
```

##  Certificado SSL Inválido

```bash
# Regenerar autofirmado
openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -days 365 -nodes

# En Nginx Proxy Manager:
# Tab SSL → Generate Self Signed
```

##  Tailscale No Conecta

```bash
# Reconectar
sudo tailscale down
sudo tailscale up

# Ver estado
tailscale status

# Obtener IP
tailscale ip -4
```

