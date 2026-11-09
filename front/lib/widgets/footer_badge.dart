import 'package:encuestas_uni/widgets/app_colors.dart';
import 'package:encuestas_uni/widgets/jfm_avatar.dart';
import 'package:flutter/material.dart';

/// Barra inferior con el nombre de la institución.
class FooterBadge extends StatelessWidget {
  const FooterBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.footerBg,
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Row(
        children: [
          JfmAvatar(
            size: 30,
            fontSize: 10,
            backgroundColor: AppColors.orange,
            textColor: AppColors.brown,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Juventud y Familia Misionera · Universidad Anáhuac Cancún',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.label,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
