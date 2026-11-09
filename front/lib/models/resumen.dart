/// Totales del panel de administración.
class Resumen {
  final int activas;
  final int borradores;
  final int respuestas;

  const Resumen({
    required this.activas,
    required this.borradores,
    required this.respuestas,
  });

  factory Resumen.fromJson(Map<String, dynamic> json) => Resumen(
        activas: json['activas'] as int? ?? 0,
        borradores: json['borradores'] as int? ?? 0,
        respuestas: json['respuestas'] as int? ?? 0,
      );
}
