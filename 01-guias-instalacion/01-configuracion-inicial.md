# Configuración Inicial del Servidor

## Resolver DNS Local

### En Windows

Abre `C:\Windows\System32\drivers\etc\hosts` como Admin:

```
100.107.56.81 ibis.local
100.107.56.81 auth.ibis.local
100.107.56.81 nube.ibis.local
100.107.56.81 chat.ibis.local
100.107.56.81 mail.ibis.local
```

Guarda y ejecuta en Terminal (Admin):

```cmd
ipconfig /flushdns
```

### En Linux

```bash
sudo nano /etc/hosts

# Añade las mismas líneas

sudo systemctl restart systemd-resolved
```

## Montaje del DAS

```bash
# Identificar dispositivo
lsblk

# Crear punto de montaje
sudo mkdir -p /mnt/TFG_CRIMSA

# Montar (temporal)
sudo mount /dev/sda1 /mnt/TFG_CRIMSA

# Montaje permanente: editar /etc/fstab
sudo nano /etc/fstab

# Añadir línea:
# /dev/sda1 /mnt/TFG_CRIMSA ext4 defaults 0 0

# Remontarla
sudo mount -a
```

##  Configuración de Tailscale

Ver `02-infraestructura/03-tailscale-vpn.md`

##  Firewall Inicial

```bash
# Reglas básicas
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw allow http
sudo ufw allow https
sudo ufw allow in on tailscale0
sudo ufw enable
```

