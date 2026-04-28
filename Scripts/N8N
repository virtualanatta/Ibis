# N8N: Orquestador de Seguridad Automatizada

## Visión General

n8n actúa como el cerebro de decisión entre el servidor y el administrador. Conecta los eventos de seguridad detectados por IbisScripts con el canal de comunicación en Telegram, permitiendo recibir alertas enriquecidas y responder con acciones reales sobre el servidor directamente desde el móvil, sin necesidad de abrir una terminal.

El sistema se estructura en dos flujos independientes:

- **Rama A — Notificación:** Del servidor al móvil (alerta + contexto + botones de acción).
- **Rama B — Respuesta:** Del móvil al servidor (ejecución de la acción elegida).

## Parte 1: Canal de Comunicación Telegram

Antes de desplegar n8n, se necesita un bot de Telegram configurado. Actúa como el mensajero entre el servidor y el administrador.

### 1.1. Creación del Bot

- Buscar en Telegram el usuario `@BotFather`.
- Escribir `/newbot`.
- Asignar un nombre descriptivo (por ejemplo: `Ibis_Seguridad_Bot`) y un nombre de usuario único.
- BotFather devuelve el **Token de acceso**, un código largo del tipo:

```text
XXXXXXXXXX:AAGc...
```

Este token es la credencial que permite a n8n y a los scripts enviar mensajes a través del bot. Debe guardarse en un lugar seguro y nunca incluirlo en el código fuente.

### 1.2. Obtención del Chat ID

El bot necesita saber a qué cuenta enviar los mensajes.

- Buscar en Telegram el usuario `@userinfobot`.
- Enviar cualquier mensaje.
- El bot responde con un número; ese es el **Chat ID** del administrador.

Ambos valores (token y Chat ID) se guardan en el archivo de entorno del servidor, nunca en los propios scripts.

## Parte 2: Infraestructura de Scripts en el Servidor

### 2.1. Directorio de Trabajo

```bash
mkdir -p /mnt/TFG_CRIMSA/01_PROYECTO/scripts/IbisScripts
```

### 2.2. Archivo de Entorno Seguro

Las credenciales de Telegram se almacenan en un archivo oculto fuera del directorio del proyecto, de modo que nunca queden expuestas en el repositorio:

```bash
mkdir -p /home/gerard/.config/crimsa
nano /home/gerard/.config/crimsa/env
```

Contenido del archivo:

```bash
TELEGRAM_TOKEN="<tu_token_aquí>"
ID_CHAT="<tu_chat_id_aquí>"
```

Todos los scripts cargan este archivo con `source` al inicio:

```bash
source /home/gerard/.config/crimsa/env
```

### 2.3. Protección Anti-Autobloqueo en defensa.sh

El script de defensa incluye un filtro que impide bloquear rangos de IP propios. En particular, protege el rango de Tailscale (`100.x.x.x`) para evitar que el administrador se quede sin acceso al servidor por error al bloquear su propia VPN:

```bash
if echo "$OBJETO" | grep -qE '^100\.'; then
    bash "$BOT" "⛔ PROTECCIÓN: No se puede bloquear el rango Tailscale (${OBJETO})."
    exit 1
fi
```

## Parte 3: Despliegue de n8n con Docker

n8n se despliega como contenedor Docker para facilitar su mantenimiento y portabilidad.

### 3.1. Comando de Instalación

```bash
sudo docker run -d \
    --name n8n_ibis \
    --restart unless-stopped \
    -p 5678:5678 \
    -e N8N_USE_TUNNEL=true \
    -v /mnt/TFG_CRIMSA/05_SISTEMA/n8n_data:/home/node/.n8n \
    n8nio/n8n
```

La opción `-e N8N_USE_TUNNEL=true` activa el túnel HTTPS interno de n8n, que genera automáticamente una URL pública del tipo:

```text
https://nombre-aleatorio.hooks.n8n.cloud
```

Esto es necesario porque Telegram exige HTTPS para los webhooks, y la IP privada del servidor no dispone de certificado SSL propio.

### 3.2. Error de Permisos — EACCES: permission denied

**Síntoma:** el contenedor arranca pero falla inmediatamente. Los logs muestran:

```text
Error: EACCES: permission denied, mkdir '/home/node/.n8n'
```

**Causa:** n8n ejecuta internamente con el usuario `node` (UID 1000), pero la carpeta de datos fue creada por `root` y no tiene permisos de escritura para ese usuario.

**Solución:**

```bash
sudo chown -R 1000:1000 /mnt/TFG_CRIMSA/05_SISTEMA/n8n_data
sudo docker restart n8n_ibis
```

## Parte 4: Configuración de los Flujos en n8n

Acceder a la interfaz web de n8n en `http://localhost:5678` (o por la URL del túnel) para crear los dos flujos.

### Rama A — Notificación: Del Servidor al Móvil

Este flujo recibe un evento de seguridad, enriquece la información con geolocalización de la IP y envía un mensaje con botones de acción al administrador.

#### Nodo 1: Webhook (punto de entrada)

| Campo          | Valor            |
|----------------|------------------|
| HTTP Method    | POST             |
| Path           | `alerta-seguridad` |

La URL completa del endpoint queda como:

```text
https://nombre-aleatorio.hooks.n8n.cloud/webhook/alerta-seguridad
```

Esta URL es la que los scripts IbisScripts utilizan para disparar el flujo.

#### Nodo 2: HTTP Request (geolocalización de IP)

Consulta una API pública para obtener la ubicación geográfica de la IP atacante.

| Campo  | Valor                                              |
|--------|----------------------------------------------------|
| Method | `GET`                                              |
| URL    | `http://ip-api.com/json/{{ $json.ip }}`           |

Devuelve datos como ciudad, región y país, que se incluyen en el mensaje de alerta para dar contexto inmediato.

#### Nodo 3: Telegram — Envío con Botones de Acción

| Campo        | Valor                              |
|--------------|------------------------------------|
| Resource     | `Message`                          |
| Operation    | `Send Message`                     |
| Reply Markup | `Inline Keyboard`                  |

**Botones configurados:**

| Botón | Label            | Callback Data                |
|-------|------------------|------------------------------|
| 1     | 🛡️ Bloquear IP   | `bloquear_{{ $json.ip }}`    |
| 2     | 🚪 Expulsar Usuario | `expulsar_{{ $json.usuario }}` |

El administrador recibe en Telegram: descripción del evento, IP de origen, ubicación geográfica y los botones para actuar.

### Rama B — Respuesta: Del Móvil al Servidor

Este flujo escucha los botones pulsados en Telegram y ejecuta la acción correspondiente en el servidor.

#### Nodo 1: Telegram Trigger (escucha de botones)

| Campo        | Valor               |
|--------------|---------------------|
| Trigger On   | `On callback query` |

Se activa únicamente cuando el administrador pulsa uno de los botones del mensaje de alerta. Cualquier otro mensaje del bot se ignora.

#### Nodo 2: SSH — Ejecución de la Acción

Configura la conexión al servidor:

| Campo          | Valor                                   |
|----------------|-----------------------------------------|
| Host           | IP del servidor (Tailscale recomendado) |
| Username       | `gerard`                                |
| Authentication | Contraseña o clave SSH                  |

Comando ejecutado:

```bash
sudo /mnt/TFG_CRIMSA/01_PROYECTO/scripts/IbisScripts/defensa.sh \
    {{ $json.data.split('_') }} \
    {{ $json.data.split('_') }}
```

El `callback_data` del botón (`bloquear_8.8.8.8`) se divide en acción y objeto, que `defensa.sh` recibe como parámetros `$1` y `$2`.

## Parte 5: Permisos Finales — Sudo sin Contraseña

Cuando n8n ejecuta el comando SSH, el servidor solicitaría la contraseña de `sudo` de forma interactiva. Como el proceso es automático, esto bloquearía la ejecución indefinidamente.

La solución es conceder permiso de ejecución sin contraseña únicamente para ese script específico, aplicando el principio de mínimo privilegio:

```bash
sudo visudo
```

Añadir al final del archivo:

```text
gerard ALL=(ALL) NOPASSWD: /mnt/TFG_CRIMSA/01_PROYECTO/scripts/IbisScripts/defensa.sh
```

Solo ese script puede ejecutarse sin contraseña. Ningún otro comando `sudo` queda desbloqueado.

## Parte 6: Verificación del Sistema

Para confirmar que todo el flujo funciona correctamente, se lanza una simulación desde la terminal del servidor enviando un evento de prueba al webhook:

```bash
curl -X POST \
     -H "Content-Type: application/json" \
     -d '{"evento": "Test", "ip": "8.8.8.8", "usuario": "intruso"}' \
     http://localhost:5678/webhook/alerta-seguridad
```

### Resultado esperado paso a paso

- En n8n: el nodo Webhook se pone en verde — ha recibido el evento.
- En Telegram: llega un mensaje con la ubicación de `8.8.8.8` (California, USA) y los botones de acción.
- Al pulsar **Bloquear IP**: el nodo SSH se pone en verde — ha ejecutado `defensa.sh`.
- En el servidor: la IP aparece en la lista de reglas del firewall:

```bash
sudo ufw status | grep 8.8.8.8
```

Si los cuatro pasos se cumplen, el sistema está operativo de extremo a extremo.

## Diagrama de Flujo Completo

```text
[IbisScripts / guardian.sh]
         │
         │  POST JSON {"ip", "usuario", "evento"}
         ▼
[n8n Webhook — alerta-seguridad]
         │
         │  GET ip-api.com/json/<ip>
         ▼
[Geolocalización — ciudad, país]
         │
         │  Mensaje + botones inline
         ▼
[Telegram — Móvil del Administrador]
         │
         │  Pulsa botón → callback_data: "bloquear_<ip>"
         ▼
[n8n Telegram Trigger — callback query]
         │
         │  SSH → defensa.sh bloquear <ip>
         ▼
[Servidor — UFW bloquea la IP]
         │
         │  Telegram: "🛡️ IP BLOQUEADA: <ip>"
         ▼
[Confirmación en el móvil]
```
