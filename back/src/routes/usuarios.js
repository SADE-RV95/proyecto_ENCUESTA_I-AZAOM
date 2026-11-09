const express = require('express');
const db = require('../db');

const router = express.Router();

// POST /api/usuarios  { nombre }  -> crea o reutiliza el usuario por nombre
router.post('/', (req, res) => {
  const nombre = String(req.body?.nombre ?? '').trim();
  if (!nombre) return res.status(400).json({ error: 'El nombre es obligatorio' });
  let u = db.prepare('SELECT * FROM usuarios WHERE nombre = ? COLLATE NOCASE').get(nombre);
  if (!u) {
    const id = Number(db.prepare('INSERT INTO usuarios (nombre) VALUES (?)').run(nombre).lastInsertRowid);
    u = db.prepare('SELECT * FROM usuarios WHERE id = ?').get(id);
  }
  res.status(201).json(u);
});

// GET /api/usuarios/:id/actividad  -> encuestas que ha respondido
router.get('/:id/actividad', (req, res) => {
  const rows = db.prepare(`
    SELECT r.id, r.creado_en, e.id AS encuesta_id, e.titulo
    FROM respuestas r JOIN encuestas e ON e.id = r.encuesta_id
    WHERE r.usuario_id = ?
    ORDER BY r.id DESC
  `).all(req.params.id);
  res.json(rows);
});

module.exports = router;
