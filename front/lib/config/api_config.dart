import 'package:flutter/foundation.dart';

/// URL base de la API.
///
/// - Emulador Android: 10.0.2.2 apunta al localhost de tu computadora.
/// - Web / iOS simulador / escritorio: localhost.
/// - Celular físico: usa la IP de tu computadora, por ejemplo:
///   flutter run --dart-define=API_URL=http://192.168.1.50:3000/api
class ApiConfig {
  ApiConfig._();

  static const String _override = String.fromEnvironment('API_URL');

  static String get baseUrl {
    if (_override.isNotEmpty) return _override;
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:3000/api';
    }
    return 'http://localhost:3000/api';
  }
}
