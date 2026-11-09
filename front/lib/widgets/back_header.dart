import 'package:encuestas_uni/widgets/app_colors.dart';
import 'package:encuestas_uni/widgets/header_bar.dart';
import 'package:flutter/material.dart';

/// Flecha de regreso + encabezado de la app (para pantallas sobre fondo naranja).
class BackHeader extends StatelessWidget {
  final String subtitulo;
  final VoidCallback? onBack;

  const BackHeader({super.key, this.subtitulo = 'Anáhuac Cancún', this.onBack});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: onBack ?? () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.arrow_back, color: AppColors.brown),
          tooltip: 'Regresar',
        ),
        HeaderBar(subtitulo: subtitulo),
      ],
    );
  }
}
