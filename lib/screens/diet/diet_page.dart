import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:nutrialg_life/services/database_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nutrialg_life/points_manager.dart'; // Importación de tu notificador global

import 'widgets/meal_card.dart';

class DietPage extends StatefulWidget {
  const DietPage({super.key});

  @override
  State<DietPage> createState() => _DietPageState();
}

class _DietPageState extends State<DietPage> {
  final String title = "Menú para hoy";
  final firestore = DatabaseService();

  // Mapa local persistente para controlar el bloqueo estricto en la UI
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

  // Modifica tu función de carga de estado en diet_page.dart para validar la fecha
  Future<void> _loadLocalMealsState() async {
    final prefs = await SharedPreferences.getInstance();

    // 1. Obtenemos la fecha de hoy en formato String (ej: "2026-06-10")
    final String todayDateStr = DateTime.now().toString().split(' ')[0];

    // 2. Leemos cuál fue el último día en que el usuario abrió la dieta
    final String lastOpenedDate =
        prefs.getString('last_diet_opened_date_key') ?? "";

    // 3. SI ES UN DÍA NUEVO: Limpiamos los checks locales del disco duro automáticamente
    if (todayDateStr != lastOpenedDate) {
      await prefs
          .remove('diet_meals_completion_key'); // Borra las comidas viejas
      await prefs.setString(
          'last_diet_opened_date_key', todayDateStr); // Actualiza al día de hoy

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

    // Si es el mismo día, cargamos el progreso normal de la sesión actual
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

  // Guarda el estado de completado local en SharedPreferences
  Future<void> _saveLocalMealsState() async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = jsonEncode(_mealsCompletionMap);
    await prefs.setString('diet_meals_completion_key', encoded);
    // Sincronizamos también el pool de puntos acumulados en disco
    await prefs.setInt(
        'user_accumulated_points_key', globalPointsNotifier.value);
  }

  // Lógica de guardado y asignación de puntos local
  void _completeMealLocal(String mealLabel) {
    if (_mealsCompletionMap[mealLabel] == true) return;

    setState(() {
      _mealsCompletionMap[mealLabel] = true;
      globalPointsNotifier.value +=
          20; // Otorga los 20 puntos al progreso global
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

    if (dayNumber == DateTime.monday) {
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: FutureBuilder(
            future: firestore.getLunes(user!.uid),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.data == null) {
                  return Container(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    child: const Center(child: Text("Sin datos de dieta")),
                  );
                } else {
                  return ListView(
                    children: [
                      if (snapshot.data?.desayuno != null &&
                          snapshot.data.desayuno.isNotEmpty)
                        MealCard(
                            label: 'Desayuno',
                            time: snapshot.data.desayuno[0],
                            state: _mealsCompletionMap['Desayuno'] == true
                                ? 'completado'
                                : 'pendiente',
                            onTap: () => _completeMealLocal('Desayuno'),
                            items: [
                              MealItem(
                                  mealType: Meal.bebida,
                                  mealTime: 'desayuno',
                                  label: snapshot.data.desayuno[1][
                                      'titulo'], // CORREGIDO: Retorna el acceso por índice entero
                                  index: 1),
                              MealItem(
                                  mealType: Meal.comida,
                                  mealTime: 'desayuno',
                                  label: snapshot.data.desayuno[2]
                                      ['titulo'], // CORREGIDO
                                  index: 2),
                            ]),
                      if (snapshot.data?.media != null &&
                          snapshot.data.media.isNotEmpty)
                        MealCard(
                            label: 'Media',
                            time: snapshot.data.media[0],
                            state: _mealsCompletionMap['Media'] == true
                                ? 'completado'
                                : 'pendiente',
                            onTap: () => _completeMealLocal('Media'),
                            items: [
                              MealItem(
                                  mealType: Meal.comida,
                                  mealTime: 'media',
                                  label: snapshot.data.media[1]
                                      ['titulo'], // CORREGIDO
                                  index: 1)
                            ]),
                      if (snapshot.data?.almuerzo != null &&
                          snapshot.data.almuerzo.isNotEmpty)
                        MealCard(
                            label: 'Almuerzo',
                            time: snapshot.data.almuerzo[0],
                            state: _mealsCompletionMap['Almuerzo'] == true
                                ? 'completado'
                                : 'pendiente',
                            onTap: () => _completeMealLocal('Almuerzo'),
                            items: [
                              MealItem(
                                  mealType: Meal.comida,
                                  mealTime: 'almuerzo',
                                  label: snapshot.data.almuerzo[1]
                                      ['titulo'], // CORREGIDO
                                  index: 1),
                              MealItem(
                                  mealType: Meal.bebida,
                                  mealTime: 'almuerzo',
                                  label: snapshot.data.almuerzo[2]
                                      ['titulo'], // CORREGIDO
                                  index: 2)
                            ]),
                      if (snapshot.data?.merienda != null &&
                          snapshot.data.merienda.isNotEmpty)
                        MealCard(
                            label: 'Merienda',
                            time: snapshot.data.merienda[0],
                            state: _mealsCompletionMap['Merienda'] == true
                                ? 'completado'
                                : 'pendiente',
                            onTap: () => _completeMealLocal('Merienda'),
                            items: [
                              MealItem(
                                  mealType: Meal.fruta,
                                  mealTime: 'merienda',
                                  label: snapshot.data.merienda[1]
                                      ['titulo'], // CORREGIDO
                                  index: 1)
                            ]),
                      if (snapshot.data?.cena != null &&
                          snapshot.data.cena.isNotEmpty)
                        MealCard(
                            label: 'Cena',
                            time: snapshot.data.cena[0],
                            state: _mealsCompletionMap['Cena'] == true
                                ? 'completado'
                                : 'pendiente',
                            onTap: () => _completeMealLocal('Cena'),
                            items: [
                              MealItem(
                                  mealType: Meal.comida,
                                  mealTime: 'cena',
                                  label: snapshot.data.cena[1]
                                      ['titulo'], // CORREGIDO
                                  index: 1),
                              MealItem(
                                  mealType: Meal.bebida,
                                  mealTime: 'cena',
                                  label: snapshot.data.cena[2]
                                      ['titulo'], // CORREGIDO
                                  index: 2)
                            ])
                    ],
                  );
                }
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return const Center(child: Text('Error'));
              }
            }),
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xFF32A287),
          foregroundColor: Colors.white,
          onPressed: () {
            context.push("/food-registration");
          },
          child: const Icon(FontAwesomeIcons.utensils, size: 20),
        ),
      );
    } else if (dayNumber == DateTime.tuesday) {
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: FutureBuilder(
            future: firestore.getMartes(user!.uid),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.data == null) {
                  return Container(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    child: const Center(child: Text("Sin datos de dieta")),
                  );
                } else {
                  return ListView(
                    children: [
                      if (snapshot.data?.desayuno != null &&
                          snapshot.data.desayuno.isNotEmpty)
                        MealCard(
                            label: 'Desayuno',
                            time: snapshot.data.desayuno[0],
                            state: _mealsCompletionMap['Desayuno'] == true
                                ? 'completado'
                                : 'pendiente',
                            onTap: () => _completeMealLocal('Desayuno'),
                            items: [
                              MealItem(
                                  mealType: Meal.bebida,
                                  mealTime: 'desayuno',
                                  label: snapshot.data.desayuno[1][
                                      'titulo'], // CORREGIDO: Retorna el acceso por índice entero
                                  index: 1),
                              MealItem(
                                  mealType: Meal.comida,
                                  mealTime: 'desayuno',
                                  label: snapshot.data.desayuno[2]
                                      ['titulo'], // CORREGIDO
                                  index: 2),
                            ]),
                      if (snapshot.data?.media != null &&
                          snapshot.data.media.isNotEmpty)
                        MealCard(
                            label: 'Media',
                            time: snapshot.data.media[0],
                            state: _mealsCompletionMap['Media'] == true
                                ? 'completado'
                                : 'pendiente',
                            onTap: () => _completeMealLocal('Media'),
                            items: [
                              MealItem(
                                  mealType: Meal.comida,
                                  mealTime: 'media',
                                  label: snapshot.data.media[1]
                                      ['titulo'], // CORREGIDO
                                  index: 1)
                            ]),
                      if (snapshot.data?.almuerzo != null &&
                          snapshot.data.almuerzo.isNotEmpty)
                        MealCard(
                            label: 'Almuerzo',
                            time: snapshot.data.almuerzo[0],
                            state: _mealsCompletionMap['Almuerzo'] == true
                                ? 'completado'
                                : 'pendiente',
                            onTap: () => _completeMealLocal('Almuerzo'),
                            items: [
                              MealItem(
                                  mealType: Meal.comida,
                                  mealTime: 'almuerzo',
                                  label: snapshot.data.almuerzo[1]
                                      ['titulo'], // CORREGIDO
                                  index: 1),
                              MealItem(
                                  mealType: Meal.bebida,
                                  mealTime: 'almuerzo',
                                  label: snapshot.data.almuerzo[2]
                                      ['titulo'], // CORREGIDO
                                  index: 2)
                            ]),
                      if (snapshot.data?.merienda != null &&
                          snapshot.data.merienda.isNotEmpty)
                        MealCard(
                            label: 'Merienda',
                            time: snapshot.data.merienda[0],
                            state: _mealsCompletionMap['Merienda'] == true
                                ? 'completado'
                                : 'pendiente',
                            onTap: () => _completeMealLocal('Merienda'),
                            items: [
                              MealItem(
                                  mealType: Meal.fruta,
                                  mealTime: 'merienda',
                                  label: snapshot.data.merienda[1]
                                      ['titulo'], // CORREGIDO
                                  index: 1)
                            ]),
                      if (snapshot.data?.cena != null &&
                          snapshot.data.cena.isNotEmpty)
                        MealCard(
                            label: 'Cena',
                            time: snapshot.data.cena[0],
                            state: _mealsCompletionMap['Cena'] == true
                                ? 'completado'
                                : 'pendiente',
                            onTap: () => _completeMealLocal('Cena'),
                            items: [
                              MealItem(
                                  mealType: Meal.comida,
                                  mealTime: 'cena',
                                  label: snapshot.data.cena[1]
                                      ['titulo'], // CORREGIDO
                                  index: 1),
                              MealItem(
                                  mealType: Meal.bebida,
                                  mealTime: 'cena',
                                  label: snapshot.data.cena[2]
                                      ['titulo'], // CORREGIDO
                                  index: 2)
                            ])
                    ],
                  );
                }
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return const Center(child: Text('Error'));
              }
            }),
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xFF32A287),
          foregroundColor: Colors.white,
          onPressed: () {
            context.push("/food-registration");
          },
          child: const Icon(FontAwesomeIcons.utensils, size: 20),
        ),
      );
    } else if (dayNumber == DateTime.wednesday) {
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: FutureBuilder(
            future: firestore.getMiercoles(user!.uid),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.data == null) {
                  return Container(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    child: const Center(child: Text("Sin datos de dieta")),
                  );
                } else {
                  return ListView(
                    children: [
                      if (snapshot.data?.desayuno != null &&
                          snapshot.data.desayuno.isNotEmpty)
                        MealCard(
                            label: 'Desayuno',
                            time: snapshot.data.desayuno[0],
                            state: _mealsCompletionMap['Desayuno'] == true
                                ? 'completado'
                                : 'pendiente',
                            onTap: () => _completeMealLocal('Desayuno'),
                            items: [
                              MealItem(
                                  mealType: Meal.bebida,
                                  mealTime: 'desayuno',
                                  label: snapshot.data.desayuno[1][
                                      'titulo'], // CORREGIDO: Retorna el acceso por índice entero
                                  index: 1),
                              MealItem(
                                  mealType: Meal.comida,
                                  mealTime: 'desayuno',
                                  label: snapshot.data.desayuno[2]
                                      ['titulo'], // CORREGIDO
                                  index: 2),
                            ]),
                      if (snapshot.data?.media != null &&
                          snapshot.data.media.isNotEmpty)
                        MealCard(
                            label: 'Media',
                            time: snapshot.data.media[0],
                            state: _mealsCompletionMap['Media'] == true
                                ? 'completado'
                                : 'pendiente',
                            onTap: () => _completeMealLocal('Media'),
                            items: [
                              MealItem(
                                  mealType: Meal.comida,
                                  mealTime: 'media',
                                  label: snapshot.data.media[1]
                                      ['titulo'], // CORREGIDO
                                  index: 1)
                            ]),
                      if (snapshot.data?.almuerzo != null &&
                          snapshot.data.almuerzo.isNotEmpty)
                        MealCard(
                            label: 'Almuerzo',
                            time: snapshot.data.almuerzo[0],
                            state: _mealsCompletionMap['Almuerzo'] == true
                                ? 'completado'
                                : 'pendiente',
                            onTap: () => _completeMealLocal('Almuerzo'),
                            items: [
                              MealItem(
                                  mealType: Meal.comida,
                                  mealTime: 'almuerzo',
                                  label: snapshot.data.almuerzo[1]
                                      ['titulo'], // CORREGIDO
                                  index: 1),
                              MealItem(
                                  mealType: Meal.bebida,
                                  mealTime: 'almuerzo',
                                  label: snapshot.data.almuerzo[2]
                                      ['titulo'], // CORREGIDO
                                  index: 2)
                            ]),
                      if (snapshot.data?.merienda != null &&
                          snapshot.data.merienda.isNotEmpty)
                        MealCard(
                            label: 'Merienda',
                            time: snapshot.data.merienda[0],
                            state: _mealsCompletionMap['Merienda'] == true
                                ? 'completado'
                                : 'pendiente',
                            onTap: () => _completeMealLocal('Merienda'),
                            items: [
                              MealItem(
                                  mealType: Meal.fruta,
                                  mealTime: 'merienda',
                                  label: snapshot.data.merienda[1]
                                      ['titulo'], // CORREGIDO
                                  index: 1)
                            ]),
                      if (snapshot.data?.cena != null &&
                          snapshot.data.cena.isNotEmpty)
                        MealCard(
                            label: 'Cena',
                            time: snapshot.data.cena[0],
                            state: _mealsCompletionMap['Cena'] == true
                                ? 'completado'
                                : 'pendiente',
                            onTap: () => _completeMealLocal('Cena'),
                            items: [
                              MealItem(
                                  mealType: Meal.comida,
                                  mealTime: 'cena',
                                  label: snapshot.data.cena[1]
                                      ['titulo'], // CORREGIDO
                                  index: 1),
                              MealItem(
                                  mealType: Meal.bebida,
                                  mealTime: 'cena',
                                  label: snapshot.data.cena[2]
                                      ['titulo'], // CORREGIDO
                                  index: 2)
                            ])
                    ],
                  );
                }
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return const Center(child: Text('Error'));
              }
            }),
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xFF32A287),
          foregroundColor: Colors.white,
          onPressed: () {
            context.push("/food-registration");
          },
          child: const Icon(FontAwesomeIcons.utensils, size: 20),
        ),
      );
    } else if (dayNumber == DateTime.thursday) {
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: FutureBuilder(
            future: firestore.getJueves(user!.uid),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.data == null) {
                  return Container(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    child: const Center(child: Text("Sin datos de dieta")),
                  );
                } else {
                  return ListView(
                    children: [
                      if (snapshot.data?.desayuno != null &&
                          snapshot.data.desayuno.isNotEmpty)
                        MealCard(
                            label: 'Desayuno',
                            time: snapshot.data.desayuno[0],
                            state: _mealsCompletionMap['Desayuno'] == true
                                ? 'completado'
                                : 'pendiente',
                            onTap: () => _completeMealLocal('Desayuno'),
                            items: [
                              MealItem(
                                  mealType: Meal.bebida,
                                  mealTime: 'desayuno',
                                  label: snapshot.data.desayuno[1][
                                      'titulo'], // CORREGIDO: Retorna el acceso por índice entero
                                  index: 1),
                              MealItem(
                                  mealType: Meal.comida,
                                  mealTime: 'desayuno',
                                  label: snapshot.data.desayuno[2]
                                      ['titulo'], // CORREGIDO
                                  index: 2),
                            ]),
                      if (snapshot.data?.media != null &&
                          snapshot.data.media.isNotEmpty)
                        MealCard(
                            label: 'Media',
                            time: snapshot.data.media[0],
                            state: _mealsCompletionMap['Media'] == true
                                ? 'completado'
                                : 'pendiente',
                            onTap: () => _completeMealLocal('Media'),
                            items: [
                              MealItem(
                                  mealType: Meal.comida,
                                  mealTime: 'media',
                                  label: snapshot.data.media[1]
                                      ['titulo'], // CORREGIDO
                                  index: 1)
                            ]),
                      if (snapshot.data?.almuerzo != null &&
                          snapshot.data.almuerzo.isNotEmpty)
                        MealCard(
                            label: 'Almuerzo',
                            time: snapshot.data.almuerzo[0],
                            state: _mealsCompletionMap['Almuerzo'] == true
                                ? 'completado'
                                : 'pendiente',
                            onTap: () => _completeMealLocal('Almuerzo'),
                            items: [
                              MealItem(
                                  mealType: Meal.comida,
                                  mealTime: 'almuerzo',
                                  label: snapshot.data.almuerzo[1]
                                      ['titulo'], // CORREGIDO
                                  index: 1),
                              MealItem(
                                  mealType: Meal.bebida,
                                  mealTime: 'almuerzo',
                                  label: snapshot.data.almuerzo[2]
                                      ['titulo'], // CORREGIDO
                                  index: 2)
                            ]),
                      if (snapshot.data?.merienda != null &&
                          snapshot.data.merienda.isNotEmpty)
                        MealCard(
                            label: 'Merienda',
                            time: snapshot.data.merienda[0],
                            state: _mealsCompletionMap['Merienda'] == true
                                ? 'completado'
                                : 'pendiente',
                            onTap: () => _completeMealLocal('Merienda'),
                            items: [
                              MealItem(
                                  mealType: Meal.fruta,
                                  mealTime: 'merienda',
                                  label: snapshot.data.merienda[1]
                                      ['titulo'], // CORREGIDO
                                  index: 1)
                            ]),
                      if (snapshot.data?.cena != null &&
                          snapshot.data.cena.isNotEmpty)
                        MealCard(
                            label: 'Cena',
                            time: snapshot.data.cena[0],
                            state: _mealsCompletionMap['Cena'] == true
                                ? 'completado'
                                : 'pendiente',
                            onTap: () => _completeMealLocal('Cena'),
                            items: [
                              MealItem(
                                  mealType: Meal.comida,
                                  mealTime: 'cena',
                                  label: snapshot.data.cena[1]
                                      ['titulo'], // CORREGIDO
                                  index: 1),
                              MealItem(
                                  mealType: Meal.bebida,
                                  mealTime: 'cena',
                                  label: snapshot.data.cena[2]
                                      ['titulo'], // CORREGIDO
                                  index: 2)
                            ])
                    ],
                  );
                }
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return const Center(child: Text('Error'));
              }
            }),
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xFF32A287),
          foregroundColor: Colors.white,
          onPressed: () {
            context.push("/food-registration");
          },
          child: const Icon(FontAwesomeIcons.utensils, size: 20),
        ),
      );
    } else if (dayNumber == DateTime.friday) {
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: FutureBuilder(
            future: firestore.getViernes(user!.uid),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.data == null) {
                  return Container(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    child: const Center(child: Text("Sin datos de dieta")),
                  );
                } else {
                  return ListView(
                    children: [
                      if (snapshot.data?.desayuno != null &&
                          snapshot.data.desayuno.isNotEmpty)
                        MealCard(
                            label: 'Desayuno',
                            time: snapshot.data.desayuno[0],
                            state: _mealsCompletionMap['Desayuno'] == true
                                ? 'completado'
                                : 'pendiente',
                            onTap: () => _completeMealLocal('Desayuno'),
                            items: [
                              MealItem(
                                  mealType: Meal.bebida,
                                  mealTime: 'desayuno',
                                  label: snapshot.data.desayuno[1][
                                      'titulo'], // CORREGIDO: Retorna el acceso por índice entero
                                  index: 1),
                              MealItem(
                                  mealType: Meal.comida,
                                  mealTime: 'desayuno',
                                  label: snapshot.data.desayuno[2]
                                      ['titulo'], // CORREGIDO
                                  index: 2),
                            ]),
                      if (snapshot.data?.media != null &&
                          snapshot.data.media.isNotEmpty)
                        MealCard(
                            label: 'Media',
                            time: snapshot.data.media[0],
                            state: _mealsCompletionMap['Media'] == true
                                ? 'completado'
                                : 'pendiente',
                            onTap: () => _completeMealLocal('Media'),
                            items: [
                              MealItem(
                                  mealType: Meal.comida,
                                  mealTime: 'media',
                                  label: snapshot.data.media[1]
                                      ['titulo'], // CORREGIDO
                                  index: 1)
                            ]),
                      if (snapshot.data?.almuerzo != null &&
                          snapshot.data.almuerzo.isNotEmpty)
                        MealCard(
                            label: 'Almuerzo',
                            time: snapshot.data.almuerzo[0],
                            state: _mealsCompletionMap['Almuerzo'] == true
                                ? 'completado'
                                : 'pendiente',
                            onTap: () => _completeMealLocal('Almuerzo'),
                            items: [
                              MealItem(
                                  mealType: Meal.comida,
                                  mealTime: 'almuerzo',
                                  label: snapshot.data.almuerzo[1]
                                      ['titulo'], // CORREGIDO
                                  index: 1),
                              MealItem(
                                  mealType: Meal.bebida,
                                  mealTime: 'almuerzo',
                                  label: snapshot.data.almuerzo[2]
                                      ['titulo'], // CORREGIDO
                                  index: 2)
                            ]),
                      if (snapshot.data?.merienda != null &&
                          snapshot.data.merienda.isNotEmpty)
                        MealCard(
                            label: 'Merienda',
                            time: snapshot.data.merienda[0],
                            state: _mealsCompletionMap['Merienda'] == true
                                ? 'completado'
                                : 'pendiente',
                            onTap: () => _completeMealLocal('Merienda'),
                            items: [
                              MealItem(
                                  mealType: Meal.fruta,
                                  mealTime: 'merienda',
                                  label: snapshot.data.merienda[1]
                                      ['titulo'], // CORREGIDO
                                  index: 1)
                            ]),
                      if (snapshot.data?.cena != null &&
                          snapshot.data.cena.isNotEmpty)
                        MealCard(
                            label: 'Cena',
                            time: snapshot.data.cena[0],
                            state: _mealsCompletionMap['Cena'] == true
                                ? 'completado'
                                : 'pendiente',
                            onTap: () => _completeMealLocal('Cena'),
                            items: [
                              MealItem(
                                  mealType: Meal.comida,
                                  mealTime: 'cena',
                                  label: snapshot.data.cena[1]
                                      ['titulo'], // CORREGIDO
                                  index: 1),
                              MealItem(
                                  mealType: Meal.bebida,
                                  mealTime: 'cena',
                                  label: snapshot.data.cena[2]
                                      ['titulo'], // CORREGIDO
                                  index: 2)
                            ])
                    ],
                  );
                }
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return const Center(child: Text('Error'));
              }
            }),
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xFF32A287),
          foregroundColor: Colors.white,
          onPressed: () {
            context.push("/food-registration");
          },
          child: const Icon(FontAwesomeIcons.utensils, size: 20),
        ),
      );
    } else if (dayNumber == DateTime.saturday) {
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: FutureBuilder(
            future: firestore.getSabado(user!.uid),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.data == null) {
                  return Container(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    child: const Center(child: Text("Sin datos de dieta")),
                  );
                } else {
                  return ListView(
                    children: [
                      if (snapshot.data?.desayuno != null &&
                          snapshot.data.desayuno.isNotEmpty)
                        MealCard(
                            label: 'Desayuno',
                            time: snapshot.data.desayuno[0],
                            state: _mealsCompletionMap['Desayuno'] == true
                                ? 'completado'
                                : 'pendiente',
                            onTap: () => _completeMealLocal('Desayuno'),
                            items: [
                              MealItem(
                                  mealType: Meal.bebida,
                                  mealTime: 'desayuno',
                                  label: snapshot.data.desayuno[1][
                                      'titulo'], // CORREGIDO: Retorna el acceso por índice entero
                                  index: 1),
                              MealItem(
                                  mealType: Meal.comida,
                                  mealTime: 'desayuno',
                                  label: snapshot.data.desayuno[2]
                                      ['titulo'], // CORREGIDO
                                  index: 2),
                            ]),
                      if (snapshot.data?.media != null &&
                          snapshot.data.media.isNotEmpty)
                        MealCard(
                            label: 'Media',
                            time: snapshot.data.media[0],
                            state: _mealsCompletionMap['Media'] == true
                                ? 'completado'
                                : 'pendiente',
                            onTap: () => _completeMealLocal('Media'),
                            items: [
                              MealItem(
                                  mealType: Meal.comida,
                                  mealTime: 'media',
                                  label: snapshot.data.media[1]
                                      ['titulo'], // CORREGIDO
                                  index: 1)
                            ]),
                      if (snapshot.data?.almuerzo != null &&
                          snapshot.data.almuerzo.isNotEmpty)
                        MealCard(
                            label: 'Almuerzo',
                            time: snapshot.data.almuerzo[0],
                            state: _mealsCompletionMap['Almuerzo'] == true
                                ? 'completado'
                                : 'pendiente',
                            onTap: () => _completeMealLocal('Almuerzo'),
                            items: [
                              MealItem(
                                  mealType: Meal.comida,
                                  mealTime: 'almuerzo',
                                  label: snapshot.data.almuerzo[1]
                                      ['titulo'], // CORREGIDO
                                  index: 1),
                              MealItem(
                                  mealType: Meal.bebida,
                                  mealTime: 'almuerzo',
                                  label: snapshot.data.almuerzo[2]
                                      ['titulo'], // CORREGIDO
                                  index: 2)
                            ]),
                      if (snapshot.data?.merienda != null &&
                          snapshot.data.merienda.isNotEmpty)
                        MealCard(
                            label: 'Merienda',
                            time: snapshot.data.merienda[0],
                            state: _mealsCompletionMap['Merienda'] == true
                                ? 'completado'
                                : 'pendiente',
                            onTap: () => _completeMealLocal('Merienda'),
                            items: [
                              MealItem(
                                  mealType: Meal.fruta,
                                  mealTime: 'merienda',
                                  label: snapshot.data.merienda[1]
                                      ['titulo'], // CORREGIDO
                                  index: 1)
                            ]),
                      if (snapshot.data?.cena != null &&
                          snapshot.data.cena.isNotEmpty)
                        MealCard(
                            label: 'Cena',
                            time: snapshot.data.cena[0],
                            state: _mealsCompletionMap['Cena'] == true
                                ? 'completado'
                                : 'pendiente',
                            onTap: () => _completeMealLocal('Cena'),
                            items: [
                              MealItem(
                                  mealType: Meal.comida,
                                  mealTime: 'cena',
                                  label: snapshot.data.cena[1]
                                      ['titulo'], // CORREGIDO
                                  index: 1),
                              MealItem(
                                  mealType: Meal.bebida,
                                  mealTime: 'cena',
                                  label: snapshot.data.cena[2]
                                      ['titulo'], // CORREGIDO
                                  index: 2)
                            ])
                    ],
                  );
                }
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return const Center(child: Text('Error'));
              }
            }),
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xFF32A287),
          foregroundColor: Colors.white,
          onPressed: () {
            context.push("/food-registration");
          },
          child: const Icon(FontAwesomeIcons.utensils, size: 20),
        ),
      );
    } else {
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: FutureBuilder(
            future: firestore.getDomingo(user!.uid),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.data == null) {
                  return Container(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    child: const Center(child: Text("Sin datos de dieta")),
                  );
                } else {
                  return ListView(
                    children: [
                      if (snapshot.data?.desayuno != null &&
                          snapshot.data.desayuno.isNotEmpty)
                        MealCard(
                            label: 'Desayuno',
                            time: snapshot.data.desayuno[0],
                            state: _mealsCompletionMap['Desayuno'] == true
                                ? 'completado'
                                : 'pendiente',
                            onTap: () => _completeMealLocal('Desayuno'),
                            items: [
                              MealItem(
                                  mealType: Meal.bebida,
                                  mealTime: 'desayuno',
                                  label: snapshot.data.desayuno[1][
                                      'titulo'], // CORREGIDO: Retorna el acceso por índice entero
                                  index: 1),
                              MealItem(
                                  mealType: Meal.comida,
                                  mealTime: 'desayuno',
                                  label: snapshot.data.desayuno[2]
                                      ['titulo'], // CORREGIDO
                                  index: 2),
                            ]),
                      if (snapshot.data?.media != null &&
                          snapshot.data.media.isNotEmpty)
                        MealCard(
                            label: 'Media',
                            time: snapshot.data.media[0],
                            state: _mealsCompletionMap['Media'] == true
                                ? 'completado'
                                : 'pendiente',
                            onTap: () => _completeMealLocal('Media'),
                            items: [
                              MealItem(
                                  mealType: Meal.comida,
                                  mealTime: 'media',
                                  label: snapshot.data.media[1]
                                      ['titulo'], // CORREGIDO
                                  index: 1)
                            ]),
                      if (snapshot.data?.almuerzo != null &&
                          snapshot.data.almuerzo.isNotEmpty)
                        MealCard(
                            label: 'Almuerzo',
                            time: snapshot.data.almuerzo[0],
                            state: _mealsCompletionMap['Almuerzo'] == true
                                ? 'completado'
                                : 'pendiente',
                            onTap: () => _completeMealLocal('Almuerzo'),
                            items: [
                              MealItem(
                                  mealType: Meal.comida,
                                  mealTime: 'almuerzo',
                                  label: snapshot.data.almuerzo[1]
                                      ['titulo'], // CORREGIDO
                                  index: 1),
                              MealItem(
                                  mealType: Meal.bebida,
                                  mealTime: 'almuerzo',
                                  label: snapshot.data.almuerzo[2]
                                      ['titulo'], // CORREGIDO
                                  index: 2)
                            ]),
                      if (snapshot.data?.merienda != null &&
                          snapshot.data.merienda.isNotEmpty)
                        MealCard(
                            label: 'Merienda',
                            time: snapshot.data.merienda[0],
                            state: _mealsCompletionMap['Merienda'] == true
                                ? 'completado'
                                : 'pendiente',
                            onTap: () => _completeMealLocal('Merienda'),
                            items: [
                              MealItem(
                                  mealType: Meal.fruta,
                                  mealTime: 'merienda',
                                  label: snapshot.data.merienda[1]
                                      ['titulo'], // CORREGIDO
                                  index: 1)
                            ]),
                      if (snapshot.data?.cena != null &&
                          snapshot.data.cena.isNotEmpty)
                        MealCard(
                            label: 'Cena',
                            time: snapshot.data.cena[0],
                            state: _mealsCompletionMap['Cena'] == true
                                ? 'completado'
                                : 'pendiente',
                            onTap: () => _completeMealLocal('Cena'),
                            items: [
                              MealItem(
                                  mealType: Meal.comida,
                                  mealTime: 'cena',
                                  label: snapshot.data.cena[1]
                                      ['titulo'], // CORREGIDO
                                  index: 1),
                              MealItem(
                                  mealType: Meal.bebida,
                                  mealTime: 'cena',
                                  label: snapshot.data.cena[2]
                                      ['titulo'], // CORREGIDO
                                  index: 2)
                            ])
                    ],
                  );
                }
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return const Center(child: Text('Error'));
              }
            }),
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xFF32A287),
          foregroundColor: Colors.white,
          onPressed: () {
            context.push("/food-registration");
          },
          child: const Icon(FontAwesomeIcons.utensils, size: 20),
        ),
      );
    }
  }
}
