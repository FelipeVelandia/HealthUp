class PuntosModel {
  final String uid;
  final int valor;
  final int historicExerciseDays;
  final int historicWaterDays;
  final int historicMealsCount;
  final int historicRewardsCount; // <--- NUEVA PROPIEDAD NATIVA

  PuntosModel({
    required this.uid,
    required this.valor,
    required this.historicExerciseDays,
    required this.historicWaterDays,
    required this.historicMealsCount,
    required this.historicRewardsCount, // <--- REQUERIDO EN EL CONSTRUCTOR
  });

  /// Convierte el objeto de Dart a un Mapa de pares clave-valor para subir a Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'puntos': valor, // Mantenemos 'puntos' si es el nombre exacto en tu base de datos
      'historicExerciseDays': historicExerciseDays,
      'historicWaterDays': historicWaterDays,
      'historicMealsCount': historicMealsCount,
      'historicRewardsCount': historicRewardsCount, // <--- AGREGADO AL MAPEO
    };
  }

  /// Factory constructor para reconstruir el objeto desde los datos crudos de Firestore
  factory PuntosModel.fromMap(String uid, Map<String, dynamic>? data) {
    if (data == null) {
      return PuntosModel(
        uid: uid,
        valor: 0,
        historicExerciseDays: 0,
        historicWaterDays: 0,
        historicMealsCount: 0,
        historicRewardsCount: 0,
      );
    }

    return PuntosModel(
      uid: uid,
      valor: data['puntos'] ?? data['valor'] ?? 0, // Doble comprobación por si usas 'puntos' o 'valor' en Firestore
      historicExerciseDays: data['historicExerciseDays'] ?? 0,
      historicWaterDays: data['historicWaterDays'] ?? 0,
      historicMealsCount: data['historicMealsCount'] ?? 0,
      historicRewardsCount: data['historicRewardsCount'] ?? 0, // <--- EXTRACCIÓN SEGURA CON FALLBACK A 0
    );
  }
}
