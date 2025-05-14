import 'package:flutter/material.dart';
import 'package:nutrialg_life/widgets/dynamic_input.dart';

class RegisterDataForm extends StatelessWidget {
  const RegisterDataForm({
    super.key,
    required this.pacientControllers,
  });

  final Map<String, TextEditingController> pacientControllers;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.9,
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          DynamicInputField(
            type: InputType.text,
            label: "Nombre",
            controller: pacientControllers["nombre"]!,
          ),
          DynamicInputField(
            type: InputType.numeric,
            label: "Documento de identidad",
            controller: pacientControllers["documento"]!,
          ),
          DynamicInputField(
            type: InputType.date,
            label: "Fecha de nacimiento",
            controller: pacientControllers["fecha"]!,
          ),
          DynamicInputField(
            type: InputType.phone,
            label: "Número de teléfono",
            controller: pacientControllers["telefono"]!,
          ),
          DynamicInputField(
            type: InputType.gender,
            label: "Género",
            controller: pacientControllers["genero"]!,
          ),
        ],
      ),
    );
  }
}
