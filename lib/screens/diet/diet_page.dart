import 'package:flutter/material.dart';

import 'widgets/meal_card.dart';

class DietPage extends StatelessWidget {
  const DietPage({super.key});
  final String title = "Menú para hoy";

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: ListView(
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
    );
  }
}
