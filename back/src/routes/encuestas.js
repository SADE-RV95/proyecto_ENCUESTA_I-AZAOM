const express = require('express');
const db = require('../db');

const router = express.Router();

const ESTADOS = ['borrador', 'publicada', 'cerrada'];
const TIPOS = ['texto', 'numero', 'seleccion'];

function parsePregunta(p) {
  return {
    id: p.id,
    orden: p.orden,
    etiqueta: p.etiqueta,
    tipo: p.tipo,
    opciones: p.opciones ? JSON.parse(p.opciones) : [],
    obligatoria: !!p.obligatoria,
  };
}

const SELECT_LISTA = `
  SELECT e.id, e.titulo, e.descripcion, e.estado, e.minutos, e.fecha_limite, e.creado_en,
         (SELECT COUNT(*) FROM preguntas p WHERE p.encuesta_id = e.id) AS num_preguntas,
         (SELECT COUNT(*) FROM respuestas r WHERE r.encuesta_id = e.id) AS num_respuestas
  FROM encuestas e
`;

// GET /api/encuestas?estado=publicada
router.get('/', (req, res) => {
  const { estado } = req.query;
  if (estado) {
    if (!ESTADOS.includes(estado)) return res.status(400).json({ error: 'Estado inválido' });
    return res.json(db.prepare(`${SELECT_LISTA} WHERE e.estado = ? ORDER BY e.id DESC`).all(estado));
  }
  res.json(db.prepare(`${SELECT_LISTA} ORDER BY e.id DESC`).all());
});

// GET /api/encuestas/:id  (incluye preguntas)
router.get('/:id', (req, res) => {
  const enc = db.prepare(`${SELECT_LISTA} WHERE e.id = ?`).get(req.params.id);
  if (!enc) return res.status(404).json({ error: 'Encuesta no encontrada' });
  const preguntas = db
    .prepare('SELECT * FROM preguntas WHERE encuesta_id = ? ORDER BY orden')
    .all(req.params.id)
    .map(parsePregunta);
  res.json({ ...enc, preguntas });
});

// POST /api/encuestas  (crear, con preguntas opcionales)
router.post('/', (req, res) => {
  const { titulo, descripcion = '', minutos = 5, fecha_limite = null, preguntas = [] } = req.body || {};
  if (!titulo || !String(titulo).trim()) return res.status(400).json({ error: 'El título es obligatorio' });
  for (const p of preguntas) {
    if (!p.etiqueta || !TIPOS.includes(p.tipo)) {
      return res.status(400).json({ error: 'Pregunta inválida (etiqueta y tipo texto|numero|seleccion)' });
    }
  }
  db.exec('BEGIN');
  try {
    const id = Number(
      db.prepare('INSERT INTO encuestas (titulo, descripcion, minutos, fecha_limite) VALUES (?,?,?,?)')
        .run(String(titulo).trim(), descripcion, minutos, fecha_limite).lastInsertRowid
    );
    const ins = db.prepare(
      'INSERT INTO preguntas (encuesta_id, orden, etiqueta, tipo, opciones, obligatoria) VALUES (?,?,?,?,?,?)'
    );
    preguntas.forEach((p, i) =>
      ins.run(id, i + 1, p.etiqueta, p.tipo, p.opciones?.length ? JSON.stringify(p.opciones) : null, p.obligatoria === false ? 0 : 1)
    );
    db.exec('COMMIT');
    res.status(201).json({ id });
  } catch (e) {
    db.exec('ROLLBACK');
    res.status(500).json({ error: e.message });
  }
});

// PATCH /api/encuestas/:id/estado   { estado }
router.patch('/:id/estado', (req, res) => {
  const { estado } = req.body || {};
  if (!ESTADOS.includes(estado)) return res.status(400).json({ error: 'Estado inválido' });
  const r = db.prepare('UPDATE encuestas SET estado = ? WHERE id = ?').run(estado, req.params.id);
  if (!r.changes) return res.status(404).json({ error: 'Encuesta no encontrada' });
  res.json({ ok: true });
});

// PUT /api/encuestas/:id   { titulo, descripcion, minutos }  (edita datos generales)
router.put('/:id', (req, res) => {
  const { titulo, descripcion = '', minutos = 5 } = req.body || {};
  if (!titulo || !String(titulo).trim()) return res.status(400).json({ error: 'El título es obligatorio' });
  const r = db
    .prepare('UPDATE encuestas SET titulo = ?, descripcion = ?, minutos = ? WHERE id = ?')
    .run(String(titulo).trim(), descripcion, Number(minutos) || 5, req.params.id);
  if (!r.changes) return res.status(404).json({ error: 'Encuesta no encontrada' });
  res.json({ ok: true });
});

// DELETE /api/encuestas/:id
router.delete('/:id', (req, res) => {
  const r = db.prepare('DELETE FROM encuestas WHERE id = ?').run(req.params.id);
  if (!r.changes) return res.status(404).json({ error: 'Encuesta no encontrada' });
  res.json({ ok: true });
});

// POST /api/encuestas/:id/respuestas  { usuario_id, respuestas: [{pregunta_id, valor}] }
router.post('/:id/respuestas', (req, res) => {
  const enc = db.prepare('SELECT * FROM encuestas WHERE id = ?').get(req.params.id);
  if (!enc) return res.status(404).json({ error: 'Encuesta no encontrada' });
  if (enc.estado !== 'publicada') return res.status(409).json({ error: 'La encuesta no está publicada' });

  const { usuario_id = null, respuestas } = req.body || {};
  if (!Array.isArray(respuestas)) return res.status(400).json({ error: 'Se esperaba una lista de respuestas' });

  const preguntas = db.prepare('SELECT * FROM preguntas WHERE encuesta_id = ?').all(enc.id);
  const mapa = new Map(respuestas.map((r) => [Number(r.pregunta_id), String(r.valor ?? '').trim()]));

  for (const p of preguntas) {
    if (p.obligatoria && !mapa.get(p.id)) {
      return res.status(400).json({ error: `Falta responder: ${p.etiqueta}` });
    }
  }

  db.exec('BEGIN');
  try {
    const rid = Number(
      db.prepare('INSERT INTO respuestas (encuesta_id, usuario_id) VALUES (?,?)').run(enc.id, usuario_id).lastInsertRowid
    );
    const ins = db.prepare('INSERT INTO respuesta_detalle (respuesta_id, pregunta_id, valor) VALUES (?,?,?)');
    for (const p of preguntas) {
      const v = mapa.get(p.id);
      if (v) ins.run(rid, p.id, v);
    }
    db.exec('COMMIT');
    res.status(201).json({ id: rid });
  } catch (e) {
    db.exec('ROLLBACK');
    res.status(500).json({ error: e.message });
  }
});

// GET /api/encuestas/:id/resultados
router.get('/:id/resultados', (req, res) => {
  const enc = db.prepare('SELECT id, titulo FROM encuestas WHERE id = ?').get(req.params.id);
  if (!enc) return res.status(404).json({ error: 'Encuesta no encontrada' });
  const { total } = db.prepare('SELECT COUNT(*) AS total FROM respuestas WHERE encuesta_id = ?').get(enc.id);
  const preguntas = db.prepare('SELECT * FROM preguntas WHERE encuesta_id = ? ORDER BY orden').all(enc.id);
  const conteo = db.prepare(
    'SELECT valor, COUNT(*) AS cantidad FROM respuesta_detalle WHERE pregunta_id = ? GROUP BY valor ORDER BY cantidad DESC'
  );
  res.json({
    encuesta: enc,
    total_respuestas: total,
    preguntas: preguntas.map((p) => ({ ...parsePregunta(p), resultados: conteo.all(p.id) })),
  });
});

module.exports = router;
