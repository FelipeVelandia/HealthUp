import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // Agregamos esto
import 'package:go_router/go_router.dart'; // Agregamos esto
import 'widgets/meal_card.dart';

class DietPage extends StatelessWidget {
  const DietPage({super.key});
  final String title = "Menú para hoy";

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
    );
  }
}