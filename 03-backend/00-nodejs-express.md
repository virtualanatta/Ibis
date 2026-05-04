# Node.js y Express — Backend API

##  Estructura del Proyecto

```
backend/
├── src/
│   ├── index.js              # Punto de entrada
│   ├── controllers/          # Lógica de negocio
│   ├── routes/               # Definición de rutas
│   ├── middleware/           # Autenticación, validación
│   ├── services/             # Servicios externos
│   └── models/               # Esquemas BD
├── package.json
├── .env
└── docker-compose.yml
```

##  Instalación

```bash
npm install
npm install express pg bcryptjs jsonwebtoken dotenv
```

##  Iniciar

```bash
npm run dev      # Desarrollo
npm start        # Producción
```

##  Docker

```bash
docker compose up -d
docker compose logs -f crisma_back
```

