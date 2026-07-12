import 'package:lectario_app/core/network/api_client.dart';
import 'package:lectario_app/presentation/providers/network/dio_provider.dart';
import 'package:riverpod/riverpod.dart';

/// Provider que expone una instancia compartida de [ApiClient].
///
/// Obtiene la instancia de [Dio] desde [dioProvider] y la utiliza para
/// construir el cliente HTTP de la aplicación.
///
/// Centralizar la creación de [ApiClient] mediante un provider permite
/// reutilizar la misma configuración de red en todos los *datasources*
/// y facilita el reemplazo de la implementación durante las pruebas.
final apiClientProvider = Provider<ApiClient>((ref) {
  final dio = ref.watch(dioProvider);

  return ApiClient(dio);
});