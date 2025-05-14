import 'dart:math';
import 'package:flutter/material.dart';

class Medida {
  Medida({
    required this.altura,
    required this.peso,
    this.imc,
    required this.cintura,
    required this.cadera,
  });

  final int? altura; // en metros
  final double? peso; // en kilogramos
  final double? imc; // se calcula automáticamente
  final double? cintura; // en centímetros
  final double? cadera; // en centímetros

  // Calculamos el IMC automáticamente
  static double? calcularIMC(double? peso, int? altura) {
    if (peso != null && altura != null && altura > 0) {
      return peso / pow(altura, 2);
    }
    return null;
  }

  factory Medida.fromJson(Map<String, dynamic> json) {
    final altura = json["altura"] as int?;
    final peso = (json["peso"] as num?)?.toDouble();
    return Medida(
      altura: altura,
      peso: peso,
      cintura: (json["cintura"] as num?)?.toDouble(),
      cadera: (json["cadera"] as num?)?.toDouble(),
      imc: calcularIMC(peso, altura),
    );
  }

  factory Medida.fromControllers(
      Map<String, TextEditingController> controllers) {
    final altura = int.tryParse(controllers["altura"]!.text);
    final peso = double.tryParse(controllers["peso"]!.text);
    return Medida(
      altura: altura,
      peso: peso,
      cintura: double.tryParse(controllers["cintura"]!.text),
      cadera: double.tryParse(controllers["cadera"]!.text),
      imc: calcularIMC(peso, altura), // Calculamos IMC aquí también
    );
  }

  Map<String, dynamic> toJson() => {
        "altura": altura,
        "peso": peso,
        "imc": imc,
        "cintura": cintura,
        "cadera": cadera,
      };

  Map<String, TextEditingController> toController() => {
        "altura": TextEditingController(text: altura?.toString() ?? ""),
        "peso": TextEditingController(text: peso?.toString() ?? ""),
        //"imc": TextEditingController(text: imc?.toStringAsFixed(2) ?? ""),
        "cintura": TextEditingController(text: cintura?.toString() ?? ""),
        "cadera": TextEditingController(text: cadera?.toString() ?? ""),
      };

  static Map<String, TextEditingController> getEmptyControllers() => {
        "altura": TextEditingController(),
        "peso": TextEditingController(),
        //"imc": TextEditingController(),
        "cintura": TextEditingController(),
        "cadera": TextEditingController(),
      };
}
