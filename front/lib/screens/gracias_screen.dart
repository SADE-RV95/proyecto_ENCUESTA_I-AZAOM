import 'package:encuestas_uni/widgets/app_colors.dart';
import 'package:encuestas_uni/widgets/primary_button.dart';
import 'package:flutter/material.dart';

/// Confirmación al enviar una encuesta.
class GraciasScreen extends StatelessWidget {
  const GraciasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.orange,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 96,
                  height: 96,
                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                  child: const Icon(Icons.check_rounded, size: 56, color: AppColors.green),
                ),
                const SizedBox(height: 28),
                const Text(
                  '¡Gracias por participar!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    color: AppColors.brown,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Tu encuesta fue enviada. Tu voz ayuda a mejorar los programas de la comunidad.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.4,
                    color: AppColors.brown.withValues(alpha: 0.8),
                  ),
                ),
                const SizedBox(height: 32),
                PrimaryButton(
                  texto: 'Volver al inicio',
                  icono: Icons.home_outlined,
                  color: AppColors.brown,
                  colorTexto: AppColors.orange,
                  onPressed: () => Navigator.of(context).popUntil((r) => r.isFirst),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
