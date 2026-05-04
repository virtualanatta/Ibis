# React y Vite — Frontend del Campus

##  Setup Inicial

```bash
npm create vite@latest campus -- --template react
cd campus
npm install
npm run dev
```

##  Estructura

```
frontend/
├── src/
│   ├── main.jsx          # Entry point
│   ├── App.jsx           # Componente raíz
│   ├── pages/            # Páginas (AlumnoPage, ProfesorPage)
│   ├── components/       # Componentes reutilizables
│   ├── context/          # Context API (AuthContext)
│   ├── services/         # Servicios (axios)
│   └── styles/           # CSS
├── index.html
├── vite.config.js
├── package.json
└── .env
```

##  Desarrollo

```bash
npm run dev              # Hot reload
npm run build           # Producción
npm run preview         # Preview build
```

##  Docker

```yaml
services:
  frontend:
    build: .
    ports:
      - "8080:8080"
    command: npm run dev -- --host
```

