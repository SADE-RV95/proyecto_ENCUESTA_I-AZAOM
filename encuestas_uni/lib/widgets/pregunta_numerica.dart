
import 'package:encuestas_uni/controllers/encuesta_controller.dart';
import 'package:encuestas_uni/models/preguntas_encuesta.dart';
import 'package:encuestas_uni/models/tipos_preguntas.dart';
import 'package:flutter/material.dart';
import 'package:encuestas_uni/widgets/pregunta_widget.dart';

class PreguntaNumericaWidget extends StatefulWidget {
  final PreguntasEncuesta pregunta;
  final EncuestaController controlador;

  const PreguntaNumericaWidget({
    super.key,
    required this.pregunta,
    required this.controlador,
  });

  @override
  State<PreguntaNumericaWidget> createState() =>
      _PreguntaNumericaWidgetState();
}

class _PreguntaNumericaWidgetState
    extends State<PreguntaNumericaWidget>
    implements PreguntaWidget {

  final TextEditingController _controlTexto = TextEditingController();

  String? _error;

  @override
  String get preguntaId => widget.pregunta.id;

  @override
  void initState() {
    super.initState();
    widget.controlador.registrar(this);
  }

  @override
  bool respuesta_valida() {
    final tipo = widget.pregunta.tipo as Numerica;

    // Convertimos el texto a número antes de validarlo.
    final texto = _controlTexto.text.trim();
    final numero = num.tryParse(texto);

    if (numero == null || !tipo.respuesta_valida(numero)) {
      _limpiarRespuesta();
      return false;
    }

    setState(() {
      _error = null;
    });

    return true;
  }

  @override
  Object? leerRespuesta() {
    return num.tryParse(_controlTexto.text.trim());
  }

  void _limpiarRespuesta() {
    setState(() {
      _controlTexto.clear();
      _error = 'Respuesta inválida';
    });
  }

  @override
  void dispose() {
    widget.controlador.desregistrar(preguntaId);
    _controlTexto.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tipo = widget.pregunta.tipo as Numerica;

    return TextField(
      controller: _controlTexto,
      keyboardType: const TextInputType.numberWithOptions(
        decimal: true,
        signed: true,
      ),
      decoration: InputDecoration(
        labelText: widget.pregunta.pregunta_texto,
        helperText: 'Mínimo: ${tipo.min} · Máximo: ${tipo.max}',
        errorText: _error,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
