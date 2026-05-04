# Samba — Acceso a Almacenamiento (SMB)

##  Instalación

```bash
sudo apt install samba samba-common-bin -y
```

##  Configuración

```bash
sudo nano /etc/samba/smb.conf
```

Contenido esencial:

```ini
[global]
   interfaces = lo tailscale0
   bind interfaces only = yes
   server min protocol = SMB3

[TFG_CRIMSA]
   path = /mnt/TFG_CRIMSA
   valid users = gerard
   read only = no
   create mask = 0755
```

##  Usuario Samba

```bash
sudo smbpasswd -a gerard
```

##  Acceso desde Windows

En el Explorador de Archivos:

```
\\100.107.56.81\TFG_CRIMSA
```

Introduce usuario y contraseña Samba.

