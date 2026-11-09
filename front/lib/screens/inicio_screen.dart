import 'package:encuestas_uni/models/actividad.dart';
import 'package:encuestas_uni/models/encuesta.dart';
import 'package:encuestas_uni/screens/admin_screen.dart';
import 'package:encuestas_uni/screens/antes_comenzar_screen.dart';
import 'package:encuestas_uni/services/api_service.dart';
import 'package:encuestas_uni/services/usuario_service.dart';
import 'package:encuestas_uni/utils/formatos.dart';
import 'package:encuestas_uni/widgets/actividad_tile.dart';
import 'package:encuestas_uni/widgets/app_colors.dart';
import 'package:encuestas_uni/widgets/encuesta_card.dart';
import 'package:encuestas_uni/widgets/error_view.dart';
import 'package:encuestas_uni/widgets/footer_badge.dart';
import 'package:encuestas_uni/widgets/header_bar.dart';
import 'package:flutter/material.dart';

/// Módulo principal: lista de encuestas disponibles (desde el backend)
/// y la actividad del usuario.
class InicioScreen extends StatefulWidget {
  const InicioScreen({super.key});

  @override
  State<InicioScreen> createState() => _InicioScreenState();
}

class _InicioScreenState extends State<InicioScreen> {
  final _api = ApiService.instance;
  final _usuario = UsuarioService.instance.usuario;

  bool _cargando = true;
  String? _error;
  List<Encuesta> _encuestas = [];
  List<Actividad> _actividad = [];

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar({bool silencioso = false}) async {
    if (!silencioso) setState(() => _cargando = true);
    try {
      final encuestas = await _api.encuestas(estado: 'publicada');
      final id = _usuario?.id;
      final actividad = id == null ? <Actividad>[] : await _api.actividad(id);
      if (!mounted) return;
      setState(() {
        _encuestas = encuestas;
        _actividad = actividad;
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

  Future<void> _comenzar(Encuesta e) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AntesComenzarScreen(encuesta: e)),
    );
    if (mounted) _cargar(silencioso: true);
  }

  Future<void> _abrirAdmin() async {
    await Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminScreen()));
    if (mounted) _cargar(silencioso: true);
  }

  void _verHistorial() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.background,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: MediaQuery.of(ctx).size.height * 0.7),
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(20),
            children: [
              const Text(
                'Historial',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.brown),
              ),
              const SizedBox(height: 12),
              for (final a in _actividad) ...[
                ActividadTile(actividad: a),
                const SizedBox(height: 8),
              ],
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final nombre = _usuario?.nombre ?? 'invitado';
    final primerNombre = nombre.trim().split(' ').first;

    return Scaffold(
      backgroundColor: AppColors.orange,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 12, 22, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const HeaderBar(),
                      const Spacer(),
                      Tooltip(
                        message: 'Panel de administración',
                        child: InkWell(
                          customBorder: const CircleBorder(),
                          onTap: _abrirAdmin,
                          child: CircleAvatar(
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
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  Text(
                    'Hola, $primerNombre 👋',
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      color: AppColors.brown,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Tu opinión ayuda a construir programas más cercanos a nuestra comunidad.',
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.35,
                      color: AppColors.brown.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: 22),
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

    return [
      if (_encuestas.isEmpty)
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 24),
          child: Text(
            'No hay encuestas disponibles por ahora.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textGrey),
          ),
        ),
      for (final e in _encuestas) ...[
        EncuestaCard(encuesta: e, onComenzar: () => _comenzar(e)),
        const SizedBox(height: 14),
      ],
      const SizedBox(height: 6),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Tu actividad',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.brown),
          ),
          if (_actividad.isNotEmpty)
            TextButton(
              onPressed: _verHistorial,
              style: TextButton.styleFrom(foregroundColor: AppColors.label),
              child: const Text('Ver historial  ›', style: TextStyle(fontSize: 12)),
            ),
        ],
      ),
      const SizedBox(height: 8),
      if (_actividad.isEmpty)
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Text(
            'Aún no has enviado encuestas.',
            style: TextStyle(fontSize: 13, color: AppColors.textGrey),
          ),
        )
      else
        for (final a in _actividad.take(3)) ...[
          ActividadTile(actividad: a),
          const SizedBox(height: 8),
        ],
      const SizedBox(height: 8),
      const FooterBadge(),
    ];
  }
}
