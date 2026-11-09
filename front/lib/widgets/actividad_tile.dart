import 'package:encuestas_uni/models/actividad.dart';
import 'package:encuestas_uni/utils/formatos.dart';
import 'package:encuestas_uni/widgets/app_colors.dart';
import 'package:flutter/material.dart';

/// Fila del historial: encuesta completada y enviada.
class ActividadTile extends StatelessWidget {
  final Actividad actividad;

  const ActividadTile({super.key, required this.actividad});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.green, width: 1.4),
            ),
            child: const Icon(Icons.check, size: 16, color: AppColors.green),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  actividad.titulo,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.brown,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Completada · ${fechaLarga(actividad.creadoEn)}',
                  style: const TextStyle(fontSize: 11, color: AppColors.textGrey),
                ),
              ],
            ),
          ),
          const Text(
            'Enviada',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.green,
            ),
          ),
        ],
      ),
    );
  }
}
