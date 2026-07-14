class PuntosModel {
  PuntosModel({
    required this.uid,
    required this.valor,
    this.historicExerciseDays = 0,
    this.historicWaterDays = 0,
    this.historicMealsCount = 0,
  });

  final String uid;
  final int valor;
  final int historicExerciseDays;
  final int historicWaterDays;
  final int historicMealsCount;

  factory PuntosModel.fromMap(String documentId, Map<String, dynamic>? data) {
    return PuntosModel(
      uid: documentId,
      valor: (data?['valor'] ?? 0) as int,
      historicExerciseDays: (data?['historicExerciseDays'] ?? 0) as int,
      historicWaterDays: (data?['historicWaterDays'] ?? 0) as int,
      historicMealsCount: (data?['historicMealsCount'] ?? 0) as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'valor': valor,
      'historicExerciseDays': historicExerciseDays,
      'historicWaterDays': historicWaterDays,
      'historicMealsCount': historicMealsCount,
    };
  }
}
