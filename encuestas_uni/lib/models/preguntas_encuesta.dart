import 'package:encuestas_uni/models/tipos_preguntas.dart';

class PreguntasEncuesta {
  final String id;
  final String pregunta_texto;
  final TipoPregunta tipo;
  final bool opcional;

  const PreguntasEncuesta({
    required this.id,
    required this.pregunta_texto,
    required this.tipo,
    this.opcional = false,
    });
}