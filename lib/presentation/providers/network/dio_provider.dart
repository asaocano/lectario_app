import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lectario_app/config/constants/environment.dart';

/// Provider que crea y expone una instancia compartida de [Dio].
///
/// Configura el cliente HTTP con los valores utilizados por toda la
/// aplicación, incluyendo:
/// * La URL base de la API.
/// * Los tiempos de espera para conexión, envío y recepción.
/// * El tipo de respuesta esperado.
///
/// Centralizar esta configuración garantiza que todas las peticiones
/// compartan el mismo comportamiento y facilita agregar interceptores,
/// encabezados o configuraciones globales en un único lugar.
final dioProvider = Provider<Dio>((ref) {
  return Dio(
    BaseOptions(
      baseUrl: Environment.openLibraryApi,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      sendTimeout: const Duration(seconds: 10),
      responseType: ResponseType.json,
    ),
  );
});
