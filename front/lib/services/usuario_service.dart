import 'package:encuestas_uni/models/usuario.dart';

/// Guarda el usuario en memoria mientras la app está abierta.
class UsuarioService {
  UsuarioService._();
  static final UsuarioService instance = UsuarioService._();

  Usuario? _usuario;

  Usuario? get usuario => _usuario;

  Future<void> guardar(Usuario usuario) async {
    _usuario = usuario;
  }

  Future<Usuario?> obtener() async => _usuario;

  Future<void> borrar() async {
    _usuario = null;
  }
}
