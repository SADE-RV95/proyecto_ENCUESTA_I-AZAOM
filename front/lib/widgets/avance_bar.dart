import 'package:encuestas_uni/widgets/app_colors.dart';
import 'package:flutter/material.dart';

/// "Tu avance  3 de 8" con barra de progreso.
class AvanceBar extends StatelessWidget {
  final int actual;
  final int total;

  const AvanceBar({super.key, required this.actual, required this.total});

  @override
  Widget build(BuildContext context) {
    const estilo = TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: AppColors.brown,
    );
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Tu avance', style: estilo),
            Text('$actual de $total', style: estilo),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: total == 0 ? 0 : actual / total,
            minHeight: 6,
            color: AppColors.orange,
            backgroundColor: AppColors.inputFill,
          ),
        ),
      ],
    );
  }
}
