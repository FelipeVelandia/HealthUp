import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class FoodRegistrationScreen extends StatefulWidget {
  const FoodRegistrationScreen({super.key});

  @override
  State<FoodRegistrationScreen> createState() => _FoodRegistrationScreenState();
}

class _FoodRegistrationScreenState extends State<FoodRegistrationScreen> {
  final TextEditingController _foodController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController(text: '1');
  
  String _selectedUnit = 'Seleccione unidad';
  int _selectedTab = 0; 
  TimeOfDay _selectedTime = TimeOfDay.now();

  // Categorías actualizadas: Snacks -> Merienda e incluye Agua
  final List<String> _categories = ['Desayuno', 'Almuerzo', 'Cena', 'Merienda', 'Agua'];
  
  final List<String> _units = [
    'Seleccione unidad', 'Taza', 'Puñado', 'Cucharada', 'unidad', 'Gramos', 'Porcion', 'mL'
  ];

  // Lista local para mostrar lo que se va registrando antes de guardar
  List<Map<String, dynamic>> _tempRegistry = [];

  void _addWater(int amount, String type) {
    setState(() {
      _tempRegistry.add({
        'name': 'Agua ($type)',
        'quantity': amount.toString(),
        'unit': 'mL',
        'time': _selectedTime.format(context),
        'isWater': true,
      });
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('¡+$amount mL de agua añadidos! 💧'), duration: const Duration(seconds: 1)),
    );
  }

  void _addFood() {
    if (_foodController.text.isEmpty || _selectedUnit == 'Seleccione unidad') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completa el nombre y la unidad')),
      );
      return;
    }

    setState(() {
      _tempRegistry.add({
        'name': _foodController.text,
        'quantity': _quantityController.text,
        'unit': _selectedUnit,
        'time': _selectedTime.format(context),
        'isWater': false,
      });
      _foodController.clear();
      _quantityController.text = '1';
    });
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null) setState(() => _selectedTime = picked);
  }

  @override
  Widget build(BuildContext context) {
    const Color greenPrimary = Color(0xFF32A287);
    bool isWaterTab = _categories[_selectedTab] == 'Agua';

    return Scaffold(
      backgroundColor: const Color(0xFFFDF8F5),
      appBar: AppBar(
        title: const Text("Registrar Consumo", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: const Color(0xFF3E302D),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TABS DE CATEGORÍAS
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  bool isSelected = _selectedTab == index;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedTab = index),
                    child: Container(
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: isSelected ? greenPrimary : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: greenPrimary),
                      ),
                      child: Center(
                        child: Text(
                          _categories[index],
                          style: TextStyle(
                            color: isSelected ? Colors.white : greenPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 25),

            // CONTENIDO DINÁMICO (COMIDA O AGUA)
            isWaterTab ? _buildWaterSection() : _buildFoodSection(greenPrimary),

            if (_tempRegistry.isNotEmpty) ...[
              const Divider(height: 40),
              const Text("Resumen actual:", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              ..._tempRegistry.map((item) => ListTile(
                leading: Icon(item['isWater'] ? Icons.water_drop : Icons.restaurant, 
                             color: item['isWater'] ? Colors.blue : greenPrimary),
                title: Text(item['name']),
                subtitle: Text("${item['quantity']} ${item['unit']} - ${item['time']}"),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () => setState(() => _tempRegistry.remove(item)),
                ),
              )),
            ],

            const SizedBox(height: 30),
            
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: greenPrimary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                onPressed: () => context.pop(),
                child: const Text("GUARDAR TODO", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFoodSection(Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _foodController,
          decoration: InputDecoration(
            hintText: "¿Qué comiste?",
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
            prefixIcon: Icon(Icons.search, color: color),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: TextField(
                controller: _quantityController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "Cant.",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 3,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedUnit,
                    items: _units.map((u) => DropdownMenuItem(value: u, child: Text(u))).toList(),
                    onChanged: (v) => setState(() => _selectedUnit = v!),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        ListTile(
          onTap: () => _selectTime(context),
          tileColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          leading: Icon(Icons.access_time, color: color),
          title: Text("Hora: ${_selectedTime.format(context)}"),
          trailing: const Icon(Icons.edit, size: 16),
        ),
        const SizedBox(height: 20),
        Center(
          child: TextButton.icon(
            onPressed: _addFood,
            icon: const Icon(Icons.add, color: Colors.orange),
            label: const Text("Añadir a la lista", style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

  Widget _buildWaterSection() {
    return Column(
      children: [
        const Text("¿Cuánta agua bebiste?", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 25),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _waterBtn(FontAwesomeIcons.glassWater, "Vaso", 250),
            _waterBtn(FontAwesomeIcons.bottleWater, "Botella", 500),
            _waterBtn(FontAwesomeIcons.faucetDrip, "Jarra", 1000),
          ],
        ),
        const SizedBox(height: 30),
        ListTile(
          onTap: () => _selectTime(context),
          tileColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          leading: const Icon(Icons.access_time, color: Colors.blue),
          title: Text("Hora del consumo: ${_selectedTime.format(context)}"),
        ),
      ],
    );
  }

  Widget _waterBtn(IconData icon, String label, int ml) {
    return InkWell(
      onTap: () => _addWater(ml, label),
      child: Column(
        children: [
          FaIcon(icon, size: 40, color: Colors.blue),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text("$ml mL", style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }
}