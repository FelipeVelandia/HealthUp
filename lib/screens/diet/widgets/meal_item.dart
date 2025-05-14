import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum Meal {
  comida(icon: FontAwesomeIcons.utensils),
  bebida(icon: FontAwesomeIcons.glassWater),
  fruta(icon: FontAwesomeIcons.appleWhole),
  postre(icon: FontAwesomeIcons.iceCream);

  const Meal({
    required this.icon,
  });

  final IconData icon;
}

class MealItem extends StatelessWidget {
  const MealItem({
    super.key,
    required this.mealType,
    required this.label,
  });

  final String label;
  final Meal mealType;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(label), leading: Icon(mealType.icon, size: 20.0));
  }
}
