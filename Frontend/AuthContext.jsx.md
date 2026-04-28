# 🔐 Documentación Técnica Frontend: AuthContext.jsx

El archivo `AuthContext.jsx` implementa el **Context API** de React. Su función es centralizar el estado de autenticación de toda la plataforma, actuando como una "fuente de verdad única" para saber qué usuario está dentro del sistema y qué permisos tiene.

---

## 1. Conceptos Clave

- **`createContext`**: Crea el almacén de datos global donde se guarda la información del usuario.
- **`AuthProvider`**: Es el componente "proveedor". Envuelve a toda la aplicación (en `main.jsx` o `App.jsx`) para que cualquier botón o página pueda acceder a los datos del usuario.
- **`useAuth` (Custom Hook)**: Es una función personalizada que facilita enormemente el trabajo. En lugar de escribir una lógica compleja en cada página, solo usamos `const { user } = useAuth();`.

---

## 2. Funcionalidades Principales

### Persistencia de Estado (Hydration)
```javascript
const [user, setUser] = useState(() => {
  const savedUser = localStorage.getItem("user");
  return savedUser ? JSON.parse(savedUser) : null;
});
```
El contexto es inteligente: cuando la página se refresca (F5), lo primero que hace es mirar en el `localStorage`. Si encuentra un usuario guardado, lo "hidrata" (lo vuelve a cargar) en el estado de React automáticamente. Esto evita que el usuario tenga que hacer login cada vez que pulsa F5.

### Gestión de Login y Logout
- **`login(userData)`**: Recibe los datos del usuario desde el servidor, los guarda en el estado global para que la interfaz cambie (ej: mostrar el nombre en el menú) y los asegura en el almacenamiento local.
- **`logout()`**: Limpia rastro del usuario tanto en el estado de React como en el disco del navegador, provocando que el `AppRouter` redirija inmediatamente al Login por falta de permisos.

---

## 💡 Valor Técnico

1. **Rendimiento**: Al usar Context API, evitamos el "Prop Drilling" (pasar datos a través de 5 o 6 capas de componentes), lo que hace que el código sea mucho más limpio y fácil de mantener.
2. **Sincronización en tiempo real**: Si el usuario cierra sesión en una parte de la web, todos los componentes que dependen de su información desaparecen o cambian instantáneamente sin necesidad de recargar la página.
3. **Seguridad en la UI**: Permite que componentes como la "Barra de Navegación" (Navbar) decidan qué botones mostrar (ej: "Panel Admin" solo si `user.rol === 'admin'`) de forma centralizada.
