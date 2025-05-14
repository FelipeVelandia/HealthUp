import 'package:flutter/material.dart';

class SelectInput extends StatelessWidget {
  const SelectInput(
      {super.key,
      required this.label,
      required this.controller,
      required this.options,
      this.enabled = true});
  final String label;
  final TextEditingController controller;
  final List<String> options;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return DropdownMenu<String>(
        enabled: enabled,
        menuHeight: 2000,
        width: constraints.maxWidth,
        controller: controller,
        initialSelection: controller.text.isNotEmpty ? controller.text : null,
        inputDecorationTheme: const InputDecorationTheme(
          isDense: true,
          border: OutlineInputBorder(),
        ),
        dropdownMenuEntries:
            options.map((e) => DropdownMenuEntry(value: e, label: e)).toList(),
        onSelected: (String? newValue) {
          if (newValue != null) {
            controller.text = newValue;
          }
        },
        label: Text(label),
      );
    });
  }
}
