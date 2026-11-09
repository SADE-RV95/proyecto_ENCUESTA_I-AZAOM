import 'package:encuestas_uni/widgets/app_colors.dart';
import 'package:flutter/material.dart';

/// Botón grande de acción principal (ancho completo).
class PrimaryButton extends StatelessWidget {
  final String texto;
  final IconData? icono;
  final VoidCallback? onPressed;
  final bool cargando;
  final Color color;
  final Color colorTexto;

  const PrimaryButton({
    super.key,
    required this.texto,
    this.icono,
    required this.onPressed,
    this.cargando = false,
    this.color = AppColors.orange,
    this.colorTexto = AppColors.brown,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: cargando ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: colorTexto,
          disabledBackgroundColor: color.withValues(alpha: 0.6),
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: cargando
            ? SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2.5, color: colorTexto),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      texto,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                    ),
                  ),
                  if (icono != null) ...[
                    const SizedBox(width: 10),
                    Icon(icono, size: 20),
                  ],
                ],
              ),
      ),
    );
  }
}
