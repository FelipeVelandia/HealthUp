import 'package:flutter/material.dart';

class Antecedentes {
  Antecedentes({
    required this.familiares,
    required this.personales,
  });

  final List<String>? familiares; // Lista de antecedentes familiares
  final Map<String, String>? personales; // Mapa de antecedentes personales

  factory Antecedentes.fromJson(Map<String, dynamic> json) {
    return Antecedentes(
      familiares: json.containsKey('familiares') && json['familiares'] is List
          ? List<String>.from(json['familiares'] as List)
          : [],
      personales: json.containsKey('personales') && json['personales'] is Map
          ? Map<String, String>.from(json['personales'] as Map)
          : {},
    );
  }

  factory Antecedentes.fromControllers(
      Map<String, TextEditingController> controllers) {
    return Antecedentes(
      familiares: controllers["familiares"] != null &&
              controllers["familiares"]!.text.isNotEmpty
          ? controllers["familiares"]!
              .text
              .split(',')
              .map((e) => e.trim())
              .toList()
          : null,
      personales: controllers["personales_claves"] != null &&
              controllers["personales_claves"]!.text.isNotEmpty &&
              controllers["personales_descripciones"] != null &&
              controllers["personales_descripciones"]!.text.isNotEmpty
          ? Map.fromIterables(
              controllers["personales_claves"]!
                  .text
                  .split(',')
                  .map((e) => e.trim())
                  .toList(),
              controllers["personales_descripciones"]!
                  .text
                  .split(',')
                  .map((e) => e.trim())
                  .toList(),
            )
          : {},
    );
  }

  Map<String, dynamic> toJson() => {
        "familiares": familiares,
        "personales": personales,
      };

  Map<String, TextEditingController> toController() {
    return {
      "familiares": TextEditingController(
          text: familiares != null ? familiares!.join(', ') : ''),
      "personales_claves": TextEditingController(
          text: personales != null ? personales!.keys.join(', ') : ''),
      "personales_descripciones": TextEditingController(
          text: personales != null ? personales!.values.join(', ') : ''),
    };
  }

  static Map<String, TextEditingController> getEmptyControllers() => {
        // Un solo controlador para familiares
        "familiares": TextEditingController(),

        // Dos controladores para antecedentes personales (clave y descripción)
        "personales_claves": TextEditingController(),
        "personales_descripciones": TextEditingController(),
      };
}
