# Autenticación y JWT

##  Flujo de Login

```javascript
// 1. Recibir credenciales
POST /api/login { email, password }

// 2. Buscar usuario
SELECT * FROM usuarios WHERE email=?

// 3. Validar contraseña (bcrypt)
bcrypt.compare(password, password_hash)

// 4. Generar JWT
const token = jwt.sign({userId, email}, JWT_SECRET, {expiresIn: '8h'})

// 5. Devolver token
{ token, usuario: {...} }
```

##  Middleware de Autenticación

```javascript
function authMiddleware(req, res, next) {
  const token = req.headers.authorization?.split(' ')[1];
  if (!token) return res.status(401).json({error: 'No autorizado'});
  
  try {
    const decoded = jwt.verify(token, JWT_SECRET);
    req.userId = decoded.userId;
    next();
  } catch {
    res.status(401).json({error: 'Token inválido'});
  }
}
```

##  Hashing de Contraseñas

```javascript
// Al registrar
const salt = await bcrypt.genSalt(10);
const hash = await bcrypt.hash(password, salt);

// Al validar
const isValid = await bcrypt.compare(password, hash);
```

