# 🌐 Documentación Técnica Frontend: Capa de Servicios (API Clients)

En la arquitectura de nuestra aplicación React, la **Capa de Servicios** actúa como un puente de comunicación entre las interfaces de usuario (Frontend) y el servidor Node.js (Backend).

Su objetivo principal es abstraer la lógica de las peticiones HTTP (`axios` o `fetch`), la gestión de errores y el manejo de tokens de seguridad, manteniendo los componentes visuales limpios y enfocados únicamente en renderizar la interfaz.

---

## 1. authService.js (Servicio de Autenticación)

Es el servicio más crítico, encargado de iniciar la sesión del usuario y guardar sus credenciales de acceso.

```javascript
export const loginRequest = async (email, password) => {
  try {
    const response = await axios.post(`${API_URL}/login`, { email, password });
    if (response.data.token) {
      localStorage.setItem('token', response.data.token);
    }
    return response.data; 
  } catch (error) { ... }
};
```
- **Persistencia de Sesión**: Cuando el backend valida las credenciales y devuelve un token JWT, este servicio lo guarda inmediatamente en el `localStorage` del navegador. Esto permite que el usuario siga logueado aunque refresque la página.
- **Manejo de Errores**: Captura el error devuelto por el backend (`error.response.data.error`) y lanza una excepción limpia que el formulario de Login puede mostrar como un mensaje de texto rojo (ej: "Credenciales inválidas").

---

## 2. Abstracción de Seguridad: `getAuthHeaders()`

Presente en casi todos los servicios (`adminService`, `alumnoService`, `profesorService`), esta función auxiliar es vital para la seguridad:

```javascript
const getAuthHeaders = () => {
    const token = localStorage.getItem('token');
    return { headers: { Authorization: `Bearer ${token}` } };
};
```
- **Autenticación Bearer**: Recupera el token guardado durante el login y lo inyecta en la cabecera HTTP de la petición. Sin esto, el backend rechazaría la petición devolviendo un error de "No Autorizado" (Error 401).

---

## 3. adminService.js (Gestión de Usuarios)

Agrupa todas las peticiones necesarias para el panel de control del administrador. Implementa un mapeo directo a las rutas CRUD del backend.

- **`getUsers()`**: Solicita la lista completa de usuarios. Si falla, devuelve un array vacío `[]` para evitar que la tabla de React "explote" (crashee) por intentar iterar sobre datos nulos.
- **`createUser(nuevoUsuario)`**: Envía un objeto JSON al servidor para registrar un nuevo perfil.
- **`updateUser(id, datos)` / `changeUserPassword(id, password)`**: Envían peticiones `PUT` específicas para alterar propiedades sensibles de un usuario existente.
- **`deactivateUser(id)`**: Ejecuta el borrado lógico en el servidor.

---

## 4. alumnoService.js y profesorService.js (Servicios Académicos)

Servicios dedicados a recuperar la información del panel principal de cada tipo de usuario.

- **`getMisCursosAlumno(alumnoId)`**: Conecta con el endpoint `/api/cursos/alumno/:id`. Recupera únicamente las asignaturas en las que el alumno está matriculado.
- **`getMisCursos(profesorId)`**: Conecta con el endpoint `/api/cursos/profesor/:id`. Recupera las clases impartidas por el docente junto con el conteo total de alumnos.

---

## 5. campusService.js (Gestión de Archivos y Contenido)

A diferencia de los demás servicios que usan `axios`, este servicio utiliza la API nativa `fetch` de JavaScript. 

```javascript
uploadFile: async (formData, token) => {
  const response = await fetch(`${API_URL}/campus/upload`, {
    method: 'POST',
    headers: { 'Authorization': `Bearer ${token}` },
    body: formData 
  });
  return response.json();
}
```
- **Manejo de `FormData`**: Utiliza el objeto `FormData` nativo del navegador, que es el formato estándar necesario para enviar archivos binarios (PDFs, imágenes) combinados con campos de texto (título, descripción) a través del protocolo HTTP (Multipart form data).
- **`toggleVisibility`**: Envía un booleano (`true`/`false`) mediante el método `PUT` para permitir al profesor ocultar o mostrar materiales de clase instantáneamente.

---

## 💡 Valor Técnico Global de la Capa de Servicios
1. **Centralización de Variables de Entorno**: Todos los servicios utilizan `import.meta.env.VITE_API_URL`. Si el servidor cambia de IP o de dominio, solo hay que cambiar una variable en un archivo `.env`, en lugar de buscar URLs perdidas por decenas de componentes React.
2. **Evita la Duplicidad de Código**: Cualquier componente de la aplicación puede importar la función `getUsers()` y usarla sin tener que reescribir la lógica de conexión y cabeceras.
