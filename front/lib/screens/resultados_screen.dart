import 'package:encuestas_uni/models/resultados.dart';
import 'package:encuestas_uni/services/api_service.dart';
import 'package:encuestas_uni/widgets/app_card.dart';
import 'package:encuestas_uni/widgets/app_colors.dart';
import 'package:encuestas_uni/widgets/back_header.dart';
import 'package:encuestas_uni/widgets/error_view.dart';
import 'package:flutter/material.dart';

/// Resultados de una encuesta: conteo de respuestas por pregunta.
class ResultadosScreen extends StatefulWidget {
  final int encuestaId;

  const ResultadosScreen({super.key, required this.encuestaId});

  @override
  State<ResultadosScreen> createState() => _ResultadosScreenState();
}

class _ResultadosScreenState extends State<ResultadosScreen> {
  ResultadosEncuesta? _datos;
  String? _error;
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    setState(() {
      _cargando = true;
      _error = null;
    });
    try {
      final d = await ApiService.instance.resultados(widget.encuestaId);
      if (!mounted) return;
      setState(() {
        _datos = d;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.orange,
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(10, 4, 22, 0),
              child: BackHeader(subtitulo: 'Administrador'),
            ),
            Expanded(child: _cuerpo()),
          ],
        ),
      ),
    );
  }

  Widget _cuerpo() {
    if (_cargando) {
      return const Center(child: CircularProgressIndicator(color: AppColors.brown));
    }
    final d = _datos;
    if (_error != null || d == null) {
      return Center(child: ErrorView(mensaje: _error ?? 'Error', onReintentar: _cargar));
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(22, 12, 22, 24),
      children: [
        Text(
          d.titulo,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            height: 1.1,
            color: AppColors.brown,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${d.total} ${d.total == 1 ? 'respuesta' : 'respuestas'}',
          style: const TextStyle(fontSize: 13, color: AppColors.brown),
        ),
        const SizedBox(height: 16),
        for (final p in d.preguntas) ...[
          _pregunta(p, d.total),
          const SizedBox(height: 12),
        ],
      ],
    );
  }

  Widget _pregunta(ResultadoPregunta p, int total) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            p.etiqueta,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.brown),
          ),
          const SizedBox(height: 10),
          if (p.conteos.isEmpty)
            const Text('Sin respuestas', style: TextStyle(fontSize: 12, color: AppColors.textGrey)),
          for (final c in p.conteos.take(10))
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          c.valor,
                          style: const TextStyle(fontSize: 13, color: AppColors.brown),
                        ),
                      ),
                      Text(
                        '${c.cantidad}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.label,
                        ),
                      ),
                    ],
                  ),
                  if (p.tipo == 'seleccion') ...[
                    const SizedBox(height: 4),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: total == 0 ? 0 : c.cantidad / total,
                        minHeight: 6,
                        color: AppColors.orange,
                        backgroundColor: AppColors.inputFill,
                      ),
                    ),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }
}
