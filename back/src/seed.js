// Datos de ejemplo alineados con los mockups. Uso: npm run seed
const db = require('./db');

function seed() {
  const { total } = db.prepare('SELECT COUNT(*) AS total FROM encuestas').get();
  if (total > 0) return false;

  const insEnc = db.prepare(
    'INSERT INTO encuestas (titulo, descripcion, estado, minutos, fecha_limite) VALUES (?,?,?,?,?)'
  );
  const insPre = db.prepare(
    'INSERT INTO preguntas (encuesta_id, orden, etiqueta, tipo, opciones, obligatoria) VALUES (?,?,?,?,?,?)'
  );

  // 1) Encuesta de participación comunitaria (publicada, 8 preguntas)
  const e1 = Number(insEnc.run(
    'Encuesta de participación comunitaria',
    'Cuéntanos cómo vives tu comunidad para orientar los próximos apoyos.',
    'publicada', 5, '2026-10-08'
  ).lastInsertRowid);
  const p1 = [
    ['¿Participas en actividades de tu comunidad?', 'seleccion', ['Siempre', 'Casi siempre', 'A veces', 'Nunca']],
    ['¿Con qué frecuencia asistes a eventos comunitarios?', 'seleccion', ['Semanal', 'Mensual', 'Ocasional', 'Nunca']],
    ['¿Qué tipo de apoyo necesita tu comunidad?', 'texto', null],
    ['¿Cuántas personas de tu familia participan?', 'numero', null],
    ['¿Conoces los programas de JFM?', 'seleccion', ['Sí', 'No', 'Algunos']],
    ['¿Te gustaría ser voluntario?', 'seleccion', ['Sí', 'No', 'Tal vez']],
    ['¿Qué día te acomoda más para participar?', 'seleccion', ['Entre semana', 'Sábado', 'Domingo']],
    ['Comentarios adicionales', 'texto', null],
  ];
  p1.forEach((p, i) => insPre.run(e1, i + 1, p[0], p[1], p[2] ? JSON.stringify(p[2]) : null, i === 7 ? 0 : 1));

  // 2) Diagnóstico familiar (publicada) — preguntas demográficas según mockup
  const e2 = Number(insEnc.run(
    'Diagnóstico familiar',
    'Datos demográficos de las familias visitadas.',
    'publicada', 8, null
  ).lastInsertRowid);
  const p2 = [
    ['Apellido familia encuestada', 'texto', null],
    ['Número de habitantes', 'seleccion', ['1', '2', '3', '4', '5', '6', '7', '8 o más']],
    ['Menores 18 años', 'seleccion', ['0', '1', '2', '3', '4', '5 o más']],
    ['Mayores 18 años', 'seleccion', ['1', '2', '3', '4', '5', '6 o más']],
    ['Oficio de persona a cargo de la familia', 'seleccion',
      ['Empleado', 'Comerciante', 'Albañil', 'Hogar', 'Servicios turísticos', 'Otro']],
    ['Estado civil de persona a cargo de la familia', 'seleccion',
      ['Soltero(a)', 'Casado(a)', 'Unión libre', 'Viudo(a)', 'Divorciado(a)']],
    ['Domicilio o colonia', 'texto', null],
    ['Ingreso mensual aproximado del hogar', 'numero', null],
    ['¿Cuentan con servicio médico?', 'seleccion', ['Sí', 'No']],
    ['¿La vivienda es propia?', 'seleccion', ['Propia', 'Rentada', 'Prestada']],
    ['¿Algún integrante estudia?', 'seleccion', ['Sí', 'No']],
    ['Observaciones', 'texto', null],
  ];
  p2.forEach((p, i) => insPre.run(e2, i + 1, p[0], p[1], p[2] ? JSON.stringify(p[2]) : null, i === 11 ? 0 : 1));

  // 3) Evaluación de talleres misioneros (borrador, 6 preguntas)
  const e3 = Number(insEnc.run(
    'Evaluación de talleres misioneros',
    'Valoración de los talleres impartidos por voluntarios.',
    'borrador', 4, null
  ).lastInsertRowid);
  const p3 = [
    ['¿Qué taller tomaste?', 'texto', null],
    ['¿Cómo calificas el taller?', 'seleccion', ['Excelente', 'Bueno', 'Regular', 'Malo']],
    ['¿El horario fue adecuado?', 'seleccion', ['Sí', 'No']],
    ['¿Recomendarías el taller?', 'seleccion', ['Sí', 'No']],
    ['¿Cuántas sesiones asististe?', 'numero', null],
    ['Sugerencias', 'texto', null],
  ];
  p3.forEach((p, i) => insPre.run(e3, i + 1, p[0], p[1], p[2] ? JSON.stringify(p[2]) : null, i === 5 ? 0 : 1));

  // Usuarios
  db.prepare("INSERT INTO usuarios (nombre, rol) VALUES ('Administrador', 'administrador')").run();
  const uid = Number(db.prepare("INSERT INTO usuarios (nombre, rol) VALUES ('Mariana', 'encuestador')").run().lastInsertRowid);

  // Respuestas de ejemplo (encuesta 2 con una respuesta completa)
  const insRes = db.prepare('INSERT INTO respuestas (encuesta_id, usuario_id) VALUES (?,?)');
  const insDet = db.prepare('INSERT INTO respuesta_detalle (respuesta_id, pregunta_id, valor) VALUES (?,?,?)');
  const preguntas2 = db.prepare('SELECT id FROM preguntas WHERE encuesta_id = ? ORDER BY orden').all(e2);
  const valores = ['Hernández', '4', '2', '2', 'Comerciante', 'Casado(a)', 'Región 100', '9000', 'Sí', 'Propia', 'Sí', ''];
  const rid = Number(insRes.run(e2, uid).lastInsertRowid);
  preguntas2.forEach((p, i) => { if (valores[i] !== '') insDet.run(rid, p.id, valores[i]); });

  return true;
}

if (require.main === module) {
  console.log(seed() ? 'Datos de ejemplo insertados.' : 'La base ya tiene datos; no se insertó nada.');
}

module.exports = seed;
