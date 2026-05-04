# Errores de Base de Datos — PostgreSQL

##  Conexión Rechazada

```bash
# Verificar que está UP
docker ps | grep crisma_db

# Entrar en el contenedor
docker exec -it crisma_db bash

# Probar conexión
psql -U Crisma -d danet
```

##  Contraseña Incorrecta

```bash
# Ver contraseña en
cat .env | grep DB_PASSWORD

# Cambiarla en PostgreSQL
ALTER USER Crisma WITH PASSWORD 'nueva_pass';
```

##  Consultas Lentas

```bash
# Crear índices
CREATE INDEX idx_nombre ON tabla(columna);

# Analizar tabla
ANALYZE tabla;
```

##  Espacio Disco Lleno

```bash
# Ver tamaño de bases de datos
SELECT datname, pg_size_pretty(pg_database_size(datname)) FROM pg_database;

# Hacer backup y restaurar
```

