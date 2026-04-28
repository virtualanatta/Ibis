# 🛡️ Informe Técnico: Componente `AdminPage.jsx`

El archivo `AdminPage.jsx` es el panel de control central para el rol de administrador. Su función principal es ofrecer una interfaz para la gestión (CRUD) de todos los usuarios de la plataforma, así como visualizar estadísticas globales del sistema. 

Este componente actúa como un **Componente Contenedor (Smart Component)**, ya que maneja la lógica, el estado y las peticiones al servidor, pasando la información a sus componentes hijos (`AdminUserForm` y `AdminUserTable`).

---

## 1. Gestión de Estados y Contexto

* **`useAuth()`**: Extrae el objeto `user` del contexto global. Se utiliza para personalizar el mensaje de bienvenida ("*Bienvenido, [nombre]*").
* **`useState([])`**: Inicializa el estado `users` como un array vacío. Este estado almacena la lista completa de usuarios obtenidos de la base de datos y es el que alimenta la tabla de administración.

---

## 2. Ciclo de Vida y Carga de Datos

* **`useEffect`**: Se ejecuta automáticamente una sola vez cuando el administrador entra a la página (gracias al array de dependencias vacío `[]`). Llama a la función asíncrona `loadUsers()`.
* **`loadUsers`**: Se conecta con el servicio `getUsers()` para pedir los datos al backend y actualiza el estado de React con `setUsers(data)`. Esta función está diseñada para ser reutilizada (por ejemplo, después de crear un usuario nuevo, se vuelve a llamar para refrescar la tabla).

---

## 3. Lógica de Funciones Principales (CRUD)

El componente centraliza las funciones que modifican datos y las envía como *props* a los componentes hijos que tienen los botones:

* **Creación (`handleCreateUser`)**: Recibe los datos del formulario hijo, llama a la API para crear el usuario, muestra una alerta de éxito/error y vuelve a cargar la tabla para que el nuevo usuario aparezca instantáneamente.
* **Cambio de Rol (`handleChangeRole`)**: 
    * Implementa un "interruptor" lógico usando un diccionario (`rolesMap`). 
    * Si el usuario es "alumno", busca su equivalente ("profesor" -> ID 2) y viceversa. Envía la actualización al backend.
* **Cambio de Contraseña (`handleChangePassword`)**:
    * Utiliza un `prompt` nativo del navegador para pedir la nueva contraseña al administrador.
    * **Validación de Seguridad**: Implementa una regla de negocio en el frontend (`pass.length < 8`) que impide enviar peticiones al servidor si la contraseña es demasiado corta.
* **Desactivación (`handleDeactivateUser`)**:
    * Utiliza `window.confirm` para evitar clics accidentales. 
    * Llama al servicio de borrado lógico y refresca la lista.

---

## 4. Cálculos y Estadísticas Dinámicas

Antes de renderizar la vista (return), el componente procesa el estado `users` mediante el método `.filter()` de JavaScript para extraer métricas en tiempo real:
* `totalUsuarios`: La longitud total del array.
* `totalProfesores` / `totalAlumnos`: Cuenta cuántos usuarios tienen un rol específico.
* `totalActivos`: Verifica cuántos tienen el estado "activo".
*Estas variables se inyectan directamente en las tarjetas (`admin-stat-card`) de la parte superior.*

---

## 5. Renderizado de la Interfaz (UI)

* **Layout Base**: Todo está envuelto en el componente `<Layout>`, lo que asegura que la barra de navegación general de la plataforma se mantenga visible.
* **Inyección en Componentes Hijos (Props)**:
    * Al `<AdminUserForm />` le pasa la función de crear para que este sepa qué hacer al hacer clic en "Guardar".
    * Al `<AdminUserTable />` le pasa la lista completa de `users` y todas las funciones de acción (cambiar rol, contraseña, desactivar) para que los botones de cada fila funcionen correctamente.

---

## 💡 Resumen de Valor Técnico

El componente `AdminPage.jsx` ilustra el patrón de diseño **Lifting State Up** (Elevación de Estado) en React. Al mantener la lista de usuarios y las funciones de modificación en el componente "Padre", se asegura de que cualquier cambio realizado (como añadir un alumno) se propague inmediatamente a la tabla "Hija", logrando una interfaz completamente reactiva y sincronizada sin tener que recargar el navegador.
