import 'package:encuestas_uni/models/usuario.dart';
import 'package:encuestas_uni/screens/inicio_screen.dart';
import 'package:encuestas_uni/services/api_service.dart';
import 'package:encuestas_uni/services/usuario_service.dart';
import 'package:encuestas_uni/widgets/app_colors.dart';
import 'package:encuestas_uni/widgets/footer_badge.dart';
import 'package:encuestas_uni/widgets/header_bar.dart';
import 'package:encuestas_uni/widgets/logo_circle.dart';
import 'package:encuestas_uni/widgets/name_card.dart';
import 'package:encuestas_uni/widgets/welcome_card.dart';
import 'package:flutter/material.dart';

/// Pantalla de bienvenida: pide el nombre de quien realiza las encuestas.
class Homeencuesta extends StatefulWidget {
  const Homeencuesta({super.key});

  @override
  State<Homeencuesta> createState() => _HomeencuestaState();
}

class _HomeencuestaState extends State<Homeencuesta> {
  final _nombreController = TextEditingController();
  final _usuarioService = UsuarioService.instance;

  @override
  void dispose() {
    _nombreController.dispose();
    super.dispose();
  }

  bool _guardando = false;

  Future<void> _continuar() async {
    if (_guardando) return;
    final nombre = _nombreController.text.trim();
    if (nombre.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor escribe tu nombre')),
      );
      return;
    }

    setState(() => _guardando = true);
    try {
      // Registra (o reutiliza) al usuario en el backend y lo guarda en memoria.
      final usuario = await ApiService.instance.registrarUsuario(nombre);
      await _usuarioService.guardar(Usuario(id: usuario.id, nombre: usuario.nombre));
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const InicioScreen()),
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.mensaje)));
    } finally {
      if (mounted) setState(() => _guardando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Círculo decorativo derecho
          Positioned(
            right: -40,
            top: 150,
            child: Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: AppColors.circleGrey,
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Círculo con logo (esquina inferior izquierda)
          const Positioned(
            left: -60,
            bottom: -60,
            child: LogoCircle(),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const HeaderBar(),
                  const SizedBox(height: 24),
                  const WelcomeCard(),
                  const SizedBox(height: 16),
                  NameCard(
                    controller: _nombreController,
                    onContinuar: _continuar,
                  ),
                  const SizedBox(height: 16),
                  const FooterBadge(),
                  const SizedBox(height: 200),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
