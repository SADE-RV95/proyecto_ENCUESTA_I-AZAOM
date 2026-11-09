/// Encuesta que el usuario ya envió.
class Actividad {
  final int id;
  final int encuestaId;
  final String titulo;
  final String creadoEn;

  const Actividad({
    required this.id,
    required this.encuestaId,
    required this.titulo,
    required this.creadoEn,
  });

  factory Actividad.fromJson(Map<String, dynamic> json) => Actividad(
        id: json['id'] as int,
        encuestaId: json['encuesta_id'] as int,
        titulo: json['titulo'] as String,
        creadoEn: json['creado_en'] as String,
      );
}
