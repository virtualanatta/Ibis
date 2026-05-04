# SQL PostgreSQL — Consultas Frecuentes

## Conexión

```bash
psql -U Crisma -d danet -h localhost
```

## Bases de Datos

```sql
\l                                  -- Listar BDs
CREATE DATABASE nombre;             -- Crear BD
DROP DATABASE nombre;               -- Eliminar BD
\c nombre                           -- Conectar a BD
```

## Tablas

```sql
\dt                                 -- Listar tablas
\d+ tabla                           -- Ver estructura
CREATE TABLE nombre (...);          -- Crear tabla
DROP TABLE nombre;                  -- Eliminar tabla
```

## Datos

```sql
SELECT * FROM tabla;                -- Listar datos
SELECT COUNT(*) FROM tabla;         -- Contar filas
INSERT INTO tabla VALUES (...);     -- Insertar
UPDATE tabla SET columna='valor';   -- Actualizar
DELETE FROM tabla WHERE id=1;       -- Borrar
```

## Índices

```sql
CREATE INDEX idx ON tabla(columna); -- Crear índice
DROP INDEX idx;                     -- Eliminar índice
\d tabla                            -- Ver índices
```

## Backups

```bash
pg_dump -U Crisma danet > backup.sql                     # Exportar
psql -U Crisma danet < backup.sql                        # Restaurar
```

