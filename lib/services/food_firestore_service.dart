import 'package:cloud_firestore/cloud_firestore.dart';

class FoodFirestoreService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Envía el registro de consumo a Firestore vinculándolo al ID real del usuario
  static Future<void> uploadRegistry({
    required Map<String, List<Map<String, dynamic>>> foodRegistry,
    required int waterAmount,
    required String userId, // Ahora es requerido y obligatorio
  }) async {
    try {
      final Map<String, dynamic> uploadData = {
        'userId': userId, // Guardamos el ID real del usuario autenticado
        'createdAt': FieldValue.serverTimestamp(),
        'totalWaterMl': waterAmount,
        'meals': {
          'Desayuno': foodRegistry['Desayuno'] ?? [],
          'Almuerzo': foodRegistry['Almuerzo'] ?? [],
          'Cena': foodRegistry['Cena'] ?? [],
          'Merienda': foodRegistry['Merienda'] ?? [],
        }
      };

      // Sigue guardando con un ID de documento automático generado por .add()
      await _db.collection('food_registries').add(uploadData);
    } catch (e) {
      throw Exception("Error al subir los datos a Firestore: $e");
    }
  }
}
