import 'package:encuestas_uni/models/pregunta.dart';

/// Encuesta. [estado]: 'borrador' | 'publicada' | 'cerrada'.
class Encuesta {
  final int id;
  final String titulo;
  final String descripcion;
  final String estado;
  final int minutos;
  final String? fechaLimite;
  final int numPreguntas;
  final int numRespuestas;
  final List<Pregunta> preguntas;

  const Encuesta({
    required this.id,
    required this.titulo,
    this.descripcion = '',
    required this.estado,
    this.minutos = 5,
    this.fechaLimite,
    this.numPreguntas = 0,
    this.numRespuestas = 0,
    this.preguntas = const [],
  });

  bool get publicada => estado == 'publicada';
  bool get borrador => estado == 'borrador';
  bool get cerrada => estado == 'cerrada';

  factory Encuesta.fromJson(Map<String, dynamic> json) => Encuesta(
        id: json['id'] as int,
        titulo: json['titulo'] as String,
        descripcion: json['descripcion'] as String? ?? '',
        estado: json['estado'] as String,
        minutos: json['minutos'] as int? ?? 5,
        fechaLimite: json['fecha_limite'] as String?,
        numPreguntas: json['num_preguntas'] as int? ?? 0,
        numRespuestas: json['num_respuestas'] as int? ?? 0,
        preguntas: (json['preguntas'] as List? ?? [])
            .map((e) => Pregunta.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}
