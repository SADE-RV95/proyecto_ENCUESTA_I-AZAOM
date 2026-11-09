import 'package:encuestas_uni/models/encuesta.dart';
import 'package:encuestas_uni/screens/formulario_screen.dart';
import 'package:encuestas_uni/widgets/app_card.dart';
import 'package:encuestas_uni/widgets/app_colors.dart';
import 'package:encuestas_uni/widgets/avance_bar.dart';
import 'package:encuestas_uni/widgets/back_header.dart';
import 'package:encuestas_uni/widgets/footer_badge.dart';
import 'package:encuestas_uni/widgets/info_chip.dart';
import 'package:flutter/material.dart';

/// Pantalla previa al formulario: resumen de la encuesta seleccionada.
class AntesComenzarScreen extends StatelessWidget {
  final Encuesta encuesta;

  const AntesComenzarScreen({super.key, required this.encuesta});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.orange,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(10, 4, 22, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BackHeader(),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Column(
                  children: [
                    AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Antes de comenzar',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: AppColors.brown,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Te invitamos a compartir tu opinión para entender mejor cómo '
                            'vives tu comunidad y orientar los próximos apoyos.',
                            style: TextStyle(fontSize: 13, height: 1.4, color: AppColors.textGrey),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'ENCUESTA SELECCIONADA',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.6,
                              color: AppColors.label,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            encuesta.titulo,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              height: 1.15,
                              color: AppColors.brown,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              InfoChip(
                                icono: Icons.checklist_rounded,
                                texto: '${encuesta.numPreguntas} preguntas',
                              ),
                              InfoChip(icono: Icons.schedule, texto: '${encuesta.minutos} min'),
                            ],
                          ),
                          const SizedBox(height: 14),
                          const Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.verified_user_outlined, size: 16, color: AppColors.green),
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
                          const SizedBox(height: 14),
                          AvanceBar(actual: 0, total: encuesta.numPreguntas),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FormularioScreen(encuestaId: encuesta.id),
                        ),
                      ),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.brown,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Comenzar encuesta',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward, size: 18),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    const FooterBadge(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
