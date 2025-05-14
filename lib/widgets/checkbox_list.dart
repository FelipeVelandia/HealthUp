import 'package:flutter/material.dart';

class CheckboxList extends StatefulWidget {
  final TextEditingController controller;
  final List<String> options;

  const CheckboxList({
    super.key,
    required this.controller,
    required this.options,
  });

  @override
  State<CheckboxList> createState() => _CheckboxListState();
}

class _CheckboxListState extends State<CheckboxList> {
  List<bool> _selectedOptions = [];

  @override
  void initState() {
    super.initState();
    _selectedOptions = List<bool>.filled(widget.options.length, false);
  }

  void _updateController() {
    // Filtra las opciones seleccionadas y las une con comas
    List<String> selectedItems = [];
    for (int i = 0; i < widget.options.length; i++) {
      if (_selectedOptions[i]) {
        selectedItems.add(widget.options[i]);
      }
    }
    // Actualiza el TextEditingController con las opciones seleccionadas
    widget.controller.text = selectedItems.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Muestra los checkboxes
        for (int i = 0; i < widget.options.length; i++)
          CheckboxListTile(
            title: Text(widget.options[i]),
            value: _selectedOptions[i],
            onChanged: (bool? value) {
              setState(() {
                _selectedOptions[i] = value ?? false;
              });
              _updateController(); // Actualiza el controlador
            },
          ),
      ],
    );
  }
}
