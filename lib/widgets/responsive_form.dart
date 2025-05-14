import 'package:flutter/material.dart';
import 'package:nutrialg_life/widgets/dynamic_input.dart';

class ResponsiveForm extends StatelessWidget {
  const ResponsiveForm(
      {super.key,
      required this.controllers,
      required this.types,
      this.smallDevice = false});
  final Map<String, TextEditingController> controllers;
  final Map<String, InputType> types;
  final bool smallDevice;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: controllers.keys
          .map((e) => FractionallySizedBox(
                widthFactor: smallDevice ? 0.9 : 0.45,
                child: DynamicInputField(
                  type: types[e]!,
                  controller: controllers[e]!,
                  label: e[0].toUpperCase() +
                      e.substring(1).toLowerCase().replaceAll("_", " de "),
                ),
              ))
          .toList(),
    );
  }
}
