/// Persona que realiza las encuestas.
class Usuario {
  final int? id;
  final String nombre;

  const Usuario({this.id, required this.nombre});

  Usuario copyWith({int? id, String? nombre}) =>
      Usuario(id: id ?? this.id, nombre: nombre ?? this.nombre);

  Map<String, dynamic> toJson() => {'id': id, 'nombre': nombre};

  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
        id: json['id'] as int?,
        nombre: json['nombre'] as String? ?? '',
      );

  @override
  String toString() => 'Usuario(id: $id, nombre: $nombre)';
}
