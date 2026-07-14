import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nutrialg_life/points_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:nutrialg_life/services/database_service.dart';
import 'package:nutrialg_life/models/puntos.dart';

class AchievementModel {
  final String title;
  final String description;
  final int maxTarget;
  final IconData icon;
  final Color activeColor;
  final String category; // 'exercise', 'rewards', 'streaks'

  AchievementModel({
    required this.title,
    required this.description,
    required this.maxTarget,
    required this.icon,
    required this.activeColor,
    required this.category,
  });
}

class AchievementsPage extends StatefulWidget {
  const AchievementsPage({super.key});

  @override
  State<AchievementsPage> createState() => _AchievementsPageState();
}

class _AchievementsPageState extends State<AchievementsPage> {
  int _historicExerciseDays = 0;
  int _historicWaterDays = 0;
  int _historicMealsCount = 0;
  bool _isLoading = true;

  final List<AchievementModel> _achievementsList = [
    // --- CATEGORÍA: ACTIVIDAD FÍSICA ---
    AchievementModel(
      title: 'Primer Bloque',
      description: 'Completa tu primer día de actividad física de 30 minutos.',
      maxTarget: 1,
      icon: FontAwesomeIcons.personRunning,
      activeColor: Colors.orange,
      category: 'exercise',
    ),
    AchievementModel(
      title: 'Hábito en Marcha',
      description:
          'Completa tu bloque de ejercicio diario durante 7 días continuos para consolidar las bases de tu entrenamiento.',
      maxTarget: 7,
      icon: FontAwesomeIcons.shoePrints,
      activeColor: Colors.teal,
      category: 'exercise',
    ),
    AchievementModel(
      title: 'Espíritu Activo',
      description:
          'Mantén tu constancia deportiva durante 30 días para transformar tu acondicionamiento físico general.',
      maxTarget: 30,
      icon: FontAwesomeIcons.dumbbell,
      activeColor: Colors.deepOrange,
      category: 'exercise',
    ),
    AchievementModel(
      title: 'Atleta Imparable',
      description:
          'Consigue registrar 100 días de entrenamiento físico estructurado y demuestra un compromiso inquebrantable con tu salud.',
      maxTarget: 100,
      icon: FontAwesomeIcons.trophy,
      activeColor: Colors.amber,
      category: 'exercise',
    ),

    // --- CATEGORÍA: RECOMPENSAS RECLAMADAS ---
    AchievementModel(
      title: 'Primer Regalo',
      description: 'Reclama tu primera recompensa sorpresa.',
      maxTarget: 1,
      icon: FontAwesomeIcons.gift,
      activeColor: Colors.purpleAccent,
      category: 'rewards',
    ),
    AchievementModel(
      title: 'Coleccionista de Recetas',
      description:
          'Canjea tus puntos acumulados por 5 recetas exclusivas en formato descargable.',
      maxTarget: 5,
      icon: FontAwesomeIcons.bookOpen,
      activeColor: Colors.deepPurple,
      category: 'rewards',
    ),
    AchievementModel(
      title: 'Cazador de Premios',
      description:
          'Abre un total de 15 regalos sorpresa de nivel y expande tu catálogo gastronómico saludable.',
      maxTarget: 15,
      icon: FontAwesomeIcons.award,
      activeColor: Colors.indigo,
      category: 'rewards',
    ),
    AchievementModel(
      title: 'Gourmet Supremo',
      description:
          'Desbloquea 50 recompensas matemáticas justas a lo largo de tu trayectoria en la aplicación.',
      maxTarget: 50,
      icon: FontAwesomeIcons.medal,
      activeColor: Colors.redAccent,
      category: 'rewards',
    ),

    // --- CATEGORÍA: CONSTANCIA ESPECÍFICA ---
    AchievementModel(
      title: 'Hidratación Base',
      description: 'Completa la meta de agua automatizada durante 3 días.',
      maxTarget: 3,
      icon: FontAwesomeIcons.faucetDrip,
      activeColor: Colors.cyan,
      category: 'streaks',
    ),
    AchievementModel(
      title: 'Manantial de Salud',
      description:
          'Alcanza tu meta de hidratación inteligente calculada por peso por un total de 14 días.',
      maxTarget: 14,
      icon: FontAwesomeIcons.droplet,
      activeColor: Colors.blue,
      category: 'streaks',
    ),
    AchievementModel(
      title: 'Menú Disciplinado',
      description: 'Registra y marca como completadas 20 comidas planificadas.',
      maxTarget: 20,
      icon: FontAwesomeIcons.utensils,
      activeColor: Colors.pinkAccent,
      category: 'streaks',
    ),
    AchievementModel(
      title: 'Nutrición de Élite',
      description:
          'Completa un gran total de 100 comidas sugeridas por el sistema para optimizar tus hábitos alimenticios.',
      maxTarget: 100,
      icon: FontAwesomeIcons.plateWheat,
      activeColor: Colors.lightGreen,
      category: 'streaks',
    ),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadHistoricalStats();
    });
  }

  // MODIFICACIÓN: Recuperar las métricas de logros desde la colección dedicada 'puntos' en Firestore
  Future<void> _loadHistoricalStats() async {
    final user = Provider.of<DatabaseService>(context, listen: false).user;

    if (user != null) {
      final docPuntos = await FirebaseFirestore.instance
          .collection('puntos')
          .doc(user.uid)
          .get();

      if (docPuntos.exists && docPuntos.data() != null) {
        final puntosObj = PuntosModel.fromMap(user.uid, docPuntos.data());
        _historicExerciseDays = puntosObj.historicExerciseDays;
        _historicWaterDays = puntosObj.historicWaterDays;
        _historicMealsCount = puntosObj.historicMealsCount;
        globalPointsNotifier.value = puntosObj.valor;
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  int _getCurrentValueForAchievement(
      AchievementModel achievement, int currentRewards) {
    switch (achievement.category) {
      case 'exercise':
        return _historicExerciseDays;
      case 'rewards':
        return currentRewards;
      case 'streaks':
        if (achievement.title.contains('Hidratación') ||
            achievement.title.contains('Manantial')) {
          return _historicWaterDays;
        } else {
          return _historicMealsCount;
        }
      default:
        return 0;
    }
  }

  void _showAchievementDetails(BuildContext context,
      AchievementModel achievement, int currentValue, bool isUnlocked) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
          icon: CircleAvatar(
            radius: 36,
            backgroundColor: achievement.activeColor.withOpacity(0.15),
            child: Icon(
              achievement.icon,
              color: achievement.activeColor,
              size: 32,
            ),
          ),
          title: Text(
            achievement.title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                achievement.description,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 15, color: Colors.black87, height: 1.4),
              ),
              const SizedBox(height: 20),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                decoration: BoxDecoration(
                  color:
                      isUnlocked ? Colors.green.shade50 : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isUnlocked ? Icons.check_circle : Icons.hourglass_bottom,
                      color: isUnlocked ? Colors.green : Colors.grey,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isUnlocked
                          ? '¡Logro Completado!'
                          : 'Progreso actual: $currentValue / ${achievement.maxTarget}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color:
                            isUnlocked ? Colors.green.shade700 : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            SizedBox(
              width: 150,
              child: TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xFF6B42C8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Entendido',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return AnimatedBuilder(
      animation:
          Listenable.merge([globalPointsNotifier, globalRewardsNotifier]),
      builder: (context, child) {
        final int currentRewards = globalRewardsNotifier.value;

        int unlockedCount = _achievementsList.where((achievement) {
          int current =
              _getCurrentValueForAchievement(achievement, currentRewards);
          return current >= achievement.maxTarget;
        }).length;
        return Scaffold(
          backgroundColor: const Color(0xFFF5F5F5),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFF44336), Color(0xFFEF5350)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Icon(FontAwesomeIcons.medal,
                          color: Colors.amber, size: 45),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Constancia Demostrada',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Has desbloqueado $unlockedCount de ${_achievementsList.length} logros',
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: GridView.builder(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: _achievementsList.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.85,
                  ),
                  itemBuilder: (context, index) {
                    final achievement = _achievementsList[index];
                    final int current = _getCurrentValueForAchievement(
                        achievement, currentRewards);
                    final bool isUnlocked = current >= achievement.maxTarget;
                    final double progressPercentage =
                        (current / achievement.maxTarget).clamp(0.0, 1.0);
                    return GestureDetector(
                      onTap: () => _showAchievementDetails(
                          context, achievement, current, isUnlocked),
                      child: Card(
                        elevation: isUnlocked ? 4 : 1,
                        color: isUnlocked ? Colors.white : Colors.grey.shade100,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: isUnlocked
                              ? BorderSide(
                                  color:
                                      achievement.activeColor.withOpacity(0.5),
                                  width: 1.5)
                              : BorderSide.none,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CircleAvatar(
                                radius: 28,
                                backgroundColor: isUnlocked
                                    ? achievement.activeColor.withOpacity(0.15)
                                    : Colors.grey.shade300,
                                child: Icon(
                                  achievement.icon,
                                  color: isUnlocked
                                      ? achievement.activeColor
                                      : Colors.grey.shade500,
                                  size: 26,
                                ),
                              ),
                              Text(
                                achievement.title,
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: isUnlocked
                                      ? Colors.black87
                                      : Colors.grey.shade600,
                                ),
                              ),
                              Text(
                                achievement.description,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: isUnlocked
                                      ? Colors.black54
                                      : Colors.grey.shade500,
                                ),
                              ),
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        isUnlocked
                                            ? '¡Hecho!'
                                            : '$current / ${achievement.maxTarget}',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: isUnlocked
                                              ? Colors.green
                                              : Colors.grey.shade600,
                                        ),
                                      ),
                                      if (isUnlocked)
                                        const Icon(Icons.check_circle,
                                            color: Colors.green, size: 12),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: LinearProgressIndicator(
                                      value: progressPercentage,
                                      backgroundColor: Colors.grey.shade300,
                                      color: isUnlocked
                                          ? Colors.green
                                          : achievement.activeColor,
                                      minHeight: 5,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
