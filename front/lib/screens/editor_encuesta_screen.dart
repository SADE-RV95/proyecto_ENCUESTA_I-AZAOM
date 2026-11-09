import 'package:encuestas_uni/models/encuesta.dart';
import 'package:encuestas_uni/models/pregunta.dart';
import 'package:encuestas_uni/services/api_service.dart';
import 'package:encuestas_uni/widgets/app_card.dart';
import 'package:encuestas_uni/widgets/app_colors.dart';
import 'package:encuestas_uni/widgets/app_input.dart';
import 'package:encuestas_uni/widgets/back_header.dart';
import 'package:encuestas_uni/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class _PreguntaForm {
  final etiqueta = TextEditingController();
  final opciones = TextEditingController();
  String tipo = 'texto';
  bool obligatoria = true;

  void dispose() {
    etiqueta.dispose();
    opciones.dispose();
  }
}

/// Crear una encuesta nueva o editar sus datos generales.
/// Al editar, las preguntas se muestran solo de lectura.
class EditorEncuestaScreen extends StatefulWidget {
  final Encuesta? encuesta;

  const EditorEncuestaScreen({super.key, this.encuesta});

  @override
  State<EditorEncuestaScreen> createState() => _EditorEncuestaScreenState();
}

class _EditorEncuestaScreenState extends State<EditorEncuestaScreen> {
  final _api = ApiService.instance;
  final _titulo = TextEditingController();
  final _descripcion = TextEditingController();
  final _minutos = TextEditingController(text: '5');
  final List<_PreguntaForm> _nuevas = [];
  // Preguntas quitadas: se liberan al cerrar la pantalla para no usar un
  // controller ya destruido mientras Flutter reconstruye la lista.
  final List<_PreguntaForm> _descartadas = [];

  List<Pregunta> _existentes = [];
  bool _guardando = false;

  bool get _esEdicion => widget.encuesta != null;

  @override
  void initState() {
    super.initState();
    final e = widget.encuesta;
    if (e != null) {
      _titulo.text = e.titulo;
      _descripcion.text = e.descripcion;
      _minutos.text = '${e.minutos}';
      _cargarPreguntas(e.id);
    } else {
      _nuevas.add(_PreguntaForm());
    }
  }

  @override
  void dispose() {
    _titulo.dispose();
    _descripcion.dispose();
    _minutos.dispose();
    for (final p in [..._nuevas, ..._descartadas]) {
      p.dispose();
    }
    super.dispose();
  }

  Future<void> _cargarPreguntas(int id) async {
    try {
      final e = await _api.encuesta(id);
      if (mounted) setState(() => _existentes = e.preguntas);
    } on ApiException {
      // Las preguntas son solo informativas; se ignora el error.
    }
  }

  void _aviso(String texto) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(texto)));
  }

  Future<void> _guardar() async {
    final titulo = _titulo.text.trim();
    if (titulo.isEmpty) {
      _aviso('Escribe el título de la encuesta');
      return;
    }
    final minutos = int.tryParse(_minutos.text.trim()) ?? 5;

    final preguntas = <Map<String, dynamic>>[];
    if (!_esEdicion) {
      if (_nuevas.isEmpty) {
        _aviso('Agrega al menos una pregunta');
        return;
      }
      for (final f in _nuevas) {
        final etiqueta = f.etiqueta.text.trim();
        if (etiqueta.isEmpty) {
          _aviso('Todas las preguntas necesitan un texto');
          return;
        }
        final opciones = f.opciones.text
            .split(',')
            .map((o) => o.trim())
            .where((o) => o.isNotEmpty)
            .toList();
        if (f.tipo == 'seleccion' && opciones.length < 2) {
          _aviso('"$etiqueta" necesita al menos 2 opciones separadas por coma');
          return;
        }
        preguntas.add({
          'etiqueta': etiqueta,
          'tipo': f.tipo,
          'opciones': f.tipo == 'seleccion' ? opciones : <String>[],
          'obligatoria': f.obligatoria,
        });
      }
    }

    setState(() => _guardando = true);
    try {
      if (_esEdicion) {
        await _api.actualizarEncuesta(
          widget.encuesta!.id,
          titulo: titulo,
          descripcion: _descripcion.text.trim(),
          minutos: minutos,
        );
      } else {
        await _api.crearEncuesta(
          titulo: titulo,
          descripcion: _descripcion.text.trim(),
          minutos: minutos,
          preguntas: preguntas,
        );
      }
      if (!mounted) return;
      Navigator.pop(context, true);
    } on ApiException catch (e) {
      if (!mounted) return;
      _aviso(e.mensaje);
      setState(() => _guardando = false);
    }
  }

  Widget _etiqueta(String texto) => Padding(
    padding: const EdgeInsets.only(bottom: 6, top: 14),
    child: Text(
      texto,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w800,
        color: AppColors.label,
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.orange,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 4, 22, 0),
              child: const BackHeader(subtitulo: 'Administrador'),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(22, 12, 22, 24),
                child: Column(
                  children: [
                    AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _esEdicion ? 'Editar encuesta' : 'Nueva encuesta',
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              color: AppColors.brown,
                            ),
                          ),
                          _etiqueta('TÍTULO'),
                          TextField(
                            controller: _titulo,
                            textCapitalization: TextCapitalization.sentences,
                            decoration: decoracionCampo(
                              'Ej. Encuesta de participación',
                            ),
                          ),
                          _etiqueta('DESCRIPCIÓN'),
                          TextField(
                            controller: _descripcion,
                            maxLines: 3,
                            textCapitalization: TextCapitalization.sentences,
                            decoration: decoracionCampo(
                              '¿De qué trata la encuesta?',
                            ),
                          ),
                          _etiqueta('DURACIÓN ESTIMADA (MIN)'),
                          TextField(
                            controller: _minutos,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            decoration: decoracionCampo('5'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    if (_esEdicion)
                      _preguntasSoloLectura()
                    else
                      ..._editorPreguntas(),
                    const SizedBox(height: 16),
                    PrimaryButton(
                      texto: _esEdicion ? 'Guardar cambios' : 'Crear encuesta',
                      icono: Icons.check,
                      color: AppColors.brown,
                      colorTexto: AppColors.orange,
                      cargando: _guardando,
                      onPressed: _guardar,
                    ),
                    if (!_esEdicion)
                      const Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Text(
                          'Se crea como borrador. Publícala desde el panel cuando esté lista.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.brown,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _preguntasSoloLectura() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Preguntas',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.brown,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Las preguntas no se pueden modificar una vez creada la encuesta.',
            style: TextStyle(fontSize: 11.5, color: AppColors.textGrey),
          ),
          const SizedBox(height: 10),
          for (final p in _existentes)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                '${p.orden}. ${p.etiqueta}',
                style: const TextStyle(fontSize: 13, color: AppColors.brown),
              ),
            ),
        ],
      ),
    );
  }

  List<Widget> _editorPreguntas() {
    return [
      for (var i = 0; i < _nuevas.length; i++) ...[
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Pregunta ${i + 1}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: AppColors.brown,
                    ),
                  ),
                  const Spacer(),
                  if (_nuevas.length > 1)
                    IconButton(
                      tooltip: 'Quitar pregunta',
                      icon: const Icon(
                        Icons.delete_outline,
                        color: AppColors.label,
                      ),
                      onPressed: () =>
                          setState(() => _descartadas.add(_nuevas.removeAt(i))),
                    ),
                ],
              ),
              TextField(
                controller: _nuevas[i].etiqueta,
                textCapitalization: TextCapitalization.sentences,
                decoration: decoracionCampo('Texto de la pregunta'),
              ),
              const SizedBox(height: 10),
              SegmentedButton<String>(
                showSelectedIcon: false,
                segments: const [
                  ButtonSegment(value: 'texto', label: Text('Texto')),
                  ButtonSegment(value: 'numero', label: Text('Número')),
                  ButtonSegment(value: 'seleccion', label: Text('Opciones')),
                ],
                selected: {_nuevas[i].tipo},
                onSelectionChanged: (s) =>
                    setState(() => _nuevas[i].tipo = s.first),
              ),
              if (_nuevas[i].tipo == 'seleccion') ...[
                const SizedBox(height: 10),
                TextField(
                  controller: _nuevas[i].opciones,
                  decoration: decoracionCampo('Opciones separadas por coma'),
                ),
              ],
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                activeThumbColor: AppColors.orange,
                title: const Text(
                  'Obligatoria',
                  style: TextStyle(fontSize: 13),
                ),
                value: _nuevas[i].obligatoria,
                onChanged: (v) => setState(() => _nuevas[i].obligatoria = v),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
      ],
      OutlinedButton.icon(
        onPressed: () => setState(() => _nuevas.add(_PreguntaForm())),
        icon: const Icon(Icons.add),
        label: const Text('Agregar pregunta'),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.brown,
          side: const BorderSide(color: AppColors.brown),
          minimumSize: const Size.fromHeight(46),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    ];
  }
}
