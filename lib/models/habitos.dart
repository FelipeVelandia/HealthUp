import 'package:flutter/material.dart';

class Habito {
  Habito({
    required this.apetito,
    required this.ingesta,
    required this.deglucion,
    required this.masticaBien,
    required this.habitoIntestinal,
    required this.sintomasGastrointestinales,
    required this.alimentosPreferidos,
    required this.alimentosRechazados,
    required this.alimentosNoTolerados,
  });

  final String? apetito;
  final String? ingesta;
  final String? deglucion;
  final String? masticaBien;
  final String? habitoIntestinal;
  final String? sintomasGastrointestinales;
  final String? alimentosPreferidos;
  final String? alimentosRechazados;
  final String? alimentosNoTolerados;

  factory Habito.fromJson(Map<String, dynamic> json) {
    return Habito(
      apetito: json["apetito"] as String?,
      ingesta: json["ingesta"] as String?,
      deglucion: json["deglucion"] as String?,
      masticaBien: json["mastica_bien"] as String?,
      habitoIntestinal: json["habito_intestinal"] as String?,
      sintomasGastrointestinales:
          json["sintomas_gastrointestinales"] as String?,
      alimentosPreferidos: json["alimentos_preferidos"] as String?,
      alimentosRechazados: json["alimentos_rechazados"] as String?,
      alimentosNoTolerados: json["alimentos_no_tolerados"] as String?,
    );
  }

  factory Habito.fromControllers(
      Map<String, TextEditingController> controllers) {
    return Habito(
      apetito: controllers["apetito"]!.text,
      ingesta: controllers["ingesta"]!.text,
      deglucion: controllers["deglucion"]!.text,
      masticaBien: controllers["mastica_bien"]!.text,
      habitoIntestinal: controllers["habito_intestinal"]!.text,
      sintomasGastrointestinales:
          controllers["sintomas_gastrointestinales"]!.text,
      alimentosPreferidos: controllers["alimentos_preferidos"]!.text,
      alimentosRechazados: controllers["alimentos_rechazados"]!.text,
      alimentosNoTolerados: controllers["alimentos_no_tolerados"]!.text,
    );
  }

  Map<String, dynamic> toJson() => {
        "apetito": apetito,
        "ingesta": ingesta,
        "deglucion": deglucion,
        "mastica_bien": masticaBien,
        "habito_intestinal": habitoIntestinal,
        "sintomas_gastrointestinales": sintomasGastrointestinales,
        "alimentos_preferidos": alimentosPreferidos,
        "alimentos_rechazados": alimentosRechazados,
        "alimentos_no_tolerados": alimentosNoTolerados,
      };

  Map<String, TextEditingController> toController() => {
        "apetito": TextEditingController(text: apetito),
        "ingesta": TextEditingController(text: ingesta),
        "deglucion": TextEditingController(text: deglucion),
        "mastica_bien": TextEditingController(text: masticaBien),
        "habito_intestinal": TextEditingController(text: habitoIntestinal),
        "sintomas_gastrointestinales":
            TextEditingController(text: sintomasGastrointestinales),
        "alimentos_preferidos":
            TextEditingController(text: alimentosPreferidos),
        "alimentos_rechazados":
            TextEditingController(text: alimentosRechazados),
        "alimentos_no_tolerados":
            TextEditingController(text: alimentosNoTolerados),
      };

  static Map<String, TextEditingController> getEmptyControllers() => {
        "apetito": TextEditingController(),
        "ingesta": TextEditingController(),
        "deglucion": TextEditingController(),
        "mastica_bien": TextEditingController(),
        "habito_intestinal": TextEditingController(),
        "sintomas_gastrointestinales": TextEditingController(),
        "alimentos_preferidos": TextEditingController(),
        "alimentos_rechazados": TextEditingController(),
        "alimentos_no_tolerados": TextEditingController(),
      };
}
