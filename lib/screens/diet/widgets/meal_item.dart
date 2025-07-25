import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    required this.index,
    required this.mealType,
    required this.label,
    required this.mealTime
  });

  final String label;
  final Meal mealType;
  final int index;
  final String mealTime;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setInt("Index", index);
        prefs.setString("Label", mealTime);
        GoRouter.of(context).push('/details');
      },
      child: ListTile(
          title: Text(label), leading: Icon(mealType.icon, size: 20.0)),
    );
  }
}
