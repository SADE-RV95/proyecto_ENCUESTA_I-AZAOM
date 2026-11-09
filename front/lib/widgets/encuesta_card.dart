import 'package:encuestas_uni/models/encuesta.dart';
import 'package:encuestas_uni/utils/formatos.dart';
import 'package:encuestas_uni/widgets/app_card.dart';
import 'package:encuestas_uni/widgets/app_colors.dart';
import 'package:encuestas_uni/widgets/estado_chip.dart';
import 'package:encuestas_uni/widgets/info_chip.dart';
import 'package:encuestas_uni/widgets/primary_button.dart';
import 'package:flutter/material.dart';

/// Tarjeta de una encuesta disponible para responder.
class EncuestaCard extends StatelessWidget {
  final Encuesta encuesta;
  final VoidCallback onComenzar;

  const EncuestaCard({super.key, required this.encuesta, required this.onComenzar});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const EstadoChip(estado: 'publicada', etiqueta: 'Disponible'),
              const Spacer(),
              if (encuesta.fechaLimite != null) ...[
                const Icon(Icons.calendar_today_outlined, size: 12, color: AppColors.textGrey),
                const SizedBox(width: 4),
                Text(
                  'Hasta el ${fechaCorta(encuesta.fechaLimite!)}',
                  style: const TextStyle(fontSize: 11, color: AppColors.textGrey),
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),
          Text(
            encuesta.titulo,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              height: 1.15,
              color: AppColors.brown,
            ),
          ),
          if (encuesta.descripcion.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              encuesta.descripcion,
              style: const TextStyle(fontSize: 13, height: 1.35, color: AppColors.textGrey),
            ),
          ],
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              InfoChip(icono: Icons.checklist_rounded, texto: '${encuesta.numPreguntas} preguntas'),
              InfoChip(icono: Icons.schedule, texto: '${encuesta.minutos} min'),
            ],
          ),
          const SizedBox(height: 16),
          PrimaryButton(
            texto: 'Comenzar encuesta',
            icono: Icons.arrow_forward,
            onPressed: onComenzar,
          ),
          const SizedBox(height: 10),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.verified_user_outlined, size: 14, color: AppColors.green),
              SizedBox(width: 6),
              Text(
                'Tus respuestas son confidenciales',
                style: TextStyle(fontSize: 11, color: AppColors.textGrey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
