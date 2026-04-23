import 'package:flutter/material.dart';
import 'package:nutrialg_life/services/database_service.dart';
import 'package:provider/provider.dart';

import 'widgets/meal_card.dart';

class DietPage extends StatelessWidget {
  DietPage({super.key});
  final String title = "Menú para hoy";
  final firestore = DatabaseService();

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<DatabaseService>(context).user;
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: FutureBuilder(
          future: firestore.getLunes(user!.uid),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.data == null) {
                return Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: const Center(
                    child: Text("Sin datos de dieta"),
                  ),
                );
              } else {
                return ListView(
                  children: [
                    MealCard(
                      label: 'Desayuno',
                      time: snapshot.data.desayuno[0],
                      items: [
                        MealItem(
                            mealType: Meal.bebida,
                            mealTime: 'desayuno',
                            label: snapshot.data.desayuno[1]['titulo'],
                            index: 1),
                        MealItem(
                            mealType: Meal.comida,
                            mealTime: 'desayuno',
                            label: snapshot.data.desayuno[2]['titulo'],
                            index: 2),
                      ],
                    ),
                    MealCard(
                        label: 'Media mañana',
                        time: snapshot.data.media[0],
                        items: [
                          MealItem(
                              mealType: Meal.comida,
                              mealTime: 'media',
                              label: snapshot.data.media[1]['titulo'],
                              index: 1)
                        ]),
                    MealCard(
                        label: 'Almuerzo',
                        time: snapshot.data.almuerzo[0],
                        items: [
                          MealItem(
                              mealType: Meal.comida,
                              mealTime: 'almuerzo',
                              label: snapshot.data.almuerzo[1]['titulo'],
                              index: 1),
                          MealItem(
                              mealType: Meal.bebida,
                              mealTime: 'almuerzo',
                              label: snapshot.data.almuerzo[2]['titulo'],
                              index: 2)
                        ]),
                    MealCard(
                        label: 'Merienda',
                        time: snapshot.data.merienda[0],
                        items: [
                          MealItem(
                              mealType: Meal.fruta,
                              mealTime: 'merienda',
                              label: snapshot.data.merienda[1]['titulo'],
                              index: 1)
                        ]),
                    MealCard(
                        label: 'Cena',
                        time: snapshot.data.cena[0],
                        items: [
                          MealItem(
                              mealType: Meal.comida,
                              mealTime: 'cena',
                              label: snapshot.data.cena[1]['titulo'],
                              index: 1),
                          MealItem(
                              mealType: Meal.bebida,
                              mealTime: 'cena',
                              label: snapshot.data.cena[2]['titulo'],
                              index: 2)
                        ])
                  ],
                );
              }
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text('Loading');
            } else {
              return const Text('Error');
            }
          }),
    );
  }
}
