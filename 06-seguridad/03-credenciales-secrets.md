# Gestión de Credenciales y Secretos

##  Sistema de Almacenamiento Seguro

### 1. Archivo .env (No en Git)

```bash
# .env (permisos 600)
DB_PASSWORD=xxxxx
JWT_SECRET=xxxxx
TELEGRAM_TOKEN=xxxxx
```

```bash
git echo ".env" >> .gitignore
chmod 600 .env
```

### 2. Secretos en Docker

```yaml
services:
  db:
    environment:
      - POSTGRES_PASSWORD=${DB_PASSWORD}
```

### 3. Variables de Entorno Locales

```bash
export DB_PASSWORD="xxxxx"
docker compose up -d
```

### 4. Archivos Externos Protegidos

```bash
sudo mkdir -p /home/gerard/.config/crimsa
sudo chmod 700 /home/gerard/.config/crimsa
sudo nano /home/gerard/.config/crimsa/env
```

---

##  Qué NUNCA Hacer

-  Guardar contraseñas en el código
-  Commitear .env a git
-  Mostrar en logs
-  Usar en URLs
-  Compartir por chat

