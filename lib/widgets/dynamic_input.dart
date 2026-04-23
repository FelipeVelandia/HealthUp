import 'package:flutter/material.dart';
import 'package:nutrialg_life/utils/forms_validators.dart';
import 'package:nutrialg_life/widgets/select_input.dart';

enum InputType {
  text,
  multiline,
  numeric,
  phone,
  email,
  password,
  date,
  gender,
  yes,
}

class DynamicInputField extends StatelessWidget {
  const DynamicInputField({
    super.key,
    required this.type,
    required this.label,
    this.icon,
    required this.controller,
  });
  final InputType type;
  final String label;
  final IconData? icon;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    var decoration = InputDecoration(
        prefixIcon: icon != null ? Icon(icon) : null,
        border: const OutlineInputBorder(),
        labelText: label,
        alignLabelWithHint: true,
        //isDense: true,
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface);

    switch (type) {
      case InputType.text:
        return TextFormField(
          decoration: decoration,
          controller: controller,
          validator: emptyValidator,
        );
      case InputType.numeric:
        return TextFormField(
          decoration: decoration,
          controller: controller,
          validator: emptyValidator,
          keyboardType: TextInputType.number,
        );
      case InputType.phone:
        return TextFormField(
          decoration: decoration,
          controller: controller,
          validator: phoneValidator,
          keyboardType: TextInputType.phone,
        );
      case InputType.email:
        return TextFormField(
          decoration: decoration,
          controller: controller,
          validator: emailValidator,
          keyboardType: TextInputType.emailAddress,
        );
      case InputType.password:
        return TextFormField(
          decoration: decoration,
          controller: controller,
          validator: emptyValidator,
          obscureText: true,
          keyboardType: TextInputType.visiblePassword,
        );
      case InputType.date:
        return TextFormField(
          controller: controller,
          readOnly: true,
          decoration: decoration,
          validator: emptyValidator,
          onTap: () async {
            DateTime now = DateTime.now();
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: (controller.text.isEmpty)
                  ? DateTime.now()
                  : DateTime.parse(controller.text),
              firstDate: DateTime(now.year - 100),
              lastDate: now,
            );
            if (pickedDate != null) {
              controller.text = "${pickedDate.toLocal()}".split(' ')[0];
            }
          },
        );
      case InputType.gender:
        return SelectInput(
          label: label,
          controller: controller,
          options: const ["Femenino", "Masculino"],
        );
      case InputType.yes:
        return SelectInput(
          label: label,
          controller: controller,
          options: const ["Si", "No"],
        );
      case InputType.multiline:
        return TextFormField(
          decoration: decoration,
          controller: controller,
          validator: emptyValidator,
          minLines: 2,
          maxLines: 2,
        );
    }
  }
}
