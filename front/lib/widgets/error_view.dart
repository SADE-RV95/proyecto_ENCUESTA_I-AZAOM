import 'package:encuestas_uni/widgets/app_colors.dart';
import 'package:flutter/material.dart';

/// Mensaje de error con botón para reintentar.
class ErrorView extends StatelessWidget {
  final String mensaje;
  final VoidCallback onReintentar;

  const ErrorView({super.key, required this.mensaje, required this.onReintentar});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.cloud_off_outlined, size: 40, color: AppColors.hint),
          const SizedBox(height: 12),
          Text(
            mensaje,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, color: AppColors.textGrey),
          ),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: onReintentar,
            icon: const Icon(Icons.refresh),
            label: const Text('Reintentar'),
            style: TextButton.styleFrom(foregroundColor: AppColors.orangeDark),
          ),
        ],
      ),
    );
  }
}
