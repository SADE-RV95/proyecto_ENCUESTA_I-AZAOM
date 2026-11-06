import 'package:encuestas_uni/models/preguntas_encuesta.dart';
import 'package:encuestas_uni/models/tipos_preguntas.dart';
import 'package:encuestas_uni/widgets/pregunta_numerica.dart';
import 'package:encuestas_uni/controllers/encuesta_controller.dart';
import 'package:flutter/material.dart';

class EncuestaScreen extends StatefulWidget {
  const EncuestaScreen({super.key});

  @override
  State<EncuestaScreen> createState() => _EncuestaScreenState();
}

class _EncuestaScreenState extends State<EncuestaScreen> {

  // Una única instancia del controlador para toda la encuesta.
  final EncuestaController controlador = EncuestaController();

  final List<PreguntasEncuesta> preguntas = [
    PreguntasEncuesta(
      id: 'edad',
      pregunta_texto: '¿Cuántos años tienes?',
      tipo: Numerica.enteros(),
    ),
    PreguntasEncuesta(
      id: 'peso',
      pregunta_texto: '¿Cuál es tu peso?',
      tipo: Numerica(min: 1, max: 300),
    ),
  ];

  // Decide qué widget corresponde a cada pregunta.
  Widget crearPregunta(PreguntasEncuesta pregunta) {
    if (pregunta.tipo is Numerica) {
      return PreguntaNumericaWidget(
        pregunta: pregunta,
        controlador: controlador,
      );
    }

    return const SizedBox.shrink();
  }

  // Finaliza y recopila las respuestas.
  void terminarEncuesta() {
    final respuestas = controlador.finalizar();

    if (respuestas == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Revisa las respuestas de la encuesta'),
        ),
      );
      return;
    }

    print(respuestas);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Encuesta'),
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),

        children: [
          for (final pregunta in preguntas)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: crearPregunta(pregunta),
            ),

          const SizedBox(height: 10),

          ElevatedButton(
            onPressed: terminarEncuesta,
            child: const Text('Terminar encuesta'),
          ),
        ],
      ),
    );
  }
}