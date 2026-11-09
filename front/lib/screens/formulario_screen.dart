import 'dart:math';

import 'package:encuestas_uni/models/encuesta.dart';
import 'package:encuestas_uni/models/pregunta.dart';
import 'package:encuestas_uni/screens/gracias_screen.dart';
import 'package:encuestas_uni/services/api_service.dart';
import 'package:encuestas_uni/services/usuario_service.dart';
import 'package:encuestas_uni/widgets/app_card.dart';
import 'package:encuestas_uni/widgets/app_colors.dart';
import 'package:encuestas_uni/widgets/app_input.dart';
import 'package:encuestas_uni/widgets/avance_bar.dart';
import 'package:encuestas_uni/widgets/back_header.dart';
import 'package:encuestas_uni/widgets/error_view.dart';
import 'package:encuestas_uni/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Formulario para la captura de la encuesta. Las preguntas vienen del backend
/// y se muestran por partes de 5.
class FormularioScreen extends StatefulWidget {
  final int encuestaId;

  const FormularioScreen({super.key, required this.encuestaId});

  @override
  State<FormularioScreen> createState() => _FormularioScreenState();
}

class _FormularioScreenState extends State<FormularioScreen> {
  static const _porPagina = 5;

  final _api = ApiService.instance;
  final _scroll = ScrollController();
  final Map<int, String> _valores = {};
  final Map<int, TextEditingController> _controllers = {};

  Encuesta? _encuesta;
  String? _error;
  bool _cargando = true;
  bool _enviando = false;
  int _pagina = 0;

  List<Pregunta> get _preguntas => _encuesta?.preguntas ?? const [];

  int get _totalPaginas {
    final n = (_preguntas.length + _porPagina - 1) ~/ _porPagina;
    return n < 1 ? 1 : n;
  }

  List<Pregunta> get _paginaActual {
    final ini = _pagina * _porPagina;
    final fin = min(ini + _porPagina, _preguntas.length);
    return _preguntas.sublist(ini, fin);
  }

  int get _respondidas =>
      _preguntas.where((p) => (_valores[p.id] ?? '').trim().isNotEmpty).length;

  bool get _esUltima => _pagina >= _totalPaginas - 1;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _cargar() async {
    setState(() {
      _cargando = true;
      _error = null;
    });
    try {
      final e = await _api.encuesta(widget.encuestaId);
      for (final p in e.preguntas) {
        if (p.tipo != 'seleccion') {
          _controllers.putIfAbsent(p.id, () => TextEditingController());
        }
      }
      if (!mounted) return;
      setState(() {
        _encuesta = e;
        _cargando = false;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.mensaje;
        _cargando = false;
      });
    }
  }

  void _aviso(String texto) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(texto)));
  }

  void _irAPagina(int p) {
    setState(() => _pagina = p);
    if (_scroll.hasClients) _scroll.jumpTo(0);
  }

  Future<void> _siguiente() async {
    final faltan = _paginaActual
        .where((p) => p.obligatoria && (_valores[p.id] ?? '').trim().isEmpty)
        .toList();
    if (faltan.isNotEmpty) {
      _aviso('Falta responder: ${faltan.first.etiqueta}');
      return;
    }
    if (!_esUltima) {
      _irAPagina(_pagina + 1);
      return;
    }

    setState(() => _enviando = true);
    try {
      await _api.enviarRespuestas(
        encuestaId: widget.encuestaId,
        usuarioId: UsuarioService.instance.usuario?.id,
        valores: Map<int, String>.from(_valores)
          ..removeWhere((_, v) => v.trim().isEmpty),
      );
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const GraciasScreen()),
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      _aviso(e.mensaje);
      setState(() => _enviando = false);
    }
  }

  Widget _campo(Pregunta p) {
    final Widget entrada;
    if (p.tipo == 'seleccion') {
      entrada = CampoSeleccion(
        titulo: p.etiqueta,
        opciones: p.opciones,
        valor: _valores[p.id],
        onChanged: (v) => setState(() => _valores[p.id] = v),
      );
    } else {
      final esNumero = p.tipo == 'numero';
      entrada = TextField(
        controller: _controllers[p.id],
        keyboardType: esNumero ? TextInputType.number : TextInputType.text,
        inputFormatters: esNumero ? [FilteringTextInputFormatter.digitsOnly] : null,
        textCapitalization: esNumero ? TextCapitalization.none : TextCapitalization.sentences,
        style: const TextStyle(fontSize: 15, color: AppColors.brown),
        decoration: decoracionCampo(esNumero ? 'Escribe un número' : 'Escribe tu respuesta'),
        onChanged: (v) => setState(() => _valores[p.id] = v),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            p.obligatoria ? p.etiqueta : '${p.etiqueta} (opcional)',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.brown,
            ),
          ),
          const SizedBox(height: 8),
          entrada,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // En la parte 2 o posterior, "atrás" regresa a la parte anterior.
      canPop: _pagina == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && _pagina > 0) _irAPagina(_pagina - 1);
      },
      child: Scaffold(
        backgroundColor: AppColors.orange,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 4, 22, 0),
                child: BackHeader(
                  onBack: () {
                    if (_pagina > 0) {
                      _irAPagina(_pagina - 1);
                    } else {
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ),
              Expanded(child: _cuerpo()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cuerpo() {
    if (_cargando) {
      return const Center(child: CircularProgressIndicator(color: AppColors.brown));
    }
    if (_error != null || _encuesta == null) {
      return Center(child: ErrorView(mensaje: _error ?? 'Error', onReintentar: _cargar));
    }

    return SingleChildScrollView(
      controller: _scroll,
      padding: const EdgeInsets.fromLTRB(22, 12, 22, 24),
      child: Column(
        children: [
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _encuesta!.titulo,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    height: 1.1,
                    color: AppColors.brown,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Parte ${_pagina + 1} de $_totalPaginas',
                  style: const TextStyle(fontSize: 12, color: AppColors.textGrey),
                ),
                const SizedBox(height: 20),
                for (final p in _paginaActual) _campo(p),
                AvanceBar(actual: _respondidas, total: _preguntas.length),
              ],
            ),
          ),
          const SizedBox(height: 16),
          PrimaryButton(
            texto: _esUltima ? 'Enviar encuesta' : 'Siguiente parte de la encuesta',
            icono: _esUltima ? Icons.send_rounded : Icons.arrow_forward,
            color: AppColors.orangeDark,
            colorTexto: Colors.white,
            cargando: _enviando,
            onPressed: _siguiente,
          ),
        ],
      ),
    );
  }
}
