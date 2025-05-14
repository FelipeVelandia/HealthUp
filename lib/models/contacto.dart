import 'package:flutter/material.dart';
import 'package:nutrialg_life/widgets/dynamic_input.dart';

class Contacto {
  Contacto({
    required this.nombre,
    required this.cedula,
    required this.fechaNacimiento,
    required this.telefono,
    required this.correo,
  });

  final String? nombre;
  final String? cedula;
  final DateTime? fechaNacimiento;
  final String? telefono;
  final String? correo;

  factory Contacto.fromJson(Map<String, dynamic> json) {
    return Contacto(
      nombre: json["nombre"] as String,
      cedula: json["cedula"] as String,
      fechaNacimiento: DateTime.parse(json["fecha_nacimiento"] as String),
      telefono: json["telefono"] as String,
      correo: json["correo"] as String,
    );
  }

  factory Contacto.fromControllers(
      Map<String, TextEditingController> controllers) {
    return Contacto(
      nombre: controllers["nombre"]!.text,
      cedula: controllers["cedula"]!.text,
      fechaNacimiento: DateTime.parse(controllers["fecha_nacimiento"]!.text),
      telefono: controllers["telefono"]!.text,
      correo: controllers["correo"]!.text,
    );
  }

  Map<String, dynamic> toJson() => {
        "nombre": nombre,
        "cedula": cedula,
        "fecha_nacimiento": "${fechaNacimiento?.toLocal()}".split(' ')[0],
        "telefono": telefono,
        "correo": correo,
      };

  Map<String, TextEditingController> toController() => {
        "nombre": TextEditingController(text: nombre),
        "cedula": TextEditingController(text: cedula),
        "fecha_nacimiento": TextEditingController(
            text: "${fechaNacimiento?.toLocal()}".split(' ')[0]),
        "telefono": TextEditingController(text: telefono),
        "correo": TextEditingController(text: correo),
      };

  static Map<String, TextEditingController> getEmptyControllers() => {
        "nombre": TextEditingController(),
        "cedula": TextEditingController(),
        "fecha_nacimiento": TextEditingController(),
        "telefono": TextEditingController(),
        "correo": TextEditingController(),
      };

  static Map<String, InputType> getInputTypes() => {
        "nombre": InputType.text,
        "cedula": InputType.numeric,
        "fecha_nacimiento": InputType.date,
        "telefono": InputType.phone,
        "correo": InputType.email,
      };
}
