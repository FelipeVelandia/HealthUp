import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class ExerciseRegistrationPage extends StatefulWidget {
  const ExerciseRegistrationPage({super.key});

  @override
  State<ExerciseRegistrationPage> createState() => _ExerciseRegistrationPageState();
}

class _ExerciseRegistrationPageState extends State<ExerciseRegistrationPage> {
  String? selectedActivity; 
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _otherActivityController = TextEditingController();
  TimeOfDay _selectedTime = TimeOfDay.now();

  final List<String> _activities = ['Caminar', 'Correr', 'Pesas', 'Yoga', 'Natación', 'Otros'];

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF32A287),
              onSurface: Color(0xFF3E302D),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) setState(() => _selectedTime = picked);
  }

  void _procesarRegistro() {
    if (selectedActivity == null) {
      _showError("⚠️ Selecciona una actividad");
      return;
    }

    if (selectedActivity == 'Otros' && _otherActivityController.text.isEmpty) {
      _showError("⚠️ ¿Qué otra actividad hiciste?");
      return;
    }

    if (_durationController.text.isEmpty) {
      _showError("⚠️ Ingresa la duración");
      return;
    }

    // Aquí simplemente guardamos los datos
    _showConfirmacion();
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  void _showConfirmacion() {
    String nombreActividad = selectedActivity == 'Otros' 
        ? _otherActivityController.text 
        : selectedActivity!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text("Registro Guardado"),
        content: Text("Actividad: $nombreActividad\nDuración: ${_durationController.text} min\nHora: ${_selectedTime.format(context)}"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Cierra diálogo
              context.pop(); // Regresa al Home
            },
            child: const Text("ACEPTAR", style: TextStyle(color: Color(0xFF32A287))),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color greenPrimary = Color(0xFF32A287);

    return Scaffold(
      backgroundColor: const Color(0xFFFDF8F5),
      appBar: AppBar(
        title: const Text("Registrar Ejercicio", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: const Color(0xFF3E302D),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("¿Qué actividad realizaste?", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF3E302D))),
            const SizedBox(height: 12),
            
            DropdownButtonFormField<String>(
              value: selectedActivity,
              hint: const Text("Selecciona una actividad"),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                prefixIcon: const Icon(FontAwesomeIcons.personRunning, size: 18, color: greenPrimary),
              ),
              items: _activities.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (val) => setState(() => selectedActivity = val),
            ),

            if (selectedActivity == 'Otros') ...[
              const SizedBox(height: 15),
              TextField(
                controller: _otherActivityController,
                decoration: InputDecoration(
                  hintText: "¿Cuál actividad?",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
            ],

            const SizedBox(height: 25),
            const Text("¿Cuánto tiempo? (minutos)", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF3E302D))),
            const SizedBox(height: 12),
            
            TextField(
              controller: _durationController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Ej: 30",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                prefixIcon: const Icon(FontAwesomeIcons.clock, size: 18, color: greenPrimary),
              ),
            ),

            const SizedBox(height: 25),
            const Text("¿A qué hora?", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF3E302D))),
            const SizedBox(height: 12),

            InkWell(
              onTap: () => _selectTime(context),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.access_time, color: greenPrimary),
                    const SizedBox(width: 12),
                    Text(_selectedTime.format(context), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                    const Spacer(),
                    const Icon(Icons.edit, size: 16, color: Colors.grey),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: greenPrimary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                onPressed: _procesarRegistro,
                child: const Text("GUARDAR ACTIVIDAD", 
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}