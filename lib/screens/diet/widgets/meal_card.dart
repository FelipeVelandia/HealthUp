import 'package:flutter/material.dart';
export 'meal_item.dart';

class MealCard extends StatelessWidget {
  const MealCard(
      {super.key,
      required this.label,
      required this.time,
      required this.items,
      required this.state});

  final String label;
  final String time;
  final String state;
  final List<Widget> items;

  @override
  Widget build(BuildContext context) {
    return Card.outlined(
      margin: const EdgeInsets.all(12.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16.0),
                ),
                FilledButton.tonalIcon(
                  onPressed: () {},
                  icon: const Icon(Icons.alarm),
                  label: Text(time),
                ),
                FilledButton.tonalIcon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Completar Mision"),
                          content: const Text("¿Quieres dar esta mision por completada?"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("Si"),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("No"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  label: Text(state),
                )
              ],
            ),
            ...items
          ],
        ),
      ),
    );
  }
}
