
class Dieta {
  final String? nombre;
  final String? objetivo;
  final String? tipo;
  final String descripcion;

  Dieta(
      {required this.nombre,
      required this.objetivo,
      required this.tipo,
      required this.descripcion});

  factory Dieta.fromMap(Map<String,dynamic>? data) {
    return Dieta(
      nombre: data?['nombre'] ?? '',
      objetivo: data?['objetivo'] ?? '',
      tipo: data?['tipo'] ?? '',
      descripcion: data?['descripcion'] ?? '',
    );
  }
}

class Plan {
  final List<dynamic>? desayuno;
  final List<dynamic>? media;
  final List<dynamic>? almuerzo;
  final List<dynamic>? merienda;
  final List<dynamic>? cena;

  Plan({
    this.desayuno,
    this.media,
    this.almuerzo,
    this.merienda,
    this.cena
  });

  factory Plan.fromMap(Map<String,dynamic>? data) {
    return Plan(
      desayuno: List<dynamic>.from(data?['desayuno'] ?? []),
      media: List<dynamic>.from(data?['media'] ?? []),
      almuerzo: List<dynamic>.from(data?['almuerzo'] ?? []),
      merienda: List<dynamic>.from(data?['merienda'] ?? []),
      cena: List<dynamic>.from(data?['cena'] ?? [])
    );
  }
}
