class Conteo {
  final String valor;
  final int cantidad;

  const Conteo({required this.valor, required this.cantidad});

  factory Conteo.fromJson(Map<String, dynamic> json) => Conteo(
        valor: json['valor'].toString(),
        cantidad: json['cantidad'] as int? ?? 0,
      );
}

class ResultadoPregunta {
  final String etiqueta;
  final String tipo;
  final List<Conteo> conteos;

  const ResultadoPregunta({
    required this.etiqueta,
    required this.tipo,
    required this.conteos,
  });

  factory ResultadoPregunta.fromJson(Map<String, dynamic> json) =>
      ResultadoPregunta(
        etiqueta: json['etiqueta'] as String,
        tipo: json['tipo'] as String,
        conteos: (json['resultados'] as List? ?? [])
            .map((e) => Conteo.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}

class ResultadosEncuesta {
  final String titulo;
  final int total;
  final List<ResultadoPregunta> preguntas;

  const ResultadosEncuesta({
    required this.titulo,
    required this.total,
    required this.preguntas,
  });

  factory ResultadosEncuesta.fromJson(Map<String, dynamic> json) =>
      ResultadosEncuesta(
        titulo: (json['encuesta'] as Map<String, dynamic>)['titulo'] as String,
        total: json['total_respuestas'] as int? ?? 0,
        preguntas: (json['preguntas'] as List? ?? [])
            .map((e) => ResultadoPregunta.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}
