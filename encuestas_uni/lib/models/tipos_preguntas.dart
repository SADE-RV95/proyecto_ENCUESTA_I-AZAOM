// Esta es la clase base para los tipos de preguntas
// Se tiene asi para asegurar que se defina validar apropiadamente en cada tipo
abstract class TipoPregunta {
  bool respuesta_valida(Object? respuesta);
}



class Numerica extends TipoPregunta{
  final num min;
  final num max;
  final bool solo_enteros;

  // Constructor vacio
  Numerica({
  required this.min,
  required this.max,
  this.solo_enteros = false,
  }) {
    if (min > max) {
      throw ArgumentError(
        'El mínimo no puede ser mayor que el máximo',
      );
    }
  }
  // Constructor para solo enteros
  Numerica.enteros({
    this.min = -double.infinity,
    this.max = double.infinity, 
    this.solo_enteros = true,
  });


  @override
  bool respuesta_valida(Object? respuesta) {
    if (respuesta is! num) {
      print('Debes introducir un número');
      return false;
    }

    if (respuesta < min || respuesta > max) {
      print('El valor debe estar entre $min y $max');
      return false;
    }

    if (solo_enteros && respuesta % 1 != 0) {
      print('Debes introducir un número entero');
      return false;
    }

    return true;
  }
}