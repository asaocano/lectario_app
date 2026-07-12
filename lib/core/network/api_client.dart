import 'dart:io';

import 'package:dio/dio.dart';
import 'package:lectario_app/config/constants/environment.dart';
import 'package:lectario_app/core/exceptions/app_exception.dart';

/// Cliente HTTP encargado de centralizar todas las peticiones a la API.
///
/// Esta clase actúa como un *wrapper* sobre [Dio], agregando dos
/// responsabilidades principales:
///
/// * Construir automáticamente la URL completa utilizando la URL base
///   definida en [Environment.openLibraryApi].
/// * Convertir las excepciones de [DioException] en excepciones propias
///   de la aplicación ([AppException]), evitando que las capas superiores
///   dependan directamente de Dio.
///
/// De esta manera, los *datasources* únicamente interactúan con este cliente
/// y reciben excepciones de dominio conocidas.
class ApiClient {
  final Dio _dio;

  /// Crea una nueva instancia del cliente HTTP.
  ///
  /// Recibe una instancia de [Dio], normalmente inyectada mediante un
  /// provider para reutilizar la misma configuración en toda la aplicación.
  ApiClient(this._dio);

  /// Realiza una petición HTTP **POST**.
  ///
  /// [path] corresponde a la ruta relativa del endpoint.
  ///
  /// [queryParams] contiene los parámetros enviados en la URL.
  ///
  /// [body] representa el cuerpo de la petición.
  ///
  /// Lanza una [AppException] cuando ocurre algún error durante la solicitud.
  Future<Response<T>> post<T>(
    String path,
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? body,
  ) async {
    try {
      return _dio.post<T>(
        path = Environment.openLibraryApi + path,
        queryParameters: queryParams,
        data: body,
      );
    } on DioException catch (e) {
      throw _mapException(e);
    } catch (_) {
      throw UnknownException();
    }
  }

  /// Realiza una petición HTTP **GET**.
  ///
  /// [path] corresponde a la ruta relativa del endpoint.
  ///
  /// [queryParams] contiene los parámetros enviados en la URL.
  ///
  /// [body] permite enviar información adicional si el endpoint lo requiere.
  ///
  /// Lanza una [AppException] cuando ocurre algún error durante la solicitud.
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? body,
  }) async {
    try {
      return await _dio.get<T>(
        path = Environment.openLibraryApi + path,
        queryParameters: queryParams,
        data: body,
      );
    } on DioException catch (e) {
      throw _mapException(e);
    } catch (_) {
      throw const UnknownException();
    }
  }

  /// Realiza una petición HTTP **PUT**.
  ///
  /// [path] corresponde a la ruta relativa del endpoint.
  ///
  /// [queryParams] contiene los parámetros enviados en la URL.
  ///
  /// [body] representa el cuerpo de la petición.
  ///
  /// Lanza una [AppException] cuando ocurre algún error durante la solicitud.
  Future<Response<T>> put<T>(
    String path, {
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? body,
  }) async {
    try {
      return await _dio.put<T>(
        path = Environment.openLibraryApi + path,
        queryParameters: queryParams,
        data: body,
      );
    } on DioException catch (e) {
      throw _mapException(e);
    } catch (_) {
      throw const UnknownException();
    }
  }

  /// Realiza una petición HTTP **PATCH**.
  ///
  /// [path] corresponde a la ruta relativa del endpoint.
  ///
  /// [queryParams] contiene los parámetros enviados en la URL.
  ///
  /// [body] representa el cuerpo de la petición.
  ///
  /// Lanza una [AppException] cuando ocurre algún error durante la solicitud.
  Future<Response<T>> patch<T>(
    String path, {
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? body,
  }) async {
    try {
      return await _dio.patch<T>(
        path = Environment.openLibraryApi + path,
        queryParameters: queryParams,
        data: body,
      );
    } on DioException catch (e) {
      throw _mapException(e);
    } catch (_) {
      throw const UnknownException();
    }
  }

  /// Realiza una petición HTTP **DELETE**.
  ///
  /// [path] corresponde a la ruta relativa del endpoint.
  ///
  /// [queryParams] contiene los parámetros enviados en la URL.
  ///
  /// [body] representa el cuerpo de la petición.
  ///
  /// Lanza una [AppException] cuando ocurre algún error durante la solicitud.
  Future<Response<T>> delete<T>(
    String path, {
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? body,
  }) async {
    try {
      return await _dio.delete<T>(
        path = Environment.openLibraryApi + path,
        queryParameters: queryParams,
        data: body,
      );
    } on DioException catch (e) {
      throw _mapException(e);
    } catch (_) {
      throw const UnknownException();
    }
  }

  /// Convierte una [DioException] en una excepción propia de la aplicación.
  ///
  /// Primero identifica errores relacionados con la conexión
  /// (timeout, pérdida de red, etc.) y posteriormente evalúa
  /// el código de estado HTTP para generar la excepción adecuada.
  ///
  /// Si el error no puede clasificarse, devuelve una
  /// [UnknownException].
  AppException _mapException(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.error is SocketException) {
      return const NetworkException();
    }

    switch (e.response?.statusCode) {
      case 400:
        return const BadRequestException();

      case 401:
        return const UnauthorizedException();

      case 403:
        return const ForbiddenException();

      case 404:
        return const NotFoundException();

      case 500:
      case 502:
      case 503:
      case 504:
        return const ServerException();

      default:
        return const UnknownException();
    }
  }
}