# Certificados SSL/TLS — HTTPS Seguro

##  Tipos de Certificados

### Para Desarrollo (Autofirmados)

Nginx Proxy Manager genera automáticamente:

```
Tab SSL → Generate Self Signed
```

El navegador muestra advertencia, pero está cifrado.

### Para Producción (Let's Encrypt)

Requiere dominio público:

```
Tab SSL → Request Certificate
Email: tu@email.com
Domain: tu-dominio.com
```

---

##  Renovación Automática

Let's Encrypt expira cada 90 días. Nginx Proxy Manager renueva automáticamente.

