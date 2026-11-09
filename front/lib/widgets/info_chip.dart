import 'package:encuestas_uni/widgets/app_colors.dart';
import 'package:flutter/material.dart';

/// Chip pequeño con ícono y texto (ej. "8 preguntas", "5 min").
class InfoChip extends StatelessWidget {
  final IconData icono;
  final String texto;

  const InfoChip({super.key, required this.icono, required this.texto});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.footerBg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icono, size: 13, color: AppColors.orangeDark),
          const SizedBox(width: 4),
          Text(
            texto,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.label,
            ),
          ),
        ],
      ),
    );
  }
}
