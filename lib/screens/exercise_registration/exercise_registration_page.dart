import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class ExerciseRegistrationPage extends StatefulWidget {
  const ExerciseRegistrationPage({super.key});

  @override
  State<ExerciseRegistrationPage> createState() => _ExerciseRegistrationPageState();
}

class _ExerciseRegistrationPageState extends State<ExerciseRegistrationPage> {
  // 1. Iniciamos en null para que aparezca el "Hint" (Selecciona actividad)
  String? selectedActivity; 
  final TextEditingController _durationController = TextEditingController();

  // Lógica de puntos basada en tu diagrama
  int _calcularPuntos(String actividad, int minutos) {
    double factor = 0;
    switch (actividad) {
      case 'Yoga': factor = 0.5; break;
      case 'Caminar': factor = 0.8; break;
      case 'Pesas': factor = 1.2; break;
      case 'Correr': factor = 2.0; break;
      case 'Natación': factor = 2.0; break;
      default: factor = 0.5;
    }
    return (minutos * factor).toInt();
  }

  void _procesarRegistro() {
    // Validación de Actividad
    if (selectedActivity == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ Por favor, selecciona una actividad")),
      );
      return;
    }

    // Validación de Minutos
    int? minutos = int.tryParse(_durationController.text);
    if (minutos == null || minutos <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ Ingresa un tiempo válido en minutos")),
      );
      return;
    }

    // Si todo está bien, calculamos
    int puntosGanados = _calcularPuntos(selectedActivity!, minutos);
    bool ganoInsignia = puntosGanados >= 50; // Condición del rombo

    // Mostrar resultado al usuario (Feedback del sistema)
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(ganoInsignia ? "¡Insignia Desbloqueada! 🏆" : "¡Buen trabajo!"),
        content: Text("Has registrado $selectedActivity por $minutos min.\n\n¡Ganaste $puntosGanados puntos!"),
        actions: [
          TextButton(
            onPressed: () {
              context.pop(); // Cierra el diálogo
              context.pop(); // Regresa a la pantalla anterior
            },
            child: const Text("CERRAR"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Usamos el verde que mencionamos para estas páginas de acción
    const Color greenPrimary = Color(0xFF32A287);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Registrar Actividad físca"),
        backgroundColor: greenPrimary,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "¿Qué actividad realizaste?",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            
            // DROPDOWN CON HINT
            DropdownButtonFormField<String>(
              value: selectedActivity,
              hint: const Text("Selecciona una actividad"),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                prefixIcon: Icon(FontAwesomeIcons.personRunning, size: 18),
              ),
              items: ['Caminar', 'Correr', 'Pesas', 'Yoga', 'Natación']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (val) => setState(() => selectedActivity = val),
            ),

            const SizedBox(height: 30),

            const Text(
              "¿Cuánto tiempo? (minutos)",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            
            TextField(
              controller: _durationController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: "Ej: 30",
                border: OutlineInputBorder(),
                prefixIcon: Icon(FontAwesomeIcons.clock, size: 18),
              ),
            ),

            const Spacer(),

            // BOTÓN DE GUARDAR
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: greenPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _procesarRegistro,
                child: const Text(
                  "GUARDAR REGISTRO",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}