import 'package:flutter/material.dart';
import 'package:palette_generator_master/palette_generator_master.dart';
import 'package:riverpod/riverpod.dart';

/// Obtiene la paleta de colores dominante de la portada de un libro.
///
/// Recibe la URL de una imagen y genera una lista de colores que puede
/// utilizarse para crear gradientes o personalizar la interfaz de la
/// pantalla de detalles.
///
/// La lista contiene, en orden:
/// * El color dominante.
/// * Un color vibrante (o una alternativa similar si no existe).
/// * Un color oscuro para complementar el gradiente.
///
/// Si la librería no puede extraer alguno de estos colores, se utilizan
/// colores predeterminados como respaldo.
final coverGRadientProvider = FutureProvider.family<List<Color>, String>((
  ref,
  imageUrl,
) async {
  final palette = await PaletteGeneratorMaster.fromImageProvider(
    NetworkImage(imageUrl),
  );

  return [
    palette.dominantColor?.color ?? Colors.black,
    palette.vibrantColor?.color ??
        palette.lightVibrantColor?.color ??
        Colors.grey,
    palette.darkMutedColor?.color ??
        palette.darkVibrantColor?.color ??
        Colors.black87,
  ];
});