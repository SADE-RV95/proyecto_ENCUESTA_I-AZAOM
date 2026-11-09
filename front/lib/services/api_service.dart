import 'dart:async';
import 'dart:convert';

import 'package:encuestas_uni/config/api_config.dart';
import 'package:encuestas_uni/models/actividad.dart';
import 'package:encuestas_uni/models/encuesta.dart';
import 'package:encuestas_uni/models/resultados.dart';
import 'package:encuestas_uni/models/resumen.dart';
import 'package:encuestas_uni/models/usuario.dart';
import 'package:http/http.dart' as http;

/// Error legible para mostrar al usuario.
class ApiException implements Exception {
  final String mensaje;
  ApiException(this.mensaje);

  @override
  String toString() => mensaje;
}

/// Cliente HTTP de la API REST (backend Node + SQLite).
class ApiService {
  ApiService._();
  static final ApiService instance = ApiService._();

  final http.Client _client = http.Client();

  Uri _uri(String path, [Map<String, String>? query]) =>
      Uri.parse('${ApiConfig.baseUrl}$path').replace(queryParameters: query);

  static const _headers = {'Content-Type': 'application/json'};

  Future<dynamic> _enviar(Future<http.Response> Function() peticion) async {
    try {
      final res = await peticion().timeout(const Duration(seconds: 10));
      final body =
          res.body.isEmpty ? null : jsonDecode(utf8.decode(res.bodyBytes));
      if (res.statusCode >= 200 && res.statusCode < 300) return body;
      final msg = (body is Map && body['error'] != null)
          ? body['error'].toString()
          : 'Error ${res.statusCode}';
      throw ApiException(msg);
    } on ApiException {
      rethrow;
    } on TimeoutException {
      throw ApiException('El servidor no responde. Intenta de nuevo.');
    } catch (_) {
      throw ApiException('No se pudo conectar con el servidor.');
    }
  }

  // ---------- Usuarios ----------

  Future<Usuario> registrarUsuario(String nombre) async {
    final data = await _enviar(() => _client.post(
          _uri('/usuarios'),
          headers: _headers,
          body: jsonEncode({'nombre': nombre}),
        ));
    return Usuario.fromJson(data as Map<String, dynamic>);
  }

  Future<List<Actividad>> actividad(int usuarioId) async {
    final data = await _enviar(() => _client.get(_uri('/usuarios/$usuarioId/actividad')));
    return (data as List)
        .map((e) => Actividad.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // ---------- Encuestas ----------

  Future<List<Encuesta>> encuestas({String? estado}) async {
    final data = await _enviar(() => _client.get(
          _uri('/encuestas', estado == null ? null : {'estado': estado}),
        ));
    return (data as List)
        .map((e) => Encuesta.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Encuesta> encuesta(int id) async {
    final data = await _enviar(() => _client.get(_uri('/encuestas/$id')));
    return Encuesta.fromJson(data as Map<String, dynamic>);
  }

  Future<void> crearEncuesta({
    required String titulo,
    required String descripcion,
    required int minutos,
    required List<Map<String, dynamic>> preguntas,
  }) async {
    await _enviar(() => _client.post(
          _uri('/encuestas'),
          headers: _headers,
          body: jsonEncode({
            'titulo': titulo,
            'descripcion': descripcion,
            'minutos': minutos,
            'preguntas': preguntas,
          }),
        ));
  }

  Future<void> actualizarEncuesta(
    int id, {
    required String titulo,
    required String descripcion,
    required int minutos,
  }) async {
    await _enviar(() => _client.put(
          _uri('/encuestas/$id'),
          headers: _headers,
          body: jsonEncode({
            'titulo': titulo,
            'descripcion': descripcion,
            'minutos': minutos,
          }),
        ));
  }

  Future<void> cambiarEstado(int id, String estado) async {
    await _enviar(() => _client.patch(
          _uri('/encuestas/$id/estado'),
          headers: _headers,
          body: jsonEncode({'estado': estado}),
        ));
  }

  Future<void> eliminarEncuesta(int id) async {
    await _enviar(() => _client.delete(_uri('/encuestas/$id')));
  }

  Future<void> enviarRespuestas({
    required int encuestaId,
    required int? usuarioId,
    required Map<int, String> valores,
  }) async {
    await _enviar(() => _client.post(
          _uri('/encuestas/$encuestaId/respuestas'),
          headers: _headers,
          body: jsonEncode({
            'usuario_id': usuarioId,
            'respuestas': valores.entries
                .map((e) => {'pregunta_id': e.key, 'valor': e.value})
                .toList(),
          }),
        ));
  }

  Future<ResultadosEncuesta> resultados(int encuestaId) async {
    final data = await _enviar(() => _client.get(_uri('/encuestas/$encuestaId/resultados')));
    return ResultadosEncuesta.fromJson(data as Map<String, dynamic>);
  }

  // ---------- Panel ----------

  Future<Resumen> resumen() async {
    final data = await _enviar(() => _client.get(_uri('/resumen')));
    return Resumen.fromJson(data as Map<String, dynamic>);
  }
}
