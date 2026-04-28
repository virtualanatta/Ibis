## 1. Importaciones

Al principio llamamos a todas las librerias para que Node.js pueda trabajar

- `express` Es el motor principal del servidor web
- `cors` y `helmet` Herramientas de seguridad
- `morgan` Lo que usamod para que nos de los logs
- `path` y `fs` Herramientas para leer carpetas y discos duros
- `multer` El gestor de descargas y subida de archivos
- `db` Conexión directa a la base de datos
- `oidcRoutes` Gestión de autenticación avanzada o externa

## 2. Middelewares

```
const app = express();
app.use(cors({ origin: true, credentials: true }));
app.use(helmet({ crossOriginResourcePolicy: false }));
app.use(morgan("dev"));
app.use(express.json());
app.use(cookieParser());
app.use("/uploads", express.static(path.join(__dirname, "../uploads")));
```

Antes que una peticion llegue a la base de datos pasa por estos filtros

- `cors` Da permiso al frontend para hablar con el backend sin que el navegador bloquee la conexion por seguridad
- `helmet` Oculta detalles técnicos del servidor en las cabeceras HTTP para evitar hackeos
- `express.json` Traduce los datos que manda React en formato texto a objetos JavaScript (req.body) que Node pueda entender
- `cookieParser` Permite al servidor leer las "cookies" del navegador del usuario, algo fundamental para mantener la sesión abierta de forma segura


## 3. Enrutadores Externos

```
app.post("/api/login", authController.login);
app.use("/api/cursos", cursosRoutes);
app.use("/api/admin", adminRoutes);
app.use("/api/auth", oidcRoutes);
```

Aquí el index.js actúa como semáforo. Si alguien intenta hacer Login, lo manda al controlador de autenticación


## 4. Obtener Contenidos de un Curso

```
app.get("/api/contenidos/:cursoId", async (req, res) => { ... }
```

Con esto hacemos dos consultas al mismo tiempo
- Busca todo el material de clase
- Busca todas las tareas

Luego se fusionan en una lista para ser enviados al react


## 5. Subida de Archivos

```
const storage = multer.diskStorage({ ... })
const upload = multer({ storage });
app.post("/api/upload", upload.single("archivo"), async (req, res) => { ... }
```

- `multer.diskStorage` Aqui le dice al servidor que guarde los archivos en `../uploads/*/` ya sea Materias o Tareas
-  También le cambia el nombre al archivo sumándole Date.now() (la fecha en milisegundos) para que si dos alumnos suben un `tarea.pdf`, no se sobrescriban.
- `INSERT INTO` Una vez que Multer ha guardado el PDF físico en el disco duro, el código hace una consulta a PostgreSQL para guardar el título, la descripción y la ruta lógica (archivo_url) para poder encontrarlo después.


## 6. Descargas y Visibilidad

```
app.get("/api/download/materiales/:filename", ...);
app.patch("/api/visibilidad/:tabla/:id", ...);
```

- Descargas: Utiliza la función `res.download(filePath)`, que empaqueta automáticamente el archivo del disco duro y fuerza al navegador del usuario a descargarlo en su ordenador.
- Visibilidad: Es un endpoint dinámico. Usando un simple `UPDATE tabla SET es_visible = $1`, permite a los profesores ocultar o mostrar tareas/materiales con un solo clic como si fuera un interruptor.


## 7. Entregas y Calificaciones

```
app.get("/api/tareas/:tareaId/entregas", ...);
app.patch("/api/entregas/:id/calificar", ...);
```

- Obtener entregas: Usa un `JOIN` con la tabla `usuarios` para que el profesor no solo vea "Se entregó la tarea 4", sino que vea "Harry Potter entregó la tarea 4"
- Calificar: Recibe una nota `nota` y un comentario `comentario_profesor` desde el frontend y actualiza esa fila específica en la base de datos


## 8. El Arranque

```
const PORT = 3000;
app.listen(PORT, () => console.log("Servidor en puerto " + PORT));
```

Esto es para que se quede escucando al puerto 3000 de manera infinita a la espera de peticiones






