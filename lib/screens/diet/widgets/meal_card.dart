import 'package:flutter/material.dart';
export 'meal_item.dart';

class MealCard extends StatelessWidget {
  const MealCard({
    super.key,
    required this.label,
    required this.time,
    required this.items,
    required this.state,
    required this.onTap,
  });

  final String label;
  final String time;
  final String state; 
  final List<Widget> items;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bool isCompleted = state == 'completado' || state == 'true';

    return Card.outlined(
      margin: const EdgeInsets.all(12.0),
      color: isCompleted ? Colors.green.shade50 : null,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                ),
                Row(
                  children: [
                    FilledButton.tonalIcon(
                      onPressed: () {},
                      icon: const Icon(Icons.alarm),
                      label: Text(time),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: Icon(
                        isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
                        color: isCompleted ? Colors.green : Colors.grey,
                        size: 28,
                      ),
                      // FIJACIÓN: Si ya está completo congelamos la acción pasando un null rotundo
                      onPressed: isCompleted ? null : onTap, 
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(height: 8),
            ...items
          ],
        ),
      ),
    );
  }
}
