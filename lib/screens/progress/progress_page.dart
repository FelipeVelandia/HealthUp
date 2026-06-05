import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nutrialg_life/points_manager.dart';
import 'widgets/exam_card.dart';
import 'package:go_router/go_router.dart';
import 'dart:math';
import 'package:flutter/services.dart';

class ProgressPage extends StatelessWidget {
  const ProgressPage({super.key});

  final int _pointsGoal = 20; // Meta fija de puntos

  void _claimReward(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();

    // 1. Reiniciamos contadores locales y guardamos en disco
    globalPointsNotifier.value = 0;
    await prefs.setInt('user_accumulated_points_key', 0);
    globalRewardsNotifier.value += 1;
    await prefs.setInt('user_claimed_rewards_key', globalRewardsNotifier.value);

    // 2. Decisión Aleatoria para el tipo de premio (50% de probabilidad)
    final bool esOpcionDescarga = Random().nextBool();

    // 3. LISTA DE 10 ENLACES DE RECOMPENSA (Reemplaza estos links por tus archivos reales)
    final List<String> listaEnlacesPremios = [
      'https://ejemplo.com',
      'https://ejemplo.com',
      'https://ejemplo.com',
      'https://ejemplo.com',
      'https://ejemplo.com',
      'https://ejemplo.com',
      'https://ejemplo.com',
      'https://ejemplo.com',
      'https://ejemplo.com',
      'https://ejemplo.com',
    ];

    // Elegimos un índice al azar entre 0 y 9 para seleccionar el archivo de la lista
    final int indiceAleatorio = Random().nextInt(listaEnlacesPremios.length);
    final String urlDeDescargaSeleccionada =
        listaEnlacesPremios[indiceAleatorio];

    // Función nativa y segura para copiar el link seleccionado al portapapeles
    Future<void> _abrirEnlaceDescarga() async {
      await Clipboard.setData(ClipboardData(text: urlDeDescargaSeleccionada));

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                '📋 ¡Premio #${indiceAleatorio + 1} copiado! Pégalo en tu navegador.'),
            backgroundColor: Colors.purple,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }

    // 4. Desplegar el Pop-up seguro
    if (context.mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            icon: CircleAvatar(
              radius: 32,
              backgroundColor: esOpcionDescarga ? Colors.purple : Colors.amber,
              child: Icon(
                esOpcionDescarga ? Icons.card_giftcard : Icons.emoji_events,
                color: Colors.white,
                size: 40,
              ),
            ),
            title: Text(
              esOpcionDescarga ? '¡Regalo Sorpresa!' : '¡Nivel Completado!',
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  esOpcionDescarga
                      ? '🎁 ¡Has ganado el Premio #${indiceAleatorio + 1}! 🎁'
                      : '🎉 ¡Muchas felicidades! 🎉',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: esOpcionDescarga ? Colors.purple : Colors.green),
                ),
                const SizedBox(height: 12),
                Text(
                  esOpcionDescarga
                      ? 'Te ha tocado una receta aleatoria exclusiva. Presiona el botón de abajo para copiar el enlace de descarga.'
                      : 'Tu recompensa es hoy, consumir la comida de tu eleccion en una de los horarios, y aun asi marcarla como completa para obtener los puntos. Tus puntos se han reiniciado.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ],
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (esOpcionDescarga) ...[
                    SizedBox(
                      width: 200,
                      height: 45,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.content_copy),
                        label: const Text('Copiar Enlace',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () async {
                          await _abrirEnlaceDescarga();
                          if (context.mounted) Navigator.of(context).pop();
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                  SizedBox(
                    width: 200,
                    height: 45,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor:
                            esOpcionDescarga ? Colors.grey : Colors.blue,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        esOpcionDescarga ? 'Cerrar' : 'Genial',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        automaticallyImplyLeading: false, // This removes the back arrow
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: const Text(
            'Bienvenido de vuelta, revisa tu progreso',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 16),

            // PANEL PRINCIPAL DE PROGRESO
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24)),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 32.0, horizontal: 24.0),
                child: ValueListenableBuilder<int>(
                  valueListenable: globalPointsNotifier,
                  builder: (context, totalPoints, child) {
                    double percentage =
                        (totalPoints / _pointsGoal).clamp(0.0, 1.0);
                    bool canClaim =
                        totalPoints >= _pointsGoal; // Condición de activación

                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Progreso de Nivel',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87)),
                        const SizedBox(height: 24),

                        // Barra circular
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 180,
                              height: 180,
                              child: CircularProgressIndicator(
                                value: percentage,
                                strokeWidth: 14,
                                backgroundColor: Colors.grey.shade200,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    canClaim ? Colors.green : Colors.blue),
                                strokeCap: StrokeCap.round,
                              ),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '$totalPoints',
                                  style: TextStyle(
                                      fontSize: 36,
                                      fontWeight: FontWeight.bold,
                                      color: canClaim
                                          ? Colors.green
                                          : Colors.blue),
                                ),
                                Text('/ $_pointsGoal Pts',
                                    style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w500)),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),

                        // BOTÓN DINÁMICO DE RECLAMO
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.card_giftcard),
                            label: const Text('Reclamar Recompensa',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              disabledBackgroundColor: Colors.grey.shade300,
                              disabledForegroundColor: Colors.grey.shade500,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              elevation: canClaim ? 4 : 0,
                            ),
                            // Si los puntos son menores a la meta, pasamos null para congelar el botón
                            onPressed:
                                canClaim ? () => _claimReward(context) : null,
                          ),
                        ),
                        const SizedBox(height: 32),
                        ExamCard(
                          description: "Formulario de antecedentes",
                          completed: false,
                          onTap: () => GoRouter.of(context).push("/initial"),
                        ),
                        const SizedBox(height: 25),
                        ExamCard(
                          description: "Misiones Diarias",
                          completed: false,
                          onTap: () => GoRouter.of(context).push("/daily"),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
