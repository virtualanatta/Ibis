# Base de Datos PostgreSQL

##  Esquema Principal (danet)

```sql
-- Usuarios
CREATE TABLE usuarios (
  id SERIAL PRIMARY KEY,
  email VARCHAR UNIQUE,
  password_hash VARCHAR,
  nombre VARCHAR,
  role_id INT
);

-- Cursos
CREATE TABLE cursos (
  id SERIAL PRIMARY KEY,
  nombre VARCHAR,
  profesor_id INT REFERENCES usuarios(id)
);

-- Matrículas
CREATE TABLE matriculas (
  id SERIAL PRIMARY KEY,
  alumno_id INT REFERENCES usuarios(id),
  curso_id INT REFERENCES cursos(id)
);

-- Tareas
CREATE TABLE tareas (
  id SERIAL PRIMARY KEY,
  curso_id INT REFERENCES cursos(id),
  titulo VARCHAR,
  fecha_entrega DATE
);

-- Entregas
CREATE TABLE entregas (
  id SERIAL PRIMARY KEY,
  tarea_id INT REFERENCES tareas(id),
  alumno_id INT REFERENCES usuarios(id),
  archivo_url VARCHAR,
  fecha_entrega TIMESTAMP
);
```

##  Migraciones

```bash
npm install knex
npx knex init
npx knex migrate:make create_usuarios
npx knex migrate:latest
```

