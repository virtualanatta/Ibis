# 🗺️ Documentación Técnica Frontend: AppRouter.jsx

El archivo `AppRouter.jsx` es el componente central de navegación de la aplicación React. Utiliza la librería `react-router-dom` para gestionar el enrutamiento del lado del cliente (Client-Side Routing), permitiendo navegar entre páginas sin tener que recargar el navegador.

---

## 1. Importaciones Principales

```jsx
import { BrowserRouter, Routes, Route, Navigate } from "react-router-dom";
import Login from "../components/Login";
import AlumnoPage from "../pages/AlumnoPage";
import ProfesorPage from "../pages/ProfesorPage";
import AdminPage from "../pages/AdminPage";
import ProtectedRoute from "../components/ProtectedRoute";
```

- **`BrowserRouter`**: Es el componente envoltorio que habilita la navegación HTML5 History API. Escucha los cambios en la barra de direcciones del navegador.
- **`Routes` y `Route`**: Definen los caminos (URLs) y qué componente visual (Página) debe dibujarse cuando la URL coincide.
- **Componentes de Página**: Importa las vistas completas (`Login`, `AlumnoPage`, `ProfesorPage`, etc.) que se mostrarán en la pantalla.
- **`ProtectedRoute`**: Un componente "Guardián" personalizado que envuelve a las rutas privadas para verificar si el usuario tiene permiso para entrar.

---

## 2. Estructura de Navegación

El enrutador define un árbol de rutas claro y protegido:

### Ruta Pública (Login)
```jsx
<Route path="/" element={<Login />} />
```
- Es la página de inicio. Cualquiera que entre a `midominio.com/` verá el formulario de inicio de sesión.

### Rutas Privadas y Protección por Rol (RBAC)
La aplicación implementa un sistema de control de acceso basado en roles (Role-Based Access Control) utilizando el componente `<ProtectedRoute>`.

```jsx
<Route path="/alumno" element={
  <ProtectedRoute role="alumno">
    <AlumnoPage />
  </ProtectedRoute>
} />
```
- **Lógica de Protección**: Al intentar acceder a `/alumno`, React no carga `AlumnoPage` directamente. Primero ejecuta `<ProtectedRoute>`. Si el usuario no está logueado o su rol no es "alumno", el guardián bloqueará el acceso y lo redirigirá (generalmente de vuelta al Login).
- **Escalabilidad**: Se aplica la misma lógica de protección estricta para `/profesor` y `/admin`.

### Ruta Comodín (Catch-all)
```jsx
<Route path="*" element={<Navigate to="/" />} />
```
- El asterisco (`*`) atrapa cualquier URL que no exista en el sistema (por ejemplo: `midominio.com/pagina-inventada`). En lugar de mostrar una pantalla en blanco o un error 404 feo, utiliza `<Navigate>` para redirigir automáticamente al usuario a la página de Login segura.

---

## 💡 Valor Técnico del Archivo (Para la presentación)
1. **Seguridad Frontend**: Al envolver las vistas sensibles con `ProtectedRoute`, nos aseguramos de que un alumno no pueda escribir `/admin` en su navegador y ver el panel de control. 
2. **Experiencia de Usuario (UX) tipo SPA (Single Page Application)**: Gracias a `BrowserRouter`, la transición entre el Login y el panel del alumno es instantánea, sin recargas de página completas, dando la sensación de una aplicación nativa.
3. **Mantenibilidad**: Si en el futuro se quiere añadir un panel para "Padres", solo hay que añadir un nuevo bloque `<Route>` protegido, sin tener que alterar el resto de la aplicación.
