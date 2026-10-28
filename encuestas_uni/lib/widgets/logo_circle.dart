import 'package:encuestas_uni/widgets/app_colors.dart';
import 'package:flutter/material.dart';

/// Círculo decorativo con el logo de JFM.
///
/// Usa la misma ruta que la pantalla splash: assets/images/logo_jfm.png.
/// Si la imagen todavía no existe, muestra un ícono de respaldo.
class LogoCircle extends StatelessWidget {
  const LogoCircle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 210,
      height: 210,
      decoration: const BoxDecoration(
        color: AppColors.circleGrey,
        shape: BoxShape.circle,
      ),
      alignment: const Alignment(0.35, -0.35),
      child: Image.asset(
        'assets/images/logo_jfm.png',
        width: 90,
        errorBuilder: (_, _, _) => const Icon(
          Icons.church_outlined,
          size: 48,
          color: AppColors.brown,
        ),
      ),
    );
  }
}
