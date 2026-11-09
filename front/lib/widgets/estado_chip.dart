import 'package:encuestas_uni/widgets/app_colors.dart';
import 'package:flutter/material.dart';

/// Etiqueta de estado: PUBLICADA / BORRADOR / CERRADA / DISPONIBLE.
class EstadoChip extends StatelessWidget {
  final String estado;
  final String? etiqueta;

  const EstadoChip({super.key, required this.estado, this.etiqueta});

  @override
  Widget build(BuildContext context) {
    late final Color fondo;
    late final Color texto;
    switch (estado) {
      case 'publicada':
        fondo = const Color(0xFFE3F4EA);
        texto = AppColors.green;
        break;
      case 'cerrada':
        fondo = const Color(0xFFFFE3D1);
        texto = AppColors.label;
        break;
      default: // borrador
        fondo = AppColors.circleGrey;
        texto = AppColors.textGrey;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: fondo,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: texto, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            (etiqueta ?? estado).toUpperCase(),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
              color: texto,
            ),
          ),
        ],
      ),
    );
  }
}
