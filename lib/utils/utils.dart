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
}
