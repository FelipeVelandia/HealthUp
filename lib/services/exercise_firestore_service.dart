import 'package:cloud_firestore/cloud_firestore.dart';

class ExerciseFirestoreService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Envía el registro de ejercicio a Firestore vinculándolo al ID real del usuario
  static Future<void> uploadExercise({
    required String activityName,
    required int durationMinutes,
    required DateTime scheduledTime,
    required String userId, // Requerido y obligatorio igual que en tu FoodFirestoreService
  }) async {
    try {
      final Map<String, dynamic> uploadData = {
        'userId': userId, // Guardamos el ID real del usuario autenticado
        'createdAt': FieldValue.serverTimestamp(), // Marca de tiempo del servidor
        'activityName': activityName,
        'durationMinutes': durationMinutes,
        'scheduledTime': Timestamp.fromDate(scheduledTime), // Hora elegida
      };

      // Guarda con un ID de documento automático generado por .add()
      await _db.collection('exercise_registries').add(uploadData);
    } catch (e) {
      throw Exception("Error al subir los datos de ejercicio a Firestore: $e");
    }
  }
}
