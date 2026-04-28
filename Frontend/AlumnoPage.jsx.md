# 🎓 Informe Técnico: Componente `AlumnoPage.jsx`

El archivo `AlumnoPage.jsx` es el componente principal para la interfaz de los estudiantes. Actúa como el centro de mando donde los alumnos pueden consultar las asignaturas en las que están matriculados, descargar apuntes y entregar sus trabajos evaluables. 

Tras una revisión exhaustiva del código, **se confirma que no contiene ningún dato sensible**. Utiliza tokens dinámicos y rutas relativas, por lo que es completamente seguro para ser incluido en tu documentación o presentación.

---

## 1. Gestión de Estados (State Management)

El componente hace un uso inteligente de los estados de React (`useState`) para separar la lógica de navegación de la lógica de subida de archivos:

* **Estados de Navegación y UI**:
    * `cursos`: Almacena el listado de asignaturas a las que el alumno tiene acceso.
    * `busqueda`: Guarda el texto introducido en el buscador para filtrar las asignaturas.
    * `asignaturaSeleccionada`: Determina si el "Aula Virtual" (el modal) debe abrirse y qué curso mostrar.
    * `tabActiva`: Controla qué pestaña del aula está viendo el alumno (Resumen, Materiales o Tareas).

* **Estados de Interacción Documental**:
    * `listaArchivos`: Contiene los PDFs y recursos disponibles en el curso seleccionado.
    * `archivoSeleccionado` y `tareaActivaId`: Identifican exactamente qué archivo físico ha seleccionado el alumno desde su ordenador y a qué tarea específica (ID) corresponde esa entrega.
    * `subiendo`: Un booleano (`true`/`false`) que bloquea el botón de enviar mientras el archivo viaja al servidor, previniendo envíos duplicados.

---

## 2. Lógica de Peticiones (Conexión con el Backend)

El componente se comunica con el servidor a través de tres flujos principales:

### A. Carga de Cursos Segura (El "Paracaídas")
Se utiliza el hook `useEffect` para llamar a `getMisCursosAlumno(user.id)` al cargar la página. 
* **Detalle Técnico**: Implementa una validación crucial (`Array.isArray(data)`). Si por algún motivo el servidor falla y devuelve un texto de error o un objeto en lugar de una lista, el frontend lo detecta y fuerza un array vacío `[]`. Esto evita la clásica pantalla blanca de la muerte en React ("*map is not a function*").

### B. Carga de Contenidos y Filtro de Visibilidad
Cuando el alumno abre un curso, se dispara la función `cargarContenidos()`.
* **Regla de Negocio Crítica**: El frontend aplica un filtro de seguridad: `data.filter(item => item.es_visible === true)`. Aunque el servidor envíe todos los materiales, el alumno **solo** verá aquellos que el profesor haya decidido mostrar, manteniendo ocultos los borradores o exámenes futuros.

### C. Entrega de Tareas (`FormData`)
La función `entregarTarea` es el núcleo de la evaluación:
* Utiliza la API `fetch` y el objeto nativo `FormData` para poder adjuntar el documento físico (`archivoSeleccionado`) junto con datos de texto (el `tipo` de acción, el `tarea_id` y el `alumno_id`).
* Inyecta el Token de seguridad (`Bearer ${token}`) obtenido del `localStorage` para que el backend acepte el archivo.
* Tras un envío exitoso (`res.ok`), limpia los campos y resetea los inputs tipo `file` para que el alumno pueda seguir navegando.

---

## 3. Optimización y Renderizado Visual

* **Filtrado Optimizado (`useMemo`)**:
    La lista de asignaturas que se dibuja en pantalla (`asignaturasFiltradas`) está envuelta en `useMemo`. Esto garantiza que la búsqueda sea extremadamente rápida y fluida, ya que React solo vuelve a filtrar la lista si el usuario escribe algo nuevo en la barra de búsqueda, ahorrando memoria y procesador.
* **Modal a Pantalla Completa (Aula Virtual)**:
    En lugar de redirigir al alumno a otra URL, el aula se abre como una capa superpuesta (`modal-overlay`). Dentro de este modal, el contenido cambia dinámicamente mediante renderizado condicional (`{tabActiva === "materiales" && ... }`), separando claramente los materiales de lectura de los buzones de entrega de ejercicios.

---

## 💡 Resumen de Valor Técnico

El componente `AlumnoPage.jsx` destaca por su **resiliencia y excelente UX (Experiencia de Usuario)**. Protege la aplicación contra caídas mediante validaciones de datos, implementa reglas de negocio estrictas (visibilidad de materiales) y proporciona feedback visual instantáneo (botones de "Enviando...", alertas de éxito/error) durante las operaciones de subida de archivos pesados.
