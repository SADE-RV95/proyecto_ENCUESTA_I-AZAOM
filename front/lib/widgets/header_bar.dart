import 'package:encuestas_uni/widgets/app_colors.dart';
import 'package:encuestas_uni/widgets/jfm_avatar.dart';
import 'package:flutter/material.dart';

/// Encabezado con avatar y títulos.
class HeaderBar extends StatelessWidget {
  final String subtitulo;

  const HeaderBar({super.key, this.subtitulo = 'Anáhuac Cancún'});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const JfmAvatar(size: 32, fontSize: 11),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Encuestas',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: AppColors.brown,
              ),
            ),
            Text(
              subtitulo,
              style: const TextStyle(
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
