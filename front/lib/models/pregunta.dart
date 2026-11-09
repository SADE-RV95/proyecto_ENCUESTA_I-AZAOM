/// Pregunta de una encuesta. [tipo]: 'texto' | 'numero' | 'seleccion'.
class Pregunta {
  final int id;
  final int orden;
  final String etiqueta;
  final String tipo;
  final List<String> opciones;
  final bool obligatoria;

  const Pregunta({
    required this.id,
    required this.orden,
    required this.etiqueta,
    required this.tipo,
    this.opciones = const [],
    this.obligatoria = true,
  });

  factory Pregunta.fromJson(Map<String, dynamic> json) => Pregunta(
        id: json['id'] as int,
        orden: json['orden'] as int? ?? 0,
        etiqueta: json['etiqueta'] as String,
        tipo: json['tipo'] as String,
        opciones: (json['opciones'] as List? ?? [])
            .map((e) => e.toString())
            .toList(),
        obligatoria: json['obligatoria'] as bool? ?? true,
      );
}
