# Autenticación Frontend

##  Flow de Login

```javascript
// 1. Usuario entra email/password
// 2. Envía a /api/login
// 3. Recibe token
// 4. Guarda en localStorage
// 5. Redirige a dashboard

const handleLogin = async (email, password) => {
  const res = await axios.post('/api/login', {email, password});
  localStorage.setItem('token', res.data.token);
  setUser(res.data.usuario);
  navigate('/dashboard');
};
```

##  ProtectedRoute

```javascript
function ProtectedRoute({children}) {
  const {isAuthenticated} = useContext(AuthContext);
  return isAuthenticated ? children : <Navigate to="/login" />;
}
```

##  LocalStorage

```javascript
// Guardar
localStorage.setItem('token', token);

// Recuperar
const token = localStorage.getItem('token');

// Limpiar (logout)
localStorage.removeItem('token');
```

