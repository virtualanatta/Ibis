# Arquitectura y Componentes

##  Estructura de Páginas

```
pages/
├── AlumnoPage.jsx       # Vista alumno
├── ProfesorPage.jsx     # Vista profesor
├── AdminPage.jsx        # Panel admin
├── LoginPage.jsx        # Login
└── DashboardPage.jsx    # Dashboard
```

##  Componentes Reutilizables

```
components/
├── Navbar.jsx           # Navegación
├── Sidebar.jsx          # Menú lateral
├── Card.jsx             # Tarjeta genérica
├── Modal.jsx            # Modal de diálogos
├── Form.jsx             # Formulario base
└── Table.jsx            # Tabla de datos
```

##  Context API

```javascript
// AuthContext
const {user, login, logout} = useContext(AuthContext)

// Valores disponibles
user: {id, email, nombre, role}
isAuthenticated: boolean
token: string
```

