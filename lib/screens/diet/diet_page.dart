import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // Agregamos esto
import 'package:go_router/go_router.dart'; // Agregamos esto
import 'package:nutrialg_life/services/database_service.dart';
import 'package:provider/provider.dart';

import 'widgets/meal_card.dart';

class DietPage extends StatelessWidget {
  DietPage({super.key});
  final String title = "Menú para hoy";
  final firestore = DatabaseService();

  @override
  Widget build(BuildContext context) {
    // Scaffold para poder usar el botón flotante en esta pantalla 
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: ListView(
        children: const [
          MealCard(
            label: 'Desayuno',
            time: '8:00 am',
            items: [
              MealItem(
                  mealType: Meal.bebida,
                  label: 'Un vaso de leche, una infusión o un café.'),
              MealItem(
                  mealType: Meal.comida,
                  label:
                      'Muesli de cereales con plátano y un puñado de pasas.'),
            ],
          ),
          MealCard(label: 'Media mañana', time: '10:00 am', items: [
            MealItem(
                mealType: Meal.comida, label: 'Anchoas con pimiento asado.')
          ]),
          MealCard(label: 'Almuerzo', time: '12:00 pm', items: [
            MealItem(
                mealType: Meal.comida, label: 'Crema de coliflor y puerro.'),
            MealItem(
                mealType: Meal.comida,
                label: 'Lentejas guisadas con tomate y unos daditos de jamón.'),
            MealItem(mealType: Meal.bebida, label: '1 yogur natural')
          ]),
          MealCard(
              label: 'Merienda',
              time: '4:00 pm',
              items: [MealItem(mealType: Meal.fruta, label: '2 mandarinas.')]),
          MealCard(label: 'Cena', time: '7:00 pm', items: [
            MealItem(
                mealType: Meal.comida,
                label:
                    'cuscús de verduras (cebolla, zanahoria, calabaza) y pollo.'),
            MealItem(
                mealType: Meal.postre,
                label: 'Yogur con pera y una cucharadita de miel (opcional).')
          ])
        ],
      ),
      // --- Boton flotante para registrar comidas ---
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF32A287),
        foregroundColor: Colors.white,
        onPressed: () {
          context.push("/food-registration");
        },
        child: const Icon(FontAwesomeIcons.utensils, size: 20),
      ),
    var user = Provider.of<DatabaseService>(context).user;
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: FutureBuilder(
          future: firestore.getLunes(user!.uid),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.data == null) {
                return Text('no data');
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