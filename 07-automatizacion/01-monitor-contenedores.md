# Monitor de Contenedores — Vigilancia Automática

##  Qué Vigila

- `crisma_db` — PostgreSQL
- `crisma_back` — Backend Node.js
- `crisma_front` — Frontend React

##  Alertas

Si un contenedor cae:
1. Se reinicia automáticamente
2. Se envía alerta a Telegram
3. Se registra en logs

## Frecuencia

Cada 5 minutos (`*/5 * * * *`)

