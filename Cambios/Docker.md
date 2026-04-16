## Docker y configuración del entorno

El sistema se ejecuta mediante contenedores Docker, lo que permite aislar cada uno de los servicios y facilitar su despliegue y mantenimiento.

### Contenedores utilizados

Durante el desarrollo se identificaron los siguientes contenedores principales:

- **Backend:** `crisma_back`
- **Frontend:** `crisma_front`
- **Base de datos:** `crisma_db`

Cada uno de ellos cumple una función específica dentro de la arquitectura del sistema.

---

### Configuración de puertos

Se configuró una redirección de puertos para permitir el acceso a los servicios desde el exterior del contenedor.

En el caso del backend:

```
3005 -> 3000
```
Esto significa que:
El servidor Node.js escucha internamente en el puerto 3000
El acceso desde el host se realiza a través del puerto 3005
Por este motivo, todas las peticiones desde el frontend o desde herramientas como curl deben dirigirse a:
```
http://localhost:3005
```
---
### Reinicio de servicios
Durante el desarrollo fue necesario reiniciar los contenedores para aplicar cambios en el código.
El backend se reinicia mediante:
```
docker restart crisma_back
```
Y el frontend mediante:
```
docker restart crisma_front
```
---
#### Verificación de funcionamiento
Para comprobar que el backend funciona correctamente, se realizaron pruebas mediante curl, por ejemplo:
```
curl http://localhost:3005/api/cursos/profesor/22
```
Estas pruebas permiten verificar que los endpoints devuelven datos correctamente antes de integrarlos en el frontend.
---
#### Resultado
El uso de Docker ha permitido:
Aislar correctamente los servicios del sistema
Gestionar fácilmente los reinicios y pruebas
Mantener una configuración estable del entorno de desarrollo

