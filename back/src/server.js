const express = require('express');
const cors = require('cors');
const db = require('./db');
const seed = require('./seed');

const app = express();
app.use(cors());
app.use(express.json());

app.get('/api/health', (_req, res) => res.json({ ok: true }));

// Resumen para el panel de administración
app.get('/api/resumen', (_req, res) => {
  const q = (sql) => db.prepare(sql).get().n;
  res.json({
    activas: q("SELECT COUNT(*) AS n FROM encuestas WHERE estado = 'publicada'"),
    borradores: q("SELECT COUNT(*) AS n FROM encuestas WHERE estado = 'borrador'"),
    respuestas: q('SELECT COUNT(*) AS n FROM respuestas'),
  });
});

app.use('/api/encuestas', require('./routes/encuestas'));
app.use('/api/usuarios', require('./routes/usuarios'));

app.use((_req, res) => res.status(404).json({ error: 'Ruta no encontrada' }));

const PORT = process.env.PORT || 3000;
seed();
app.listen(PORT, '0.0.0.0', () => console.log(`API Encuestas JFM en http://0.0.0.0:${PORT}`));
