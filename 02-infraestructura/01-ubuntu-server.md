# Ubuntu Server 24.04 — Instalación y Hardening

## 🚀 Instalación Básica

1. Descarga ISO desde ubuntu.com
2. Crea USB booteable
3. Instala en el NUC
4. Opciones recomendadas:
   - LVM: SÍ
   - SSH: SÍ
   - Actualizaciones automáticas: SÍ

## 🔐 Hardening

```bash
# Actualizar sistema
sudo apt update && sudo apt upgrade -y

# Instalar fail2ban
sudo apt install fail2ban -y

# Configurar SSH seguro
sudo nano /etc/ssh/sshd_config
# Cambiar: PermitRootLogin no
# Cambiar: PasswordAuthentication no (si usas claves)

# Habilitar firewall
sudo ufw enable
```

## 🔧 Configuración Post-Instalación

```bash
# Cambiar hostname
sudo hostnamectl set-hostname ibis-campus

# Sincronizar tiempo
sudo timedatectl set-timezone Europe/Madrid

# Crear usuario docker
sudo usermod -aG docker tu_usuario
```

