import 'package:flutter/material.dart';

class CheckboxWithDescriptions extends StatefulWidget {
  final TextEditingController selectedOptionsController;
  final TextEditingController descriptionsController;
  final List<String> options;

  const CheckboxWithDescriptions({
    super.key,
    required this.selectedOptionsController,
    required this.descriptionsController,
    required this.options,
  });

  @override
  State<CheckboxWithDescriptions> createState() =>
      _CheckboxWithDescriptionsState();
}

class _CheckboxWithDescriptionsState extends State<CheckboxWithDescriptions> {
  late List<bool> selectedItems;
  late List<String?> descriptions;

  @override
  void initState() {
    super.initState();
    // Inicializamos el estado de los checkboxes para todas las opciones.
    selectedItems = List<bool>.filled(widget.options.length, false);
    descriptions = List<String?>.filled(widget.options.length, null);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Generamos la lista de checkboxes
        ...List.generate(widget.options.length, (index) {
          return Column(
            children: [
              CheckboxListTile(
                title: Text(widget.options[index]),
                value: selectedItems[index],
                onChanged: (bool? value) {
                  setState(() {
                    selectedItems[index] = value ?? false;
                    // Actualizamos las opciones seleccionadas
                    _updateSelectedOptions();
                  });
                },
              ),
              // Solo mostramos el TextField si la opción está seleccionada
              if (selectedItems[index])
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextField(
                    onChanged: (text) {
                      setState(() {
                        descriptions[index] = text;
                        // Actualizamos las descripciones
                        _updateDescriptions();
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Descripción para "${widget.options[index]}"',
                      // ignore: prefer_const_constructors
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
            ],
          );
        }),
      ],
    );
  }

  // Actualiza el controlador de las opciones seleccionadas
  void _updateSelectedOptions() {
    // Filtramos las opciones seleccionadas usando el índice
    final selectedOptions = widget.options
        .asMap()
        .entries
        .where((entry) =>
            selectedItems[entry.key]) // Filtramos solo las seleccionadas
        .map((entry) => entry.value) // Extraemos las opciones seleccionadas
        .join(', '); // Unimos las opciones seleccionadas con comas

    widget.selectedOptionsController.text = selectedOptions;
  }

  // Actualiza el controlador de las descripciones
  void _updateDescriptions() {
    final descriptionsText =
        descriptions.where((description) => description != null).join(', ');
    widget.descriptionsController.text = descriptionsText;
  }
}
