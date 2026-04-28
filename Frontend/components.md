# Documentación Técnica Frontend: Componentes Reutilizables

Los componentes son las piezas visuales y funcionales que construyen la interfaz de usuario. En este proyecto, hemos seguido una estructura modular para separar las tareas administrativas de las de navegación y seguridad.

---

## 1. Login.jsx (Punto de Acceso)
Es el componente encargado de la primera interacción con el usuario.
- **Estado Local**: Gestiona `email` y `password` mediante el hook `useState`.
- **Integración**: Llama a `loginRequest` (servicio) y al método `login` (contexto) para establecer la sesión.
- **Navegación Inteligente**: Dependiendo del rol devuelto por el servidor (`alumno`, `profesor` o `admin`), redirige automáticamente al usuario a su panel correspondiente mediante `useNavigate`.

---

## 2. Navbar.jsx & Layout.jsx (Arquitectura Visual)
- **Navbar**: Es la barra superior dinámica. Cambia los enlaces (Inicio, Mensajes) basándose en el rol del usuario guardado en el contexto. Incluye el botón de **Logout** que limpia la sesión.
- **Layout**: Es un componente "envoltorio". Se asegura de que la `Navbar` aparezca siempre en la parte superior y deja un espacio central (`main`) para que las diferentes páginas se rendericen dentro.

---

## 3. ProtectedRoute.jsx (El Guardián de Rutas)
Este es un componente funcional que no renderiza nada visual por sí mismo, sino que actúa como filtro de seguridad.
- **Lógica**: Si un usuario intenta entrar a una URL manualmente (ej: `/admin`) pero no está logueado o su rol no coincide, el componente intercepta la petición y lo expulsa hacia el Login usando `<Navigate to="/" />`.

---

## 4. Componentes de Administración (Panel Admin)

Para mantener el código limpio, el panel de administración se ha dividido en dos piezas:

### AdminUserForm.jsx
- **Propósito**: Formulario para dar de alta a nuevos usuarios.
- **Validación**: Incluye una regla de negocio en el frontend (`isValidPassword`) que obliga a que las contraseñas tengan al menos 8 caracteres antes de permitir el envío al servidor.
- **Estado Dinámico**: Maneja un objeto `form` que captura nombre, apellidos, email, DNI y rol.

### AdminUserTable.jsx
- **Propósito**: Visualización y gestión de la base de datos de usuarios.
- **Badges de Estado**: Incluye funciones (`getRoleClass`, `getStatusClass`) que asignan colores de forma dinámica (ej: Rojo para admin, Verde para activo).
- **Acciones**: Contiene los botones para "Cambiar rol", "Resetear contraseña" y "Desactivar", que disparan las funciones definidas en el servicio de administración.

---

##  Valor Técnico Global
1. **Separación de Responsabilidades**: El formulario (`Form`) no sabe cómo guardar los datos, solo los recolecta. La tabla (`Table`) no sabe cómo obtener los datos, solo los muestra. Esto facilita mucho encontrar errores.
2. **UX Consistente**: El uso de un `Layout` común garantiza que el usuario nunca se sienta perdido al navegar, manteniendo la identidad visual de la "Aula Virtual".
3. **Seguridad Reactiva**: Gracias a `ProtectedRoute`, la seguridad no solo depende del servidor, sino que el frontend bloquea proactivamente el acceso no autorizado.
