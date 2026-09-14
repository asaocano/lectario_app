import 'package:lectario_app/core/exceptions/app_exception.dart';

class Utils {
  ///Función para convertir el error a algo "user friendly"
  static String transformErrorMsg(AppException ex) {
    return switch (ex) {
      NetworkException() => 'No hay conexión a internet.',
      BadRequestException() => "",
      UnauthorizedException() => 'No tienes autorización.',
      ForbiddenException() => "No es posible acceder al recurso.",
      NotFoundException() => 'No se encontró el recurso.',
      ServerException() => 'El servidor falló al procesar la solicitud.',
      _ => 'Ha ocurrido un error inesperado.',
    };
  }

  static bool isQueryAnIsbn(String query) {
    if (query.length == 10) {
      return _isValidIsbn10(query);
    } else if (query.length == 13) {
      return _isValidIsbn13(query);
    }

    return false;
  }

  /// Validación de Checksum para ISBN-10
  static bool _isValidIsbn10(String isbn) {
    int sum = 0;
    for (int i = 0; i < 9; i++) {
      sum += int.parse(isbn[i]) * (10 - i);
    }

    // El décimo carácter representa 10 si es 'X'
    int lastCharValue = (isbn[9] == 'X') ? 10 : int.parse(isbn[9]);
    sum += lastCharValue;

    return sum % 11 == 0;
  }

  /// Validación de Checksum para ISBN-13
  static bool _isValidIsbn13(String isbn) {
    int sum = 0;
    for (int i = 0; i < 13; i++) {
      int digit = int.parse(isbn[i]);
      // Posiciones pares (índices 0, 2, 4...) se multiplican por 1; impares por 3
      sum += (i % 2 == 0) ? digit : digit * 3;
    }

    return sum % 10 == 0;
  }
}
