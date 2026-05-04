# Tailscale — VPN Privada WireGuard

##  Instalación en Servidor

```bash
curl -fsSL https://tailscale.com/install.sh | sh
sudo tailscale up
```

Sigue el enlace para loguear con tu cuenta Tailscale.

##  Instalación en Cliente

1. Descarga desde tailscale.com/download
2. Instala en Windows/Mac/Linux
3. Loguea con la misma cuenta

##  Verificación

```bash
# En servidor
tailscale ip -4
# Output: 100.107.56.81

# Desde cliente
ping 100.107.56.81
# Debe responder
```

##  Ventajas

-  Acceso remoto sin abrir puertos
-  Cifrado WireGuard de alta velocidad
-  Funciona a través de firewalls
-  Gratuito para uso personal

