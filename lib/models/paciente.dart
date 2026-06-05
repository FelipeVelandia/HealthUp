import 'package:flutter/material.dart';

class Paciente {
  Paciente({
    required this.nombre,
    required this.documento,
    required this.fecha,
    required this.telefono,
    required this.email,
    required this.genero,
  });

  final String? nombre;
  final String? documento;
  final String? fecha;
  final String? telefono;
  final String? email;
  final String? genero;

  factory Paciente.fromJson(Map<String, dynamic> json) {
    return Paciente(
      nombre: json["nombre"] as String,
      documento: json["documento"] as String,
      fecha: json["fecha"] as String,
      telefono: json["telefono"] as String,
      email: json["email"] as String,
      genero: json["genero"] as String,
    );
  }

  factory Paciente.fromControllers(
      Map<String, TextEditingController> controllers) {
    return Paciente(
      nombre: controllers["nombre"]!.text,
      documento: controllers["documento"]!.text,
      fecha: controllers["fecha"]!.text,
      telefono: controllers["telefono"]!.text,
      email: controllers["email"]!.text,
      genero: controllers["genero"]!.text,
    );
  }

  Map<String, dynamic> toJson() => {
        "nombre": nombre,
        "documento": documento,
        "fecha": fecha,
        "telefono": telefono,
        "email": email,
        "genero": genero,
      };

  Map<String, TextEditingController> toController() => {
        "nombre": TextEditingController(text: nombre),
        "documento": TextEditingController(text: documento),
        "fecha":
            TextEditingController(text: fecha),
        "telefono": TextEditingController(text: telefono),
        "email": TextEditingController(text: email),
        "genero": TextEditingController(text: genero),
      };

  static Map<String, TextEditingController> getEmptyControllers() => {
        "nombre": TextEditingController(),
        "documento": TextEditingController(),
        "fecha": TextEditingController(),
        "telefono": TextEditingController(),
        "email": TextEditingController(),
        "genero": TextEditingController(),
      };

    factory Paciente.fromMap(Map<String,dynamic>? data) {
    return Paciente(
      nombre: data?['nombre'] as String,
      documento: data?['documento'] as String,
      fecha: data?["fecha"] as String,
      telefono: data?['telefono'] as String,
      email: data?['email'] as String,
      genero: data?['genero'] as String,
    );
  }
}
