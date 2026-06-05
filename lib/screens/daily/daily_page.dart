import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nutrialg_life/points_manager.dart';
import 'package:nutrialg_life/models/quest.dart'; // Importa el notificador global

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

  @override
  void initState() {
    super.initState();
    _loadDataFromStorage();
    _startCountdown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _loadDataFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final int savedPoints = prefs.getInt('user_accumulated_points_key') ?? 0;

    // CORRECCIÓN CLAVE: Sincronizamos el Notificador Global con el disco duro
    globalPointsNotifier.value = savedPoints;

    final String? cachedData = prefs.getString('daily_quests_key');
    final Map<int, Map<String, dynamic>> visualResources = {
      1: {'icon': Icons.directions_run, 'color': Colors.orange},
      2: {'icon': Icons.menu_book, 'color': Colors.purple},
      3: {'icon': Icons.water_drop, 'color': Colors.blue},
    };

    // Misiones con textos corregidos e inteligentes del código
    final List<QuestModel> hardcodedQuests = [
      QuestModel(
          id: 1,
          title: 'Ejercicio diario',
          subtitle: 'Realiza actividad fisica hoy',
          reward: '+20 Pts',
          icon: visualResources[1]?['icon'],
          color: visualResources[1]?['color']),
      QuestModel(
          id: 2,
          title: 'Hábito de nutricion',
          subtitle: 'Alimentate durante las horas recomendadas',
          reward: '+20 Pts',
          icon: visualResources[2]?['icon'],
          color: visualResources[2]?['color']),
      QuestModel(
          id: 3,
          title: 'Hidratación óptima',
          subtitle: 'Bebe agua para mantenerte hidratado',
          reward: '+20 Pts',
          icon: visualResources[3]?['icon'],
          color: visualResources[3]?['color']),
    ];

    if (cachedData != null) {
      final List<dynamic> decodedList = jsonDecode(cachedData);
      final Map<int, bool> completionMap = {
        for (var item in decodedList)
          item['id'] as int: item['isCompleted'] ?? false
      };

      for (var quest in hardcodedQuests) {
        if (completionMap.containsKey(quest.id)) {
          quest.isCompleted = completionMap[quest.id]!;
        }
      }

      setState(() {
        _quests = hardcodedQuests;
        _isLoading = false;
      });
      _saveDataToStorage();
    } else {
      setState(() {
        _quests = hardcodedQuests;
        _isLoading = false;
      });
      _saveDataToStorage();
    }
  }

  Future<void> _saveDataToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    // Guardamos el valor actual de los puntos del Notificador Global
    await prefs.setInt(
        'user_accumulated_points_key', globalPointsNotifier.value);
    final String encodedData =
        jsonEncode(_quests.map((q) => q.toJson()).toList());
    await prefs.setString('daily_quests_key', encodedData);
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final now = DateTime.now();
      final midnight = DateTime(now.year, now.month, now.day + 1);
      final duration = midnight.difference(now);

      if (duration.isNegative) {
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

  void _resetDailyQuests() {
    setState(() {
      for (var quest in _quests) {
        quest.isCompleted = false;
      }
    });
    _saveDataToStorage();
  }

  @override
  Widget build(BuildContext context) {
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
          children: [ // Integración reactiva en el balance superior
            const SizedBox(height: 12),
            _buildTimerCard(),
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
            backgroundColor:
                quest.isCompleted ? Colors.green : quest.color.withOpacity(0.2),
            child: Icon(quest.isCompleted ? Icons.check : quest.icon,
                color: quest.isCompleted ? Colors.white : quest.color)),
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
                onChanged: (bool? value) {
                  setState(() {
                    quest.isCompleted = value ?? false;
                    if (quest.isCompleted) {
                      globalPointsNotifier.value += 20;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                                Text('¡Misión completada! Ganaste +20 Pts'),
                            backgroundColor: Colors.green,
                            duration: Duration(seconds: 1)),
                      );
                    } else {
                      globalPointsNotifier.value -= 20;
                      if (globalPointsNotifier.value < 0)
                        globalPointsNotifier.value = 0;
                    }
                  });
                  _saveDataToStorage();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
