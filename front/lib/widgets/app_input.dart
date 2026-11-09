import 'package:encuestas_uni/widgets/app_colors.dart';
import 'package:flutter/material.dart';

/// Decoración común de los campos de texto de la app.
InputDecoration decoracionCampo(String hint) {
  OutlineInputBorder borde(Color color, [double ancho = 1]) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: color, width: ancho),
      );
  return InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(color: AppColors.hint),
    filled: true,
    fillColor: AppColors.inputFill,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    enabledBorder: borde(AppColors.inputBorder),
    focusedBorder: borde(AppColors.orange, 1.6),
  );
}

/// Campo que abre una hoja inferior para elegir entre varias opciones.
class CampoSeleccion extends StatelessWidget {
  final String titulo;
  final List<String> opciones;
  final String? valor;
  final ValueChanged<String> onChanged;

  const CampoSeleccion({
    super.key,
    required this.titulo,
    required this.opciones,
    required this.valor,
    required this.onChanged,
  });

  Future<void> _abrir(BuildContext context) async {
    final elegido = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: AppColors.background,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: MediaQuery.of(ctx).size.height * 0.7),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                child: Text(
                  titulo,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.brown,
                  ),
                ),
              ),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    for (final o in opciones)
                      ListTile(
                        title: Text(o, style: const TextStyle(color: AppColors.brown)),
                        trailing: o == valor
                            ? const Icon(Icons.check, color: AppColors.orangeDark)
                            : null,
                        onTap: () => Navigator.pop(ctx, o),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
    if (elegido != null) onChanged(elegido);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => _abrir(context),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.inputFill,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.inputBorder),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                valor ?? 'Seleccionar',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: valor == null ? FontWeight.w400 : FontWeight.w600,
                  color: valor == null ? AppColors.hint : AppColors.brown,
                ),
              ),
            ),
            const Icon(Icons.keyboard_arrow_down, color: AppColors.orangeDark),
          ],
        ),
      ),
    );
  }
}
