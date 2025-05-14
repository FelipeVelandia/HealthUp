import 'package:flutter/material.dart';
import 'package:nutrialg_life/widgets/dynamic_input.dart';

class HistoriaClinica {
  HistoriaClinica({
    required this.diabetes,
    required this.insulinaBasal,
    required this.glucosa,
    required this.hbA1C,
    required this.colesterol,
    required this.trigliceridos,
    required this.hdl,
    required this.ldl,
    required this.actividadFisica,
    required this.albumina,
  });

  final String? diabetes;
  final num? insulinaBasal;
  final num? glucosa;
  final num? hbA1C;
  final num? colesterol;
  final num? trigliceridos;
  final num? hdl;
  final num? ldl;
  final num? actividadFisica;
  final num? albumina;

  factory HistoriaClinica.fromJson(Map<String, dynamic> json) {
    return HistoriaClinica(
      diabetes: json["diabetes"] as String,
      insulinaBasal: json["insulina_basal"] as num,
      glucosa: json["glucosa"] as num,
      hbA1C: json["HbA1C"] as num,
      colesterol: json["colesterol"] as num,
      trigliceridos: json["trigliceridos"] as num,
      hdl: json["HDL"] as num,
      ldl: json["LDL"] as num,
      actividadFisica: json["actividad_fisica"] as num,
      albumina: json["albumina"] as num,
    );
  }

  factory HistoriaClinica.fromControllers(
      Map<String, TextEditingController> controllers) {
    return HistoriaClinica(
      diabetes: controllers["diabetes"]!.text,
      insulinaBasal: num.parse(controllers["insulinaBasal"]!.text),
      glucosa: num.parse(controllers["glucosa"]!.text),
      hbA1C: num.parse(controllers["hbA1C"]!.text),
      colesterol: num.parse(controllers["colesterol"]!.text),
      trigliceridos: num.parse(controllers["trigliceridos"]!.text),
      hdl: num.parse(controllers["hdl"]!.text),
      ldl: num.parse(controllers["ldl"]!.text),
      actividadFisica: num.parse(controllers["actividadFisica"]!.text),
      albumina: num.parse(controllers["albumina"]!.text),
    );
  }

  Map<String, dynamic> toJson() => {
        "diabetes": diabetes,
        "insulina_basal": insulinaBasal,
        "glucosa": glucosa,
        "HbA1C": hbA1C,
        "colesterol": colesterol,
        "trigliceridos": trigliceridos,
        "HDL": hdl,
        "LDL": ldl,
        "actividad_fisica": actividadFisica,
        "albumina": albumina,
      };

  Map<String, TextEditingController> toController() => {
        "diabetes": TextEditingController(text: diabetes),
        "insulina_basal": TextEditingController(text: insulinaBasal.toString()),
        "glucosa": TextEditingController(text: glucosa.toString()),
        "HbA1C": TextEditingController(text: hbA1C.toString()),
        "colesterol": TextEditingController(text: colesterol.toString()),
        "trigliceridos": TextEditingController(text: trigliceridos.toString()),
        "HDL": TextEditingController(text: hdl.toString()),
        "LDL": TextEditingController(text: ldl.toString()),
        "actividad_fisica":
            TextEditingController(text: actividadFisica.toString()),
        "albumina": TextEditingController(text: albumina.toString()),
      };

  static Map<String, TextEditingController> getEmptyControllers() => {
        "diabetes": TextEditingController(),
        "insulina_basal": TextEditingController(),
        "glucosa": TextEditingController(),
        "HbA1C": TextEditingController(),
        "colesterol": TextEditingController(),
        "trigliceridos": TextEditingController(),
        "HDL": TextEditingController(),
        "LDL": TextEditingController(),
        "actividad_fisica": TextEditingController(),
        "albumina": TextEditingController(),
      };

  static Map<String, InputType> getInputTypes() => {
        "diabetes": InputType.yes,
        "insulina_basal": InputType.numeric,
        "glucosa": InputType.numeric,
        "HbA1C": InputType.numeric,
        "colesterol": InputType.numeric,
        "trigliceridos": InputType.numeric,
        "HDL": InputType.numeric,
        "LDL": InputType.numeric,
        "actividad_fisica": InputType.numeric,
        "albumina": InputType.numeric,
      };
}
