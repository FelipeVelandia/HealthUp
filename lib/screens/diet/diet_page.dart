import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:nutrialg_life/services/database_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nutrialg_life/points_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nutrialg_life/models/puntos.dart';
import 'package:nutrialg_life/services/food_firestore_service.dart';

import 'widgets/meal_card.dart';

class DietPage extends StatefulWidget {
  const DietPage({super.key});

  @override
  State<DietPage> createState() => _DietPageState();
}

class _DietPageState extends State<DietPage> {
  final String title = "Menú para hoy";
  final firestore = DatabaseService();

  Map<String, bool> _mealsCompletionMap = {
    'Desayuno': false,
    'Media': false,
    'Almuerzo': false,
    'Merienda': false,
    'Cena': false,
  };

  bool _isLocalLoading = true;
  dynamic _dietaDataCache;

  int _historicExerciseDays = 0;
  int _historicWaterDays = 0;
  int _historicMealsCount = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadLocalMealsState();
    });
  }

  Future<void> _loadLocalMealsState() async {
    final user = Provider.of<DatabaseService>(context, listen: false).user;

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
    final String todayDateStr = DateTime.now().toString().split(' ')[0];
    final String lastOpenedDate =
        prefs.getString('last_diet_opened_date_key') ?? "";

    if (todayDateStr != lastOpenedDate) {
      await prefs.remove('diet_meals_completion_key');
      await prefs.setString('last_diet_opened_date_key', todayDateStr);

      setState(() {
        _mealsCompletionMap = {
          'Desayuno': false,
          'Media': false,
          'Almuerzo': false,
          'Merienda': false,
          'Cena': false,
        };
        _isLocalLoading = false;
      });
      return;
    }

    final String? cachedMeals = prefs.getString('diet_meals_completion_key');
    if (cachedMeals != null) {
      final Map<String, dynamic> decoded = jsonDecode(cachedMeals);
      setState(() {
        _mealsCompletionMap =
            decoded.map((key, value) => MapEntry(key, value as bool));
        _isLocalLoading = false;
      });
    } else {
      setState(() {
        _isLocalLoading = false;
      });
    }
  }

  Future<void> _saveLocalMealsState() async {
    final user = Provider.of<DatabaseService>(context, listen: false).user;

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
    final String encoded = jsonEncode(_mealsCompletionMap);
    await prefs.setString('diet_meals_completion_key', encoded);
  }

  // CORRECCIÓN DEFINITIVA: Extrae únicamente el String de la posición 0 sin convertir la lista entera
  String _obtenerHoraSegura(dynamic mealList, String horaPorDefecto) {
    try {
      if (mealList == null || mealList is! List || mealList.isEmpty)
        return horaPorDefecto;

      // Accedemos estrictamente al primer elemento de la lista que contiene la hora
      final primerElemento = mealList[0];

      if (primerElemento == null) return horaPorDefecto;
      if (primerElemento is String) return primerElemento;

      if (primerElemento is Map) {
        return (primerElemento['hora'] ??
                primerElemento['time'] ??
                horaPorDefecto)
            .toString();
      }

      return horaPorDefecto;
    } catch (e) {
      return horaPorDefecto;
    }
  }

  void _completeMealLocal(String mealLabel) async {
    if (_mealsCompletionMap[mealLabel] == true) return;

    if (_dietaDataCache == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              '⚠️ Espera a que termine de cargar el plan de alimentación antes de completarlo.'),
          backgroundColor: Colors.amber,
        ),
      );
      return;
    }

    final user = Provider.of<DatabaseService>(context, listen: false).user;
    if (user == null) return;

    List<dynamic>? rawItemsList;
    String horaComida = TimeOfDay.now().format(context);

    try {
      if (mealLabel == 'Desayuno') rawItemsList = _dietaDataCache.desayuno;
      if (mealLabel == 'Media') rawItemsList = _dietaDataCache.media;
      if (mealLabel == 'Almuerzo') rawItemsList = _dietaDataCache.almuerzo;
      if (mealLabel == 'Merienda') rawItemsList = _dietaDataCache.merienda;
      if (mealLabel == 'Cena') rawItemsList = _dietaDataCache.cena;
    } catch (e) {
      rawItemsList = null;
    }

    if (rawItemsList == null || rawItemsList.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              '⚠️ No hay alimentos cargados en esta categoría para guardar.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    Map<String, List<Map<String, dynamic>>> registryToUpload = {
      'Desayuno': [],
      'Almuerzo': [],
      'Cena': [],
      'Merienda': [],
      'Media': [],
      'Agua': []
    };

    horaComida =
        _obtenerHoraSegura(rawItemsList, TimeOfDay.now().format(context));

    for (int i = 1; i < rawItemsList.length; i++) {
      final item = rawItemsList[i];
      if (item != null) {
        registryToUpload[mealLabel]!.add({
          'name': item['titulo'] ?? 'Alimento de Dieta',
          'quantity': item['cantidad']?.toString() ?? '1',
          'unit': item['unidad']?.toString() ?? 'Porción',
          'time': horaComida,
          'calories':
              double.tryParse(item['calories']?.toString() ?? '0') ?? 0.0,
          'protein': double.tryParse(item['protein']?.toString() ?? '0') ?? 0.0,
          'lipids': double.tryParse(item['lipids']?.toString() ?? '0') ?? 0.0,
          'carbs': double.tryParse(item['carbs']?.toString() ?? '0') ?? 0.0,
          'fiber': double.tryParse(item['fiber']?.toString() ?? '0') ?? 0.0,
        });
      }
    }

    try {
      await FoodFirestoreService.uploadRegistry(
        foodRegistry: registryToUpload,
        waterAmount: 0,
        userId: user.uid,
      );

      _historicMealsCount += 1;

      setState(() {
        _mealsCompletionMap[mealLabel] = true;
        globalPointsNotifier.value += 20;
      });

      await _saveLocalMealsState();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                '¡$mealLabel completado y sincronizado en la nube! +20 Pts 🍽️☁️'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al guardar la comida en la nube: $e ❌'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<dynamic> _fetchDietaDinamica(String uid, int weekday) async {
    dynamic result;
    switch (weekday) {
      case DateTime.monday:
        result = await firestore.getLunes(uid);
        break;
      case DateTime.tuesday:
        result = await firestore.getMartes(uid);
        break;
      case DateTime.wednesday:
        result = await firestore.getMiercoles(uid);
        break;
      case DateTime.thursday:
        result = await firestore.getJueves(uid);
        break;
      case DateTime.friday:
        result = await firestore.getViernes(uid);
        break;
      case DateTime.saturday:
        result = await firestore.getSabado(uid);
        break;
      case DateTime.sunday:
        result = await firestore.getDomingo(uid);
        break;
      default:
        result = await firestore.getLunes(uid);
        break;
    }
    _dietaDataCache = result;
    return result;
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<DatabaseService>(context).user;
    DateTime now = DateTime.now();
    int dayNumber = now.weekday;

    if (_isLocalLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: FutureBuilder(
          future: _fetchDietaDinamica(user!.uid, dayNumber),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.data == null) {
                return Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child:
                      const Center(child: Text("Sin datos de dieta para hoy")),
                );
              } else {
                return ListView(
                  children: [
                    // === DESAYUNO ===
                    if (snapshot.data != null &&
                        snapshot.data.desayuno != null &&
                        snapshot.data.desayuno.isNotEmpty)
                      MealCard(
                          label: 'Desayuno',
                          time: _obtenerHoraSegura(
                              snapshot.data.desayuno, "08:00"),
                          state: _mealsCompletionMap['Desayuno'] == true
                              ? 'completado'
                              : 'pendiente',
                          onTap: () => _completeMealLocal('Desayuno'),
                          items: List.generate(
                              snapshot.data.desayuno.length - 1, (i) {
                            final index = i + 1;
                            return MealItem(
                                mealType:
                                    index == 1 ? Meal.bebida : Meal.comida,
                                mealTime: 'desayuno',
                                label: snapshot.data.desayuno[index]['titulo'],
                                index: index);
                          })), // === MEDIA ===
                    if (snapshot.data != null &&
                        snapshot.data.media != null &&
                        snapshot.data.media.isNotEmpty)
                      MealCard(
                          label: 'Media',
                          time:
                              _obtenerHoraSegura(snapshot.data.media, "11:00"),
                          state: _mealsCompletionMap['Media'] == true
                              ? 'completado'
                              : 'pendiente',
                          onTap: () => _completeMealLocal('Media'),
                          items: List.generate(snapshot.data.media.length - 1,
                              (i) {
                            final index = i + 1;
                            return MealItem(
                                mealType: Meal.comida,
                                mealTime: 'media',
                                label: snapshot.data.media[index]['titulo'],
                                index: index);
                          })), // === ALMUERZO ===
                    if (snapshot.data != null &&
                        snapshot.data.almuerzo != null &&
                        snapshot.data.almuerzo.isNotEmpty)
                      MealCard(
                          label: 'Almuerzo',
                          time: _obtenerHoraSegura(
                              snapshot.data.almuerzo, "14:00"),
                          state: _mealsCompletionMap['Almuerzo'] == true
                              ? 'completado'
                              : 'pendiente',
                          onTap: () => _completeMealLocal('Almuerzo'),
                          items: List.generate(
                              snapshot.data.almuerzo.length - 1, (i) {
                            final index = i + 1;
                            return MealItem(
                                mealType:
                                    index == 1 ? Meal.comida : Meal.bebida,
                                mealTime: 'almuerzo',
                                label: snapshot.data.almuerzo[index]['titulo'],
                                index: index);
                          })), // === MERIENDA ===
                    if (snapshot.data != null &&
                        snapshot.data.merienda != null &&
                        snapshot.data.merienda.isNotEmpty)
                      MealCard(
                          label: 'Merienda',
                          time: _obtenerHoraSegura(
                              snapshot.data.merienda, "17:00"),
                          state: _mealsCompletionMap['Merienda'] == true
                              ? 'completado'
                              : 'pendiente',
                          onTap: () => _completeMealLocal('Merienda'),
                          items: List.generate(
                              snapshot.data.merienda.length - 1, (i) {
                            final index = i + 1;
                            return MealItem(
                                mealType: Meal.fruta,
                                mealTime: 'merienda',
                                label: snapshot.data.merienda[index]['titulo'],
                                index: index);
                          })), // === CENA ===
                    if (snapshot.data != null &&
                        snapshot.data.cena != null &&
                        snapshot.data.cena.isNotEmpty)
                      MealCard(
                          label: 'Cena',
                          time: _obtenerHoraSegura(snapshot.data.cena, "21:00"),
                          state: _mealsCompletionMap['Cena'] == true
                              ? 'completado'
                              : 'pendiente',
                          onTap: () => _completeMealLocal('Cena'),
                          items:
                              List.generate(snapshot.data.cena.length - 1, (i) {
                            final index = i + 1;
                            return MealItem(
                                mealType:
                                    index == 1 ? Meal.comida : Meal.bebida,
                                mealTime: 'cena',
                                label: snapshot.data.cena[index]['titulo'],
                                index: index);
                          }))
                  ],
                );
              }
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return const Center(
                  child: Text('Error al cargar la dieta del día'));
            }
          }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFE57373),
        foregroundColor: Colors.white,
        onPressed: () {
          context.push("/food-registration");
        },
        child: const Icon(FontAwesomeIcons.utensils, size: 20),
      ),
    );
  }
}
