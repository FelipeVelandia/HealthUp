import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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

  final List<String> _categories = ['Desayuno', 'Almuerzo', 'Cena', 'Merienda', 'Agua'];
  
  final List<String> _units = [
    'Seleccione unidad', 'Taza', 'Puñado', 'Cucharada', 'unidad', 'Gramos', 'Porcion', 'mL'
  ];

  List<Map<String, dynamic>> registeredFoods = [];

  // Función para registrar agua rápidamente
  void _addWater(int amount) {
    setState(() {
      registeredFoods.add({
        'name': 'Agua',
        'unit': 'mL',
        'quantity': amount.toString(),
        'category': 'Agua',
        'time': TimeOfDay.now().format(context), 
      });
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('¡+$amount mL registrados! 💧'),
        backgroundColor: Colors.blueAccent,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _addFood() {
    if (_foodController.text.isEmpty) {
      _showSnackBar('Escribe qué consumiste');
      return;
    }
    if (_selectedUnit == 'Seleccione unidad') {
      _showSnackBar('Por favor, selecciona una medida');
      return;
    }

    setState(() {
      registeredFoods.add({
        'name': _foodController.text,
        'unit': _selectedUnit,
        'quantity': _quantityController.text,
        'category': _categories[_selectedTab],
        'time': _selectedTime.format(context), 
      });
      _foodController.clear();
      _quantityController.text = '1';
      _selectedUnit = 'Seleccione unidad'; 
    });
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null) setState(() => _selectedTime = picked);
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.redAccent),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isWaterTab = _categories[_selectedTab] == 'Agua';

    return Scaffold(
      backgroundColor: const Color(0xFFFDF8F5),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // BARRA DE CATEGORÍAS
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => setState(() => _selectedTab = index),
                    child: Container(
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                        color: _selectedTab == index ? const Color(0xFF32A287) : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFF32A287)),
                      ),
                      child: Text(
                        _categories[index],
                        style: TextStyle(
                          color: _selectedTab == index ? Colors.white : const Color(0xFF32A287),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            
            const SizedBox(height: 30),

            // CONTENIDO DINÁMICO
            isWaterTab ? _buildWaterQuickAction() : _buildFoodForm(),

            const Divider(height: 60),

            // RESUMEN
            if (registeredFoods.isNotEmpty) ...[
              const Text('Resumen del día:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: registeredFoods.length,
                itemBuilder: (context, index) {
                  final item = registeredFoods[index];
                  bool isWater = item['category'] == 'Agua';
                  return Card(
                    color: Colors.white,
                    elevation: 0,
                    margin: const EdgeInsets.only(bottom: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), 
                      side: BorderSide(color: Colors.grey.shade100),
                    ),
                    child: ListTile(
                      leading: FaIcon(
                        isWater ? FontAwesomeIcons.droplet : FontAwesomeIcons.utensils, 
                        color: isWater ? Colors.blue : const Color(0xFF32A287),
                        size: 20,
                      ),
                      title: Text(item['name']),
                      subtitle: Text('${item['quantity']} ${item['unit']} • ${item['category']} • ${item['time']}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                        onPressed: () => setState(() => registeredFoods.removeAt(index)),
                      ),
                    ),
                  );
                },
              ),
            ],

            const SizedBox(height: 30),

            // BOTÓN GUARDAR TODO
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF32A287),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: const Text('CONFIRMAR TODO EL DÍA', 
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- SECCIÓN DE AGUA ---
  Widget _buildWaterQuickAction() {
    return Column(
      children: [
        const Text("¿Cuánta agua bebiste?", 
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF3E302D))),
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _waterOption(FontAwesomeIcons.glassWater, "Vaso", "250 mL", 250),
            _waterOption(FontAwesomeIcons.bottleWater, "Botella", "500 mL", 500),
            _waterOption(FontAwesomeIcons.faucetDrip, "Jarra", "1 L", 1000),
          ],
        ),
        const SizedBox(height: 40),
        const Text("Toca un recipiente para añadirlo rápidamente", 
          style: TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }

  Widget _waterOption(IconData icon, String title, String subtitle, int ml) {
    return InkWell(
      onTap: () => _addWater(ml),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 100,
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.blue.withOpacity(0.1)),
        ),
        child: Column(
          children: [
            FaIcon(icon, color: Colors.blue, size: 35),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(subtitle, style: const TextStyle(color: Colors.blue, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  // --- FORMULARIO DE COMIDA ---
  Widget _buildFoodForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('¿Qué consumiste?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        TextField(
          controller: _foodController,
          decoration: InputDecoration(
            hintText: 'Ej: Carne de res, Pan...',
            filled: true,
            fillColor: const Color(0xFFFBC8C2).withOpacity(0.2),
            prefixIcon: const Icon(Icons.search, color: Color(0xFF32A287)),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
          ),
        ),
        const SizedBox(height: 25),
        const Text('¿Cuánto consumiste?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildQuantityBtn(Icons.remove, () {
              int current = int.tryParse(_quantityController.text) ?? 1;
              if (current > 1) setState(() => _quantityController.text = (current - 1).toString());
            }),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              width: 70, height: 70,
              decoration: const BoxDecoration(color: Color(0xFFFBC8C2), shape: BoxShape.circle),
              child: Center(
                child: TextField(
                  controller: _quantityController,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  decoration: const InputDecoration(border: InputBorder.none),
                ),
              ),
            ),
            _buildQuantityBtn(Icons.add, () {
              int current = int.tryParse(_quantityController.text) ?? 0;
              setState(() => _quantityController.text = (current + 1).toString());
            }),
          ],
        ),
        const SizedBox(height: 25),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: const Color(0xFF32A287).withOpacity(0.3)), 
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedUnit,
              isExpanded: true,
              items: _units.map((u) => DropdownMenuItem(value: u, child: Text(u))).toList(),
              onChanged: (v) => setState(() => _selectedUnit = v!),
            ),
          ),
        ),
        const SizedBox(height: 20),
        ListTile(
          onTap: () => _selectTime(context),
          leading: const Icon(Icons.access_time, color: Color(0xFF32A287)),
          title: Text("Hora: ${_selectedTime.format(context)}"),
          tileColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        const SizedBox(height: 20),
        Center(
          child: ElevatedButton.icon(
            onPressed: _addFood,
            icon: const Icon(Icons.add),
            label: const Text("AÑADIR AL REGISTRO"),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF32A287), foregroundColor: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildQuantityBtn(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(border: Border.all(color: const Color(0xFF32A287)), shape: BoxShape.circle),
        child: Icon(icon, color: const Color(0xFF32A287)),
      ),
    );
  }
}