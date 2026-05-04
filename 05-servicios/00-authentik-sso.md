# Authentik — Identity Provider (SSO)

##  ¿Qué es Authentik?

Servidor de identidad que permite:
- Login SSO unificado
- OIDC/OAuth 2.0
- Autenticación centralizada
- 2FA (autenticación de dos factores)

##  Despliegue

```yaml
services:
  authentik:
    image: ghcr.io/goauthentik/server:latest
    ports:
      - "9000:9000"
    environment:
      - AUTHENTIK_SECRET_KEY=xxx
      - AUTHENTIK_POSTGRESQL__PASSWORD=xxx
```

##  Configuración

1. Accede a http://100.107.56.81:9000
2. Crea aplicación OIDC para cada servicio
3. Obtén Client ID y Secret
4. Configura en cada aplicación

##  Integración

Cada servicio (Campus, Nextcloud, Mattermost) se conecta a Authentik como proveedor OIDC.

