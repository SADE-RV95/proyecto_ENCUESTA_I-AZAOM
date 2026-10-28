import 'package:encuestas_uni/widgets/app_colors.dart';
import 'package:encuestas_uni/widgets/jfm_avatar.dart';
import 'package:flutter/material.dart';

/// Encabezado con avatar y títulos.
class HeaderBar extends StatelessWidget {
  const HeaderBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        JfmAvatar(size: 32, fontSize: 11),
        SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Encuestas',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: AppColors.brown,
              ),
            ),
            Text(
              'Anáhuac Cancún',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.orangeDark,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
