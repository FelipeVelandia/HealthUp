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

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xFF32A287)),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) setState(() => _selectedTime = picked);
  }

  int _calcularPuntos(String actividad, int minutos) {
    double factor = 0.5;
    if (actividad == 'Caminar') factor = 0.8;
    else if (actividad == 'Pesas') factor = 1.2;
    else if (actividad == 'Correr' || actividad == 'Natación') factor = 2.0;
    else if (actividad == 'Otros') factor = 1.0;
    return (minutos * factor).toInt();
  }

  void _procesarRegistro() {
    if (selectedActivity == null) return;
    int? minutos = int.tryParse(_durationController.text);
    if (minutos == null || minutos <= 0) return;

    int puntos = _calcularPuntos(selectedActivity!, minutos);
    String nombreFinal = selectedActivity == 'Otros' ? _otherActivityController.text : selectedActivity!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text("¡Buen trabajo!"),
        content: Text("Registrado: $nombreFinal\nHora: ${_selectedTime.format(context)}\nPuntos: $puntos"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK")),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF8F5),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("¿Qué actividad realizaste?", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: selectedActivity,
              hint: const Text("Selecciona una actividad"),
              decoration: InputDecoration(
                filled: true, fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                prefixIcon: const Icon(FontAwesomeIcons.personRunning, size: 18, color: Color(0xFF32A287)),
              ),
              items: ['Caminar', 'Correr', 'Pesas', 'Natación', 'Otro:']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (val) => setState(() => selectedActivity = val),
            ),
            if (selectedActivity == 'Otro:') ...[
              const SizedBox(height: 20),
              TextField(
                controller: _otherActivityController,
                decoration: InputDecoration(
                  hintText: "¿Cuál ejercicio?", filled: true, fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                ),
              ),
            ],
            const SizedBox(height: 30),
            const Text("¿Cuánto tiempo? (minutos)", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            TextField(
              controller: _durationController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Ej: 30", filled: true, fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                prefixIcon: const Icon(FontAwesomeIcons.clock, size: 18, color: Color(0xFF32A287)),
              ),
            ),
            const SizedBox(height: 30),
            const Text('¿A qué hora?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            InkWell(
              onTap: () => _selectTime(context),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: const Color(0xFF32A287).withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.access_time, color: Color(0xFF32A287), size: 20),
                    const SizedBox(width: 8),
                    Text(_selectedTime.format(context), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF32A287))),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity, height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF32A287), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                onPressed: _procesarRegistro,
                child: const Text("GUARDAR REGISTRO", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}