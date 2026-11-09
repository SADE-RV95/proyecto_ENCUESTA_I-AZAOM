import 'package:encuestas_uni/models/encuesta.dart';
import 'package:encuestas_uni/models/resumen.dart';
import 'package:encuestas_uni/screens/editor_encuesta_screen.dart';
import 'package:encuestas_uni/screens/resultados_screen.dart';
import 'package:encuestas_uni/services/api_service.dart';
import 'package:encuestas_uni/services/usuario_service.dart';
import 'package:encuestas_uni/utils/formatos.dart';
import 'package:encuestas_uni/widgets/app_card.dart';
import 'package:encuestas_uni/widgets/app_colors.dart';
import 'package:encuestas_uni/widgets/back_header.dart';
import 'package:encuestas_uni/widgets/error_view.dart';
import 'package:encuestas_uni/widgets/estado_chip.dart';
import 'package:encuestas_uni/widgets/footer_badge.dart';
import 'package:encuestas_uni/widgets/primary_button.dart';
import 'package:flutter/material.dart';

/// Panel de administración: crea, edita y publica encuestas.
class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  static const _filtros = {
    'todas': 'Todas',
    'publicada': 'Activas',
    'borrador': 'Borradores',
    'cerrada': 'Cerradas',
  };

  final _api = ApiService.instance;

  bool _cargando = true;
  String? _error;
  List<Encuesta> _encuestas = [];
  Resumen? _resumen;
  String _filtro = 'todas';

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar({bool silencioso = false}) async {
    if (!silencioso) setState(() => _cargando = true);
    try {
      final encuestas = await _api.encuestas();
      final resumen = await _api.resumen();
      if (!mounted) return;
      setState(() {
        _encuestas = encuestas;
        _resumen = resumen;
        _error = null;
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

  Future<void> _abrirEditor([Encuesta? e]) async {
    final guardado = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => EditorEncuestaScreen(encuesta: e)),
    );
    if (guardado == true) _cargar(silencioso: true);
  }

  void _abrirResultados(Encuesta e) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ResultadosScreen(encuestaId: e.id)),
    );
  }

  Future<void> _cambiarEstado(Encuesta e, String estado) async {
    try {
      await _api.cambiarEstado(e.id, estado);
      _cargar(silencioso: true);
    } on ApiException catch (ex) {
      if (mounted) _aviso(ex.mensaje);
    }
  }

  Future<void> _eliminar(Encuesta e) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar encuesta'),
        content: Text(
          '¿Eliminar "${e.titulo}"? También se borrarán sus preguntas y respuestas.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (confirmar != true) return;
    try {
      await _api.eliminarEncuesta(e.id);
      _cargar(silencioso: true);
    } on ApiException catch (ex) {
      if (mounted) _aviso(ex.mensaje);
    }
  }

  List<Encuesta> get _visibles => _filtro == 'todas'
      ? _encuestas
      : _encuestas.where((e) => e.estado == _filtro).toList();

  @override
  Widget build(BuildContext context) {
    final nombre = UsuarioService.instance.usuario?.nombre ?? 'Administrador';
    return Scaffold(
      backgroundColor: AppColors.orange,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 4, 22, 0),
              child: Row(
                children: [
                  const Expanded(child: BackHeader(subtitulo: 'Administrador')),
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.white,
                    child: Text(
                      iniciales(nombre),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: AppColors.brown,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(22, 14, 22, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Panel de administración',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: AppColors.brown,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Crea, edita y publica las encuestas de tu comunidad.',
                    style: TextStyle(fontSize: 13, color: AppColors.brown),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                child: RefreshIndicator(
                  color: AppColors.orange,
                  onRefresh: () => _cargar(silencioso: true),
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(22, 22, 22, 24),
                    children: _contenido(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _contenido() {
    if (_cargando) {
      return const [
        Padding(
          padding: EdgeInsets.only(top: 60),
          child: Center(child: CircularProgressIndicator(color: AppColors.orange)),
        ),
      ];
    }
    if (_error != null) {
      return [ErrorView(mensaje: _error!, onReintentar: _cargar)];
    }

    final visibles = _visibles;
    return [
      Row(
        children: [
          _stat('${_resumen?.activas ?? 0}', 'Activas'),
          const SizedBox(width: 10),
          _stat('${_resumen?.borradores ?? 0}', 'Borradores'),
          const SizedBox(width: 10),
          _stat('${_resumen?.respuestas ?? 0}', 'Respuestas'),
        ],
      ),
      const SizedBox(height: 16),
      PrimaryButton(
        texto: 'Crear nueva encuesta',
        icono: Icons.add,
        onPressed: () => _abrirEditor(),
      ),
      const SizedBox(height: 22),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Mis encuestas',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.brown),
          ),
          TextButton(
            onPressed: () => setState(() => _filtro = 'todas'),
            style: TextButton.styleFrom(foregroundColor: AppColors.label),
            child: const Text('Ver todas  ›', style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (final f in _filtros.entries) ...[
              ChoiceChip(
                label: Text(f.value),
                selected: _filtro == f.key,
                showCheckmark: false,
                selectedColor: AppColors.orange,
                backgroundColor: AppColors.footerBg,
                side: BorderSide.none,
                labelStyle: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: _filtro == f.key ? AppColors.brown : AppColors.label,
                ),
                onSelected: (_) => setState(() => _filtro = f.key),
              ),
              const SizedBox(width: 8),
            ],
          ],
        ),
      ),
      const SizedBox(height: 12),
      if (visibles.isEmpty)
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 24),
          child: Text(
            'No hay encuestas en esta categoría.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textGrey),
          ),
        ),
      for (final e in visibles) ...[
        _tarjeta(e),
        const SizedBox(height: 10),
      ],
      const SizedBox(height: 6),
      const FooterBadge(),
    ];
  }

  Widget _stat(String numero, String etiqueta) {
    return Expanded(
      child: AppCard(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              numero,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: AppColors.brown,
              ),
            ),
            Text(etiqueta, style: const TextStyle(fontSize: 11, color: AppColors.textGrey)),
          ],
        ),
      ),
    );
  }

  Widget _tarjeta(Encuesta e) {
    final respuestas = e.numRespuestas == 0 ? 'Sin respuestas' : '${e.numRespuestas} respuestas';
    return AppCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            e.titulo,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.brown),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              EstadoChip(estado: e.estado),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  '${e.numPreguntas} preguntas · $respuestas',
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 11, color: AppColors.textGrey),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _botonPildora(Icons.edit_outlined, 'Editar', () => _abrirEditor(e)),
              const SizedBox(width: 8),
              _botonPildora(
                Icons.bar_chart_rounded,
                'Resultados',
                e.numRespuestas == 0 ? null : () => _abrirResultados(e),
              ),
              const Spacer(),
              PopupMenuButton<String>(
                tooltip: 'Más opciones',
                icon: const Icon(Icons.more_horiz, color: AppColors.label),
                onSelected: (v) {
                  if (v == 'eliminar') {
                    _eliminar(e);
                  } else {
                    _cambiarEstado(e, v);
                  }
                },
                itemBuilder: (_) => [
                  if (!e.publicada)
                    const PopupMenuItem(value: 'publicada', child: Text('Publicar')),
                  if (e.publicada)
                    const PopupMenuItem(value: 'cerrada', child: Text('Cerrar encuesta')),
                  if (!e.borrador)
                    const PopupMenuItem(value: 'borrador', child: Text('Pasar a borrador')),
                  const PopupMenuItem(value: 'eliminar', child: Text('Eliminar')),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _botonPildora(IconData icono, String texto, VoidCallback? onTap) {
    final activo = onTap != null;
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: activo ? AppColors.footerBg : AppColors.footerBg.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icono, size: 15, color: activo ? AppColors.label : AppColors.hint),
            const SizedBox(width: 6),
            Text(
              texto,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: activo ? AppColors.label : AppColors.hint,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
