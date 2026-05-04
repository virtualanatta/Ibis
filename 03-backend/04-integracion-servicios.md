# Integración con Otros Servicios

##  Enviar Correos (Mailcow)

```javascript
const nodemailer = require('nodemailer');

const transporter = nodemailer.createTransport({
  host: 'postfix-mailcow',
  port: 25,
  secure: false
});

await transporter.sendMail({
  from: 'campus@ibis.local',
  to: 'alumno@ibis.local',
  subject: 'Nueva tarea',
  html: '<h1>Tienes una nueva tarea</h1>'
});
```

##  Notificaciones Mattermost (Webhook)

```javascript
const axios = require('axios');

await axios.post('http://mattermost:8065/hooks/xxx', {
  text: '📢 Nueva tarea publicada en Seguridad'
});
```

##  Acceso a Nextcloud (WebDAV)

```javascript
const axios = require('axios');

const response = await axios.get(
  'http://nextcloud/remote.php/dav/files/admin/Campus/',
  {
    auth: {username: 'admin', password: 'password'}
  }
);
```

