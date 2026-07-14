import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nutrialg_life/points_manager.dart';
import 'package:nutrialg_life/models/quest.dart';
import 'package:nutrialg_life/services/database_service.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nutrialg_life/models/puntos.dart';

class DailyPage extends StatefulWidget {
  const DailyPage({super.key});

  @override
  State<DailyPage> createState() => _DailyQuestsScreenState();
}

class _DailyQuestsScreenState extends State<DailyPage> {
  List<QuestModel> _quests = [];
  bool _isLoading = true;
  Timer? _timer;
  String _timeRemaining = "00:00:00";

  // Controladores y variables para gestionar el peso
  final TextEditingController _weightController = TextEditingController();
  double _userWeight = 0.0;

  // Estado para rastrear si el valor actual del campo de texto ya fue confirmado
  bool _isWeightConfirmed = true;

  // Variable en el estado de tu clase
  int _consumedWater = 0;
  bool _waterPointsAwardedToday = false;

  // Variables locales para almacenar los contadores históricos de Firestore
  int _historicExerciseDays = 0;
  int _historicWaterDays = 0;
  int _historicMealsCount = 0;

  // Instancia del servicio de base de datos
  final firestore = DatabaseService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDataFromStorage();
    });
    _startCountdown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _weightController.dispose();
    super.dispose();
  }

  // Helper unificado para construir la lista e inyectar puntos automáticos
  List<QuestModel> _buildFreshQuestsList(Map<int, bool> completionMap) {
    final Map<int, Map<String, dynamic>> visualResources = {
      1: {'icon': Icons.directions_run, 'color': Colors.orange},
      2: {'icon': Icons.menu_book, 'color': Colors.purple},
      3: {'icon': Icons.water_drop, 'color': Colors.blue},
    };

    // 1. Lógica Misión 1 (Ejercicio)
    const int recommendedMinutes = 30;
    String exerciseSubtitle =
        'Meta de hoy: Completa un bloque de $recommendedMinutes minutos de actividad física';

    String hydrationSubtitle = 'Bebe agua para mantenerte hidratado';

    bool hydrationCompleted = completionMap[3] ?? false;

    if (_userWeight > 0) {
      // 2. Lógica Misión 3 (Hidratación inteligente)
      final double totalMl = _userWeight * 22;
      final double totalLiters = totalMl / 1000;

      hydrationSubtitle =
          'Progreso: $_consumedWater mL de ${totalMl.toStringAsFixed(0)} mL (${totalLiters.toStringAsFixed(1)}L)';

      // 3. GATILLO DE AUTOMATIZACIÓN DE PUNTOS
      if (_consumedWater >= totalMl && !_waterPointsAwardedToday) {
        hydrationCompleted = true;
        _waterPointsAwardedToday = true;

        Future.microtask(() async {
          globalPointsNotifier.value += 20;

          final user =
              Provider.of<DatabaseService>(context, listen: false).user;
          if (user != null) {
            // MODIFICACIÓN: Incrementar contador histórico de agua y persistir en el modelo de Firestore
            _historicWaterDays += 1;

            final puntosObj = PuntosModel(
              uid: user.uid,
              valor: globalPointsNotifier.value,
              historicExerciseDays: _historicExerciseDays,
              historicWaterDays: _historicWaterDays,
              historicMealsCount: _historicMealsCount,
            );
            await FirebaseFirestore.instance
                .collection('puntos')
                .doc(user.uid)
                .set(puntosObj.toMap());
          }

          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('water_points_awarded_key', true);

          _saveDataToStorage();

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                    '💧 ¡Meta de agua alcanzada! Ganaste +20 Pts automáticamente.'),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 2),
              ),
            );
          }
        });
      } else if (_consumedWater >= totalMl) {
        hydrationCompleted = true;
      }
    }

    completionMap[3] = hydrationCompleted;

    return [
      QuestModel(
        id: 1,
        title: 'Ejercicio diario',
        subtitle: exerciseSubtitle,
        reward: '+20 Pts',
        icon: visualResources[1]?['icon'],
        color: visualResources[1]?['color'],
        isCompleted: completionMap[1] ?? false,
      ),
      QuestModel(
        id: 2,
        title: 'Hábito de nutricion',
        subtitle:
            'Alimentate durante las horas y siguiendo las cantidades recomendadas',
        reward: '+20 Pts',
        icon: visualResources[2]?['icon'],
        color: visualResources[2]?['color'],
        isCompleted: completionMap[2] ?? false,
      ),
      QuestModel(
        id: 3,
        title: 'Hidratación óptima',
        subtitle: hydrationSubtitle,
        reward: '+20 Pts',
        icon: visualResources[3]?['icon'],
        color: visualResources[3]?['color'],
        isCompleted: completionMap[3] ?? false,
      ),
    ];
  }

  Future<void> _loadDataFromStorage() async {
    final user = Provider.of<DatabaseService>(context, listen: false).user;

    // MODIFICACIÓN: Leer puntos y contadores de logros unificados utilizando PuntosModel de Firestore
    if (user != null) {
      final docPuntos = await FirebaseFirestore.instance
          .collection('puntos')
          .doc(user.uid)
          .get();
      if (docPuntos.exists && docPuntos.data() != null) {
        final puntosObj = PuntosModel.fromMap(user.uid, docPuntos.data());
        globalPointsNotifier.value = puntosObj.valor;
        _historicExerciseDays = puntosObj.historicExerciseDays;
        _historicWaterDays = puntosObj.historicWaterDays;
        _historicMealsCount = puntosObj.historicMealsCount;
      } else {
        globalPointsNotifier.value = 0;
      }
    }

    final prefs = await SharedPreferences.getInstance();

    _userWeight = prefs.getDouble('user_weight_key') ?? 0.0;
    if (_userWeight > 0) {
      _weightController.text = _userWeight.toStringAsFixed(1);
    }

    // --- NUEVA LÓGICA DE CONTROL DE CAMBIO DE DÍA ---
    final String todayDateStr = DateTime.now().toString().split(' ')[0];
    final String lastOpenedDate =
        prefs.getString('last_daily_opened_date_key') ?? "";

    if (todayDateStr != lastOpenedDate) {
      await prefs.setInt('user_consumed_water_key', 0);
      await prefs.setBool('water_points_awarded_key', false);
      await prefs.remove('daily_quests_key');
      await prefs.setString('last_daily_opened_date_key', todayDateStr);

      _consumedWater = 0;
      _waterPointsAwardedToday = false;

      Map<int, bool> resetMap = {1: false, 2: false, 3: false};

      setState(() {
        _quests = _buildFreshQuestsList(resetMap);
        _isWeightConfirmed = true;
        _isLoading = false;
      });
      _saveDataToStorage();
      return;
    }
    // ------------------------------------------------

    _consumedWater = prefs.getInt('user_consumed_water_key') ?? 0;
    _waterPointsAwardedToday =
        prefs.getBool('water_points_awarded_key') ?? false;

    final String? cachedData = prefs.getString('daily_quests_key');
    Map<int, bool> completionMap = {};

    if (cachedData != null) {
      final List<dynamic> decodedList = jsonDecode(cachedData);
      completionMap = {
        for (var item in decodedList)
          item['id'] as int: item['isCompleted'] ?? false
      };
    }

    setState(() {
      _quests = _buildFreshQuestsList(completionMap);
      _isWeightConfirmed = true;
      _isLoading = false;
    });
    _saveDataToStorage();
  }

  Future<void> _saveDataToStorage() async {
    final user = Provider.of<DatabaseService>(context, listen: false).user;

    // MODIFICACIÓN: Guardado general de datos tipados mediante PuntosModel en Firestore
    if (user != null) {
      final puntosObj = PuntosModel(
        uid: user.uid,
        valor: globalPointsNotifier.value,
        historicExerciseDays: _historicExerciseDays,
        historicWaterDays: _historicWaterDays,
        historicMealsCount: _historicMealsCount,
      );
      await FirebaseFirestore.instance
          .collection('puntos')
          .doc(user.uid)
          .set(puntosObj.toMap());
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('user_weight_key', _userWeight);

    final String encodedData =
        jsonEncode(_quests.map((q) => q.toJson()).toList());
    await prefs.setString('daily_quests_key', encodedData);
  }

  void _confirmAndExecuteWeightUpdate() {
    final String value = _weightController.text;
    final double? parsedWeight = double.tryParse(value);

    if (parsedWeight != null && parsedWeight > 0) {
      FocusScope.of(context).unfocus();

      final Map<int, bool> currentCompletionMap = {
        for (var q in _quests) q.id: q.isCompleted
      };

      setState(() {
        _userWeight = parsedWeight;
        _quests = _buildFreshQuestsList(currentCompletionMap);
        _isWeightConfirmed = true;
      });
      _saveDataToStorage();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡Peso registrado! Meta de hidratación actualizada.'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, ingresa un peso válido numérico.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _onWeightInputChanged(String value) {
    final double? parsed = double.tryParse(value);
    if (parsed != _userWeight && _isWeightConfirmed) {
      setState(() {
        _isWeightConfirmed = false;
      });
    }
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final now = DateTime.now();
      final midnight = DateTime(now.year, now.month, now.day + 1);
      final duration = midnight.difference(now);
      if (duration.isNegative || duration.inHours >= 24) {
        _resetDailyQuests();
      } else {
        setState(() {
          _timeRemaining = _formatDuration(duration);
        });
      }
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    return "${twoDigits(duration.inHours)}:${twoDigits(duration.inMinutes.remainder(60))}:${twoDigits(duration.inSeconds.remainder(60))}";
  }

  Future _resetDailyQuests() async {
    final prefs = await SharedPreferences.getInstance();
    final String todayDateStr = DateTime.now().toString().split(' ')[0];
    await prefs.setInt('user_consumed_water_key', 0);
    await prefs.setBool('water_points_awarded_key', false);
    await prefs.setString('last_daily_opened_date_key', todayDateStr);
    setState(() {
      _consumedWater = 0;
      _waterPointsAwardedToday = false;
      for (var quest in _quests) {
        quest.isCompleted = false;
      }
    });
    _saveDataToStorage();
  }

  @override
  Widget
  build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    int completedCount = _quests.where((q) => q.isCompleted).length;
    double progress = _quests.isEmpty ? 0 : completedCount / _quests.length;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Misiones Diarias',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            _buildTimerCard(),
            const SizedBox(height: 12),
            _buildWeightInputCard(),
            const SizedBox(height: 12),
            _buildProgressBar(completedCount, progress),
            const SizedBox(height: 24),
            const Text('Tareas de hoy',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _quests.length,
                itemBuilder: (context, index) =>
                    _buildQuestCard(_quests[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeightInputCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          children: [
            const Icon(Icons.scale, color: Colors.blueGrey),
            const SizedBox(width: 12),
            const Text('Tu Peso Actual:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const Spacer(),
            SizedBox(
              width: 90,
              height: 40,
              child: TextField(
                controller: _weightController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),
                textInputAction: TextInputAction.done,
                onChanged: (value) => _onWeightInputChanged(value),
                onSubmitted: (value) => _confirmAndExecuteWeightUpdate(),
                decoration: InputDecoration(
                  suffixText: ' kg',
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
            const SizedBox(width: 4),
            IconButton(
              icon: Icon(
                _isWeightConfirmed
                    ? Icons.check_circle
                    : Icons.arrow_circle_right,
                color: _isWeightConfirmed ? Colors.green : Colors.blue,
                size: 26,
              ),
              onPressed: _confirmAndExecuteWeightUpdate,
              tooltip:
                  _isWeightConfirmed ? 'Peso confirmado' : 'Confirmar Peso',
            ),
            IconButton(
              icon: const Icon(Icons.restart_alt,
                  color: Colors.redAccent, size: 26),
              onPressed: _resetConsumedWaterManually,
              tooltip: 'Reiniciar agua del día',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimerCard() {
    return Card(
      elevation: 0,
      color: Colors.amber.shade100,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.amber.shade300)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          children: [
            const Icon(Icons.timer_outlined, color: Colors.amber),
            const SizedBox(width: 12),
            const Text('Reinicia en:',
                style: TextStyle(
                    fontWeight: FontWeight.w500, color: Colors.black87)),
            const Spacer(),
            Text(_timeRemaining,
                style: const TextStyle(
                    fontFamily: 'Courier',
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFFB78103))),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar(int completedCount, double progress) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Progreso Diario',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text('$completedCount / ${_quests.length} completadas',
                    style: const TextStyle(color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey.shade200,
                color: Colors.green,
                minHeight: 10,
                borderRadius: BorderRadius.circular(5)),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestCard(QuestModel quest) {
    return Card(
      elevation: quest.isCompleted ? 0 : 3,
      margin: const EdgeInsets.only(bottom: 12),
      color: quest.isCompleted ? Colors.green.shade50 : Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: quest.isCompleted
              ? BorderSide(color: Colors.green.shade200, width: 1)
              : BorderSide.none),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
            backgroundColor: quest.isCompleted
                ? Colors.green
                : (quest.color as Color? ?? Colors.blue).withOpacity(0.2),
            child: Icon(
                quest.isCompleted ? Icons.check : quest.icon as IconData?,
                color:
                    quest.isCompleted ? Colors.white : quest.color as Color?)),
        title: Text(quest.title,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                decoration:
                    quest.isCompleted ? TextDecoration.lineThrough : null,
                color: quest.isCompleted ? Colors.grey : Colors.black)),
        subtitle: Text(quest.subtitle,
            style: TextStyle(
                color: quest.isCompleted ? Colors.grey : Colors.black54)),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(quest.reward,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: quest.isCompleted ? Colors.grey : Colors.green)),
            const SizedBox(height: 4),
            SizedBox(
              height: 24,
              width: 24,
              child: Checkbox(
                value: quest.isCompleted,
                activeColor: Colors.green,
                onChanged: (quest.id == 3 || quest.isCompleted)
                    ? null
                    : (bool? value) async {
                        setState(() {
                          quest.isCompleted = value ?? false;
                        });
                        if (quest.isCompleted) {
                          globalPointsNotifier.value +=
                              20; // MODIFICACIÓN: Incrementar el contador histórico de ejercicio en la variable local antes de salvar en Firestore
                          if (quest.id == 1) {
                            _historicExerciseDays += 1;
                          }
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      '¡Misión completada! Ganaste +20 Pts'),
                                  backgroundColor: Colors.green,
                                  duration: Duration(seconds: 1)),
                            );
                          }
                        } else {
                          setState(() {
                            globalPointsNotifier.value -= 20;
                            if (globalPointsNotifier.value < 0) {
                              globalPointsNotifier.value = 0;
                            } // Si se desmarca, descontamos de forma matemática del contador local
                            if (quest.id == 1 && _historicExerciseDays > 0) {
                              _historicExerciseDays -= 1;
                            }
                          });
                        }
                        _saveDataToStorage();
                      },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future _resetConsumedWaterManually() async {
    if (_waterPointsAwardedToday) {
      if (globalPointsNotifier.value >= 20) {
        globalPointsNotifier.value -= 20;
      } else {
        globalPointsNotifier.value = 0;
      } // Si reinicia manualmente el agua habiendo ganado el logro hoy, descontamos el día del contador histórico
      if (_historicWaterDays > 0) {
        _historicWaterDays -= 1;
      }
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('user_consumed_water_key', 0);
    await prefs.setBool('water_points_awarded_key', false);
    final Map<int, bool> currentCompletionMap = {
      for (var q in _quests) q.id: q.isCompleted
    };
    currentCompletionMap[3] = false;
    setState(() {
      _consumedWater = 0;
      _waterPointsAwardedToday = false;
      _quests = _buildFreshQuestsList(currentCompletionMap);
    });
    _saveDataToStorage();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('💧 Contador de agua reiniciado con éxito.'),
          backgroundColor: Colors.blueGrey,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}
