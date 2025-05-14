import 'package:flutter/material.dart';
import 'package:nutrialg_life/utils/forms_validators.dart';
import 'package:nutrialg_life/widgets/dynamic_input.dart';

class PasswordsForm extends StatelessWidget {
  const PasswordsForm({super.key, required this.controller});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final TextEditingController confirmController = TextEditingController();

    return FractionallySizedBox(
      widthFactor: 0.9,
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          DynamicInputField(
            type: InputType.password,
            label: "Contraseña",
            controller: controller,
          ),
          TextFormField(
            controller: confirmController,
            obscureText: true,
            keyboardType: TextInputType.visiblePassword,
            validator: (value) => confirmValueValidator(value, controller.text),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: "Confirmar contraseña",
                //isDense: true,
                filled: true,
                fillColor: Theme.of(context).colorScheme.background),
          )
        ],
      ),
    );
  }
}
