import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nutrialg_life/points_manager.dart';
import 'widgets/exam_card.dart';
import 'package:go_router/go_router.dart';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:nutrialg_life/services/database_service.dart';
import 'package:provider/provider.dart';

class ProgressPage extends StatelessWidget {
  ProgressPage({super.key});
  final firestore = DatabaseService();

  final int _pointsGoal = 20; // Meta fija de puntos

  // NUEVO: Generador de saludo dinámico y empático según la hora real del dispositivo
  String _getFriendlyGreeting() {
    final int hour = DateTime.now().hour;
    if (hour >= 6 && hour < 12) {
      return '¡Buenos días! ☀️';
    } else if (hour >= 12 && hour < 19) {
      return '¡Buenas tardes! 🌆';
    } else {
      return '¡Buenas noches! 🌙';
    }
  }

  void _claimReward(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();

    // Conservamos los puntos excedentes de forma matemática justa
    final int puntosActuales = globalPointsNotifier.value;
    final int puntosExcedentes = puntosActuales - _pointsGoal;

    globalPointsNotifier.value = puntosExcedentes > 0 ? puntosExcedentes : 0;
    await prefs.setInt(
        'user_accumulated_points_key', globalPointsNotifier.value);

    globalRewardsNotifier.value += 1;
    await prefs.setInt('user_claimed_rewards_key', globalRewardsNotifier.value);

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
      'https://ejemplo.com0',
    ];

    final int indiceAleatorio = Random().nextInt(listaEnlacesPremios.length);
    final String urlDeDescargaSeleccionada =
        listaEnlacesPremios[indiceAleatorio];

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

    if (context.mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            icon: const CircleAvatar(
              radius: 32,
              backgroundColor: Colors.purple,
              child: Icon(Icons.card_giftcard, color: Colors.white, size: 40),
            ),
            title: const Text(
              '¡Regalo Sorpresa!',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '🎁 ¡Has ganado el Premio #${indiceAleatorio + 1}! 🎁',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.purple),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Te ha tocado una receta aleatoria exclusiva. Presiona el botón de abajo para copiar el enlace de descarga.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ],
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
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
                  SizedBox(
                    width: 200,
                    height: 45,
                    child: TextButton(
                      style: TextButton.styleFrom(foregroundColor: Colors.grey),
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cerrar',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
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
    var user = Provider.of<DatabaseService>(context).user;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        automaticallyImplyLeading: false, // Quita la flecha de regreso
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight:
            0, // Ocultamos el AppBar tradicional para darle más espacio al nuevo banner visual
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: FutureBuilder(
            future: firestore.getPaciente(user!.uid),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.data == null) {
                  return Container(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    child: const Center(
                      child: Text("Sin datos de usuario"),
                    ),
                  );
                } else {
                  var nombre = snapshot.data.nombre;
                  return Column(
                    children: [
                      // NUEVO: Banner de Bienvenida Llamativo y Vistoso con Degradado
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF32A287),
                              Color(0xFF4AC2A5)
                            ], // Tonos verdes de tu app
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF32A287).withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            )
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _getFriendlyGreeting(),
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '¡Qué alegría verte de nuevo $nombre! Vamos a revisar los grandes pasos y metas que has conquistado hoy. ✨',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.9),
                                fontWeight: FontWeight.w500,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

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
                              bool canClaim = totalPoints >= _pointsGoal;

                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    'Progreso de Nivel',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87),
                                  ),
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
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  canClaim
                                                      ? Colors.green
                                                      : Colors.blue),
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
                                          Text(
                                            '/ $_pointsGoal Pts',
                                            style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 32),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 50,
                                    child: ElevatedButton.icon(
                                      icon: const Icon(Icons.card_giftcard),
                                      label: const Text(
                                        'Reclamar Recompensa',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                        foregroundColor: Colors.white,
                                        disabledBackgroundColor:
                                            Colors.grey.shade300,
                                        disabledForegroundColor:
                                            Colors.grey.shade500,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                        elevation: canClaim ? 4 : 0,
                                      ),
                                      onPressed: canClaim
                                          ? () => _claimReward(context)
                                          : null,
                                    ),
                                  ),
                                  const SizedBox(height: 32),
                                  ExamCard(
                                    description: "Formulario de antecedentes",
                                    completed: false,
                                    onTap: () =>
                                        GoRouter.of(context).push("/initial"),
                                  ),
                                  const SizedBox(height: 25),
                                  ExamCard(
                                    description: "Misiones Diarias",
                                    completed: false,
                                    onTap: () =>
                                        GoRouter.of(context).push("/daily"),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                }
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text('Loading');
              } else {
                return const Text('Error');
              }
            }),
      ),
    );
  }
}
