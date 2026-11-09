import 'package:encuestas_uni/widgets/app_card.dart';
import 'package:encuestas_uni/widgets/app_colors.dart';
import 'package:flutter/material.dart';

/// Tarjeta con el campo de nombre y el botón "Continuar".
class NameCard extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onContinuar;

  const NameCard({
    super.key,
    required this.controller,
    required this.onContinuar,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'TU NOMBRE',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
              color: AppColors.label,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: controller,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => onContinuar(),
            style: const TextStyle(fontSize: 15, color: AppColors.brown),
            decoration: InputDecoration(
              hintText: 'Escribe tu nombre',
              hintStyle: const TextStyle(color: AppColors.hint),
              filled: true,
              fillColor: AppColors.inputFill,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: AppColors.inputBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide:
                    const BorderSide(color: AppColors.orange, width: 1.6),
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Puedes usar tu nombre completo o el nombre que prefieras '
            'que aparezca en tus encuestas.',
            style: TextStyle(
              fontSize: 11.5,
              height: 1.35,
              color: AppColors.textGrey,
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: onContinuar,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.orange,
                foregroundColor: AppColors.brown,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Continuar',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                  SizedBox(width: 10),
                  Icon(Icons.arrow_forward, size: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
