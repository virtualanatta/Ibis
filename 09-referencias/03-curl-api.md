# Curl — Testing de APIs

## Peticiones Básicas

```bash
curl http://localhost:3005                          # GET simple
curl -X POST http://localhost:3005/api/login \
  -H "Content-Type: application/json" \
  -d '{"user":"admin","pass":"xxx"}'               # POST

curl -H "Authorization: Bearer TOKEN" \
  http://localhost:3005/api/datos                  # GET con token
```

## Headers Comunes

```bash
-H "Content-Type: application/json"                # JSON
-H "Authorization: Bearer token"                   # JWT
-H "X-API-Key: key123"                            # API Key
```

## Métodos HTTP

```bash
-X GET                                             # GET
-X POST                                            # POST
-X PUT                                             # PUT
-X DELETE                                          # DELETE
```

## Opciones Útiles

```bash
-v                                                 # Verbose
-o archivo                                         # Guardar respuesta
-d "datos"                                         # Enviar datos
-F "file=@archivo.txt"                            # Enviar archivo
```

## Ejemplos Reales

```bash
# Login en el campus
curl -X POST http://ibis.local/api/login \
  -H "Content-Type: application/json" \
  -d '{"email":"usuario@ibis.local","password":"xxx"}' \
  | jq .

# Crear usuario en Mailcow
curl -X POST https://mail.ibis.local:8444/api/v1/mailboxes \
  -H "X-API-Key: xxxxx" \
  -d '{"email":"nuevo@ibis.local","password":"xxx"}'
```

