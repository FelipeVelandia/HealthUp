import 'package:cloud_firestore/cloud_firestore.dart';

class ExerciseFirestoreService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Envía el registro de ejercicio a Firestore vinculándolo al ID real del usuario
  static Future<void> uploadExercise({
    required String activityName,
    required int durationMinutes,
    required DateTime scheduledTime,
    required String userId, 
  }) async {
    try {
      // Formateamos la hora y minutos en un String de 24H (Ej: "08:05" o "16:20")
      final String horaFormateada24H = 
          '${scheduledTime.hour.toString().padLeft(2, '0')}:${scheduledTime.minute.toString().padLeft(2, '0')}';

      final Map<String, dynamic> uploadData = {
        'userId': userId, 
        'createdAt': FieldValue.serverTimestamp(), 
        'activityName': activityName,
        'durationMinutes': durationMinutes,
        'scheduledTime': Timestamp.fromDate(scheduledTime), // Estampa de fecha y hora completa
        'exerciseTime': horaFormateada24H, // <--- NUEVO: Hora explícita en formato de 24H guardada en Firestore
      };

      // Guarda con un ID de documento automático generado por .add()
      await _db.collection('exercise_registries').add(uploadData);
    } catch (e) {
      throw Exception("Error al subir los datos de ejercicio a Firestore: $e");
    }
  }
}
