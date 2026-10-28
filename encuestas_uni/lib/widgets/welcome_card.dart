import 'package:encuestas_uni/widgets/app_card.dart';
import 'package:encuestas_uni/widgets/app_colors.dart';
import 'package:flutter/material.dart';

/// Tarjeta de bienvenida con el aviso de confidencialidad.
class WelcomeCard extends StatelessWidget {
  const WelcomeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '¡Bienvenido! 👋',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: AppColors.brown,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Antes de comenzar, necesitamos saber tu nombre. '
            'Lo utilizaremos para identificar quién está realizando '
            'las encuestas.\n¿Cuál es tu nombre?',
            style: TextStyle(
              fontSize: 14,
              height: 1.4,
              color: AppColors.textGrey,
            ),
          ),
          SizedBox(height: 14),
          Divider(height: 1, color: AppColors.cardBorder),
          SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.verified_user_outlined,
                  size: 16, color: AppColors.green),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Tus respuestas son confidenciales y solo se usarán para '
                  'mejorar los programas de la comunidad.',
                  style: TextStyle(
                    fontSize: 11.5,
                    height: 1.35,
                    color: AppColors.textGrey,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
