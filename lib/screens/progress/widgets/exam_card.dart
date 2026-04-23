import 'package:flutter/material.dart';

class ExamCard extends StatelessWidget {
  const ExamCard({
    super.key,
    required this.description,
    required this.completed,
    required this.onTap,
  });
  final String description;
  final bool completed;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: completed
            ? Theme.of(context).colorScheme.tertiaryContainer
            : Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(120),
      ),
      child: ListTile(
        leading: Icon(completed ? Icons.check : Icons.lock_clock),
        title: Text(description),
        onTap: completed ? null : onTap,
      ),
    );
  }
}