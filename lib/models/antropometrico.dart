import 'package:flutter/material.dart';
import 'package:nutrialg_life/widgets/dynamic_input.dart';

class Antropometrico {
  Antropometrico({
    required this.peso,
    required this.talla,
    required this.genero,
    required this.cintura,
    required this.cadera,
  });

  final num? peso;
  final num? talla;
  final String? genero;
  final num? cintura;
  final num? cadera;

  factory Antropometrico.fromJson(Map<String, dynamic> json) {
    return Antropometrico(
      peso: json["peso"] as num,
      talla: json["talla"] as num,
      genero: json["genero"] as String,
      cintura: json["medida_cintura"] as num,
      cadera: json["medida_cadera"] as num,
    );
  }

  factory Antropometrico.fromControllers(
      Map<String, TextEditingController> controllers) {
    return Antropometrico(
      peso: num.parse(controllers["peso"]!.text),
      talla: num.parse(controllers["talla"]!.text),
      genero: controllers["genero"]!.text,
      cintura: num.parse(controllers["medida_cintura"]!.text),
      cadera: num.parse(controllers["medida_cadera"]!.text),
    );
  }

  Map<String, dynamic> toJson() => {
        "peso": peso,
        "talla": talla,
        "genero": genero,
        "medida_cintura": cintura,
        "medida_cadera": cadera,
      };

  Map<String, TextEditingController> toController() => {
        "peso": TextEditingController(text: peso.toString()),
        "talla": TextEditingController(text: talla.toString()),
        "genero": TextEditingController(text: genero),
        "medida_cintura": TextEditingController(text: cintura.toString()),
        "medida_cadera": TextEditingController(text: cadera.toString()),
      };

  static Map<String, TextEditingController> getEmptyControllers() => {
        "peso": TextEditingController(),
        "talla": TextEditingController(),
        "genero": TextEditingController(),
        "medida_cintura": TextEditingController(),
        "medida_cadera": TextEditingController(),
      };

  static Map<String, InputType> getInputTypes() => {
        "peso": InputType.numeric,
        "talla": InputType.numeric,
        "genero": InputType.gender,
        "medida_cintura": InputType.numeric,
        "medida_cadera": InputType.numeric,
      };
}
