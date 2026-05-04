# Endpoints API — Documentación

##  Base URL

```
http://localhost:3005/api
```

##  Usuarios

```
POST   /login              # Login
POST   /register           # Registro
GET    /users/:id          # Obtener usuario
GET    /users              # Listar usuarios (admin)
PUT    /users/:id          # Actualizar
DELETE /users/:id          # Eliminar
```

##  Cursos

```
GET    /cursos             # Listar cursos del usuario
GET    /cursos/:id         # Obtener curso
POST   /cursos             # Crear (profesor)
PUT    /cursos/:id         # Actualizar
DELETE /cursos/:id         # Eliminar
```

##  Tareas y Entregas

```
GET    /tareas             # Listar tareas
POST   /tareas             # Crear (profesor)
GET    /entregas           # Listar entregas del alumno
POST   /entregas           # Entregar tarea
```

## Ejemplo: Login

```bash
curl -X POST http://localhost:3005/api/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "alumno@ibis.local",
    "password": "password123"
  }'

# Respuesta:
{
  "token": "eyJhbGc...",
  "usuario": {"id": 1, "nombre": "Alumno"}
}
```

