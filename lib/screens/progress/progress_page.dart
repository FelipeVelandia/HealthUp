import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'widgets/exam_card.dart';

class ProgressPage extends StatelessWidget {
  const ProgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              ExamCard(
                num: 1,
                description: "Toma de medidas corporales.",
                completed: false,
                onTap: () => showMessageModal(context,
                    "El exámen de toma de medidas corporales debe ser registrado por el profesional de la salud encargado."),
              ),
              const SizedBox(height: 12),
              ExamCard(
                num: 2,
                description: "Muestras de laboratorio.",
                completed: false,
                onTap: () => showMessageModal(context,
                    "El exámen de toma de muestras clínicas debe ser registrado por el profesional de la salud encargado."),
              ),
              const SizedBox(height: 12),
              ExamCard(
                num: 3,
                description: "Informe genético.",
                completed: false,
                onTap: () => showMessageModal(context,
                    "El exámen de análisis de muestras genéticas debe ser registrado por el profesional de la salud encargado."),
              ),
              const SizedBox(height: 12),
              ExamCard(
                num: 4,
                description: "Encuesta nutricional inicial.",
                completed: false,
                onTap: () => GoRouter.of(context).push("/initial"),
              ),
              const SizedBox(height: 12),
              ExamCard(
                num: 5,
                description: "Frecuencia de consumo de alimentos.",
                completed: false,
                onTap: () {},
              ),
              const SizedBox(height: 12),
            ],
          ),
        ));
  }
}

void showMessageModal(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Sobre este examen:'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('Cerrar'),
            onPressed: () {
              Navigator.of(context).pop(); // Cierra el modal
            },
          ),
        ],
      );
    },
  );
}
