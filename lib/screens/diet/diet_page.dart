import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:nutrialg_life/services/database_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nutrialg_life/points_manager.dart';

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

  @override
  void initState() {
    super.initState();
    _loadLocalMealsState();
  }

  Future<void> _loadLocalMealsState() async {
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
    final prefs = await SharedPreferences.getInstance();
    final String encoded = jsonEncode(_mealsCompletionMap);
    await prefs.setString('diet_meals_completion_key', encoded);
    await prefs.setInt(
        'user_accumulated_points_key', globalPointsNotifier.value);
  }

  void _completeMealLocal(String mealLabel) {
    if (_mealsCompletionMap[mealLabel] == true) return;

    setState(() {
      _mealsCompletionMap[mealLabel] = true;
      globalPointsNotifier.value += 20;
    });

    _saveLocalMealsState();

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('¡$mealLabel completado! Ganaste +20 Pts 🍽️'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }


  // Mapeador opcional si prefieres conservar tus funciones individuales en lugar de cambiar tu DatabaseService
  Future<dynamic> _fetchDietaDinamica(String uid, int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return firestore.getLunes(uid);
      case DateTime.tuesday:
        return firestore.getMartes(uid); // Asegúrate de tener estos métodos
      case DateTime.wednesday:
        return firestore.getMiercoles(uid);
      case DateTime.thursday:
        return firestore.getJueves(uid);
      case DateTime.friday:
        return firestore.getViernes(uid);
      case DateTime.saturday:
        return firestore.getSabado(uid);
      case DateTime.sunday:
        return firestore.getDomingo(uid);
      default:
        return firestore.getLunes(uid);
    }
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
          // Opción dinámica usando el mapeador de tus métodos existentes
          future: _fetchDietaDinamica(user!.uid, dayNumber),

          // O si actualizaste tu DatabaseService con el parámetro string (RECOMENDADO):
          // future: firestore.getDietaPorDia(user!.uid, _getDiaQueryParam(dayNumber)),

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
                    if (snapshot.data?.desayuno != null &&
                        snapshot.data.desayuno.isNotEmpty)
                      MealCard(
                          label: 'Desayuno',
                          time: snapshot.data.desayuno[0],
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
                          })),

                    // === MEDIA ===
                    if (snapshot.data?.media != null &&
                        snapshot.data.media.isNotEmpty)
                      MealCard(
                          label: 'Media',
                          time: snapshot.data.media[0],
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
                          })),

                    // === ALMUERZO ===
                    if (snapshot.data?.almuerzo != null &&
                        snapshot.data.almuerzo.isNotEmpty)
                      MealCard(
                          label: 'Almuerzo',
                          time: snapshot.data.almuerzo[0],
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
                          })),

                    // === MERIENDA ===
                    if (snapshot.data?.merienda != null &&
                        snapshot.data.merienda.isNotEmpty)
                      MealCard(
                          label: 'Merienda',
                          time: snapshot.data.merienda[0],
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
                          })),

                    // === CENA ===
                    if (snapshot.data?.cena != null &&
                        snapshot.data.cena.isNotEmpty)
                      MealCard(
                          label: 'Cena',
                          time: snapshot.data.cena[0],
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