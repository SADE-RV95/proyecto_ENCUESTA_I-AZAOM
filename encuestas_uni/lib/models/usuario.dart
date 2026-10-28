/// Persona que realiza las encuestas.
class Usuario {
  final String nombre;

  const Usuario({required this.nombre});

  Usuario copyWith({String? nombre}) => Usuario(nombre: nombre ?? this.nombre);

  Map<String, dynamic> toJson() => {'nombre': nombre};

  factory Usuario.fromJson(Map<String, dynamic> json) =>
      Usuario(nombre: json['nombre'] as String? ?? '');

  @override
  String toString() => 'Usuario(nombre: $nombre)';
}
