# 👨‍🏫 Informe Técnico: Componente `ProfesorPage.jsx`

El archivo `ProfesorPage.jsx` es uno de los componentes más extensos y complejos del Frontend. Actúa como el "Aula Virtual" desde la perspectiva del docente, integrando múltiples funcionalidades en una sola vista tipo *Single Page Application* (SPA) mediante el uso intensivo de modales y estados locales. No contiene datos sensibles, operando con información dinámica obtenida a través de la API.

---

## 1. Gestión de Estados (State Management)

El componente utiliza numerosos *hooks* `useState` para controlar la interfaz dinámica sin recargar la página. Al separar los estados, se garantiza que un cambio en una parte de la pantalla (como escribir en un buscador) no interfiera con otra (como la carga de un archivo).

* **Estados Globales de la Vista**:
    * `asignaturas`: Almacena la lista de cursos impartidos por el profesor (obtenida del backend).
    * `loading`: Controla la visualización del indicador de carga mientras se obtienen datos.
    * `busqueda` y `filtroCurso`: Gestionan los criterios ingresados por el usuario para buscar clases específicas en su panel.
    * `vista`: Alterna la disposición visual entre "Tarjetas" (grid) y "Lista" (list).

* **Estados del Modal (Aula Virtual)**:
    * `asignaturaSeleccionada`: Determina qué curso está abierto actualmente en la ventana modal. Si es `null`, el modal permanece cerrado.
    * `tabActiva`: Controla la navegación interna dentro del modal (Resumen, Materiales, Tareas, Alumnos, Mensajes), permitiendo cambiar de sección de forma fluida.

* **Estados de Gestión Documental**:
    * `listaArchivos`: Guarda los materiales y tareas recuperados de la base de datos para el curso activo.
    * `archivoSeleccionado`, `subiendo`, `mensajeArchivo`: Controlan el ciclo de vida de la subida de un nuevo PDF o documento (selección, proceso de envío y confirmación).

* **Estados de Evaluación**:
    * `entregas`: Almacena las tareas entregadas por los alumnos pendientes de calificación.
    * `seleccionada`: Identifica la tarea específica que el profesor está calificando en ese momento.

---

## 2. Flujo de Datos y Peticiones al Backend (API)

El componente interactúa constantemente con el servidor mediante peticiones asíncronas para mantener la información actualizada:

* **Carga Inicial de Cursos**: Mediante el hook `useEffect`, al renderizarse la página por primera vez, se llama al servicio `getMisCursos(user.id)`. La respuesta puebla el estado `asignaturas`.

* **Carga de Detalles del Curso (Lazy Loading)**: Cuando el profesor hace clic en una asignatura (abriendo el modal), un segundo `useEffect` detecta este cambio y realiza peticiones simultáneas (`Promise.all`) para obtener:
    1. Los materiales y tareas del curso (`/api/cursos/${id}/materiales`).
    2. La lista de alumnos matriculados (`/api/cursos/${id}/alumnos`).
    3. Las entregas realizadas por los alumnos (`/api/cursos/${id}/entregas`).
    
    *Este enfoque optimiza el rendimiento, ya que no carga todos los datos de todos los cursos al inicio, sino solo los del curso que el profesor quiere ver.*

* **Subida de Archivos (FormData)**: La función `handleUpload` utiliza la API nativa `fetch` para enviar archivos binarios. Construye un objeto `FormData` adjuntando el archivo físico, el ID del curso, un título, una descripción y el tipo (`material` o `tarea`).

* **Cambio de Visibilidad**: La función `toggleVisibilidad` envía una petición `PUT` rápida para alternar si un material específico es visible para los alumnos o si permanece oculto como borrador.

---

## 3. Lógica de Filtrado (useMemo)

Para optimizar la búsqueda de asignaturas, el componente implementa el hook `useMemo`:

```javascript
const asignaturasFiltradas = useMemo(() => {
  return asignaturas.filter(a => {
    // Lógica de filtrado por nombre y por grupo (1A, 2B, etc.)
  });
}, [asignaturas, busqueda, filtroCurso]);
```

Esto significa que React solo recalculará la lista de asignaturas visibles cuando el usuario escriba algo en el buscador o cambie el filtro desplegable, ahorrando recursos de procesamiento y haciendo la interfaz más rápida.

---

## 4. Estructura de la Interfaz (Renderizado Condicional)

La interfaz se divide en dos grandes bloques renderizados condicionalmente:

1. **Panel Principal (Fondo)**: Muestra la barra de herramientas (buscador, filtros) y el listado de asignaturas. Utiliza un mapeo dinámico (`asignaturasFiltradas.map`) para generar las tarjetas visuales de cada curso.
2. **Modal del Curso (Superpuesto)**: Solo se renderiza si `asignaturaSeleccionada` tiene datos. Actúa como el "interior" del aula. Su contenido cambia dinámicamente según el valor de `tabActiva`, mostrando diferentes bloques de código (formularios de subida, tablas de alumnos, o listas de archivos) según la pestaña en la que haga clic el profesor.

---

## 💡 Resumen de Valor Técnico

El componente `ProfesorPage.jsx` demuestra una arquitectura Frontend avanzada. Separa claramente la obtención de datos, la gestión del estado complejo y la presentación visual. Su diseño basado en componentes modales y *lazy loading* proporciona una experiencia de usuario (UX) ágil y moderna, similar a las aplicaciones de escritorio.
