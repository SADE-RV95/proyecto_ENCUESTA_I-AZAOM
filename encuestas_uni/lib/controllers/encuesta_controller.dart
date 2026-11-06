import 'package:encuestas_uni/widgets/pregunta_widget.dart';

class EncuestaController {
  final Map<String, PreguntaWidget> _widgets = {};

  void registrar(PreguntaWidget widget) {
    _widgets[widget.preguntaId] = widget;
  }

  void desregistrar(String id) {
    _widgets.remove(id);
  }

  Map<String, Object?>? finalizar() {
    bool todasValidas = true;

    // Primero validamos todas las preguntas.
    for (final widget in _widgets.values) {
      if (!widget.respuesta_valida()) {
        todasValidas = false;
      }
    }

    if (!todasValidas) return null;

    // Si todas son válidas, recopilamos las respuestas.
    return {
      for (final widget in _widgets.values)
        widget.preguntaId: widget.leerRespuesta()
    };
  }
}