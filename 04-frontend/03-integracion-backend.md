# Integración con Backend

##  Axios Setup

```javascript
import axios from 'axios';

const api = axios.create({
  baseURL: '/api',
  headers: {
    'Content-Type': 'application/json'
  }
});

// Interceptor para agregar token
api.interceptors.request.use(config => {
  const token = localStorage.getItem('token');
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});
```

##  Llamadas a API

```javascript
// GET
const cursos = await api.get('/cursos/alumno/1');

// POST
await api.post('/tareas', {
  titulo: 'Nueva tarea',
  descripcion: '...'
});

// Error handling
try {
  const datos = await api.get('/datos');
} catch (error) {
  console.error(error.response.data.message);
}
```

##  CORS

El backend debe permitir el origen del frontend:

```javascript
// backend/index.js
const cors = require('cors');
app.use(cors({
  origin: 'http://localhost:5173',
  credentials: true
}));
```

