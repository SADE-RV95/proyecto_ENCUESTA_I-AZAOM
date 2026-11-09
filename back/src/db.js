// Conexión a SQLite usando el módulo nativo node:sqlite (Node >= 22.13).
const { DatabaseSync } = require('node:sqlite');
const path = require('path');

const db = new DatabaseSync(path.join(__dirname, '..', 'encuestas.db'));

db.exec('PRAGMA foreign_keys = ON;');

db.exec(`
CREATE TABLE IF NOT EXISTS usuarios (
  id        INTEGER PRIMARY KEY AUTOINCREMENT,
  nombre    TEXT NOT NULL,
  rol       TEXT NOT NULL DEFAULT 'encuestador' CHECK (rol IN ('encuestador','administrador')),
  creado_en TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS encuestas (
  id          INTEGER PRIMARY KEY AUTOINCREMENT,
  titulo      TEXT NOT NULL,
  descripcion TEXT NOT NULL DEFAULT '',
  estado      TEXT NOT NULL DEFAULT 'borrador' CHECK (estado IN ('borrador','publicada','cerrada')),
  minutos     INTEGER NOT NULL DEFAULT 5,
  fecha_limite TEXT,
  creado_en   TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS preguntas (
  id          INTEGER PRIMARY KEY AUTOINCREMENT,
  encuesta_id INTEGER NOT NULL REFERENCES encuestas(id) ON DELETE CASCADE,
  orden       INTEGER NOT NULL,
  etiqueta    TEXT NOT NULL,
  tipo        TEXT NOT NULL CHECK (tipo IN ('texto','numero','seleccion')),
  opciones    TEXT,
  obligatoria INTEGER NOT NULL DEFAULT 1
);

CREATE TABLE IF NOT EXISTS respuestas (
  id          INTEGER PRIMARY KEY AUTOINCREMENT,
  encuesta_id INTEGER NOT NULL REFERENCES encuestas(id) ON DELETE CASCADE,
  usuario_id  INTEGER REFERENCES usuarios(id) ON DELETE SET NULL,
  creado_en   TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE TABLE IF NOT EXISTS respuesta_detalle (
  id           INTEGER PRIMARY KEY AUTOINCREMENT,
  respuesta_id INTEGER NOT NULL REFERENCES respuestas(id) ON DELETE CASCADE,
  pregunta_id  INTEGER NOT NULL REFERENCES preguntas(id) ON DELETE CASCADE,
  valor        TEXT NOT NULL
);
`);

module.exports = db;
