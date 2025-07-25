
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
  final List<dynamic> desayuno;
  final List<dynamic> media;
  final List<dynamic> almuerzo;
  final List<dynamic> merienda;
  final List<dynamic> cena;

  Plan({
    required this.desayuno,
    required this.media,
    required this.almuerzo,
    required this.merienda,
    required this.cena
  });

  factory Plan.fromMap(Map<String,dynamic>? data) {
    return Plan(
      desayuno: data?['desayuno'] ?? '',
      media: data?['media'] ?? '',
      almuerzo: data?['almuerzo'] ?? '',
      merienda: data?['merienda'] ?? '',
      cena: data?['cena'] ?? ''
    );
  }
}
