import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FoodRegistrationScreen extends StatefulWidget {
  const FoodRegistrationScreen({super.key});

  @override
  State<FoodRegistrationScreen> createState() => _FoodRegistrationScreenState();
}

class _FoodRegistrationScreenState extends State<FoodRegistrationScreen> {
  final TextEditingController _foodController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController(text: '1');
  
  // 1. "Seleccione unidad" es ahora el valor inicial
  String _selectedUnit = 'Seleccione unidad';
  int _selectedTab = 0; 

  final List<String> _categories = ['Desayuno', 'Almuerzo', 'Cena', 'Snack', 'Agua'];
  
  // 2. Lista de unidades actualizada según tu solicitud
  final List<String> _units = [
    'Seleccione unidad', // Valor por defecto
    'Taza', 
    'Puñado', 
    'Cucharada', 
    'unidad', 
    'Gramos', 
    'Porcion', 
    'mL'
  ];

  List<Map<String, dynamic>> registeredFoods = [];

  void _addFood() {
    // 3. Validación: El nombre no debe estar vacío y la unidad DEBE ser distinta a la inicial
    if (_foodController.text.isEmpty) {
      _showSnackBar('Escribe qué consumiste');
      return;
    }
    
    if (_selectedUnit == 'Seleccione unidad') {
      _showSnackBar('Por favor, selecciona una medida (Taza, Gramos, etc.)');
      return;
    }

    if (_quantityController.text.isEmpty || _quantityController.text == '0') {
      _showSnackBar('La cantidad debe ser mayor a 0');
      return;
    }

    setState(() {
      registeredFoods.add({
        'name': _foodController.text,
        'unit': _selectedUnit,
        'quantity': _quantityController.text,
        'category': _categories[_selectedTab],
      });
      
      // Limpiar para el siguiente registro
      _foodController.clear();
      _quantityController.text = '1';
      _selectedUnit = 'Seleccione unidad'; 
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.redAccent),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF8F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF3E302D)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Registro de comidas',
          style: TextStyle(color: Color(0xFF3E302D), fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // CATEGORÍAS
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

            const Text('¿Qué consumiste?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF3E302D))),
            const SizedBox(height: 10),
            TextField(
              controller: _foodController,
              decoration: InputDecoration(
                hintText: 'Ej: Carne de res, Pan...',
                filled: true,
                fillColor: const Color(0xFFFBC8C2).withValues(alpha: 0.2),
                prefixIcon: const Icon(Icons.search, color: Color(0xFF32A287)),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
              ),
            ),

            const SizedBox(height: 30),

            const Text('¿Cuánto consumiste?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF3E302D))),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildQuantityBtn(Icons.remove, () {
                  int current = int.tryParse(_quantityController.text) ?? 1;
                  if (current > 1) {
                    setState(() => _quantityController.text = (current - 1).toString());
                  }
                }),
                
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  width: 100,
                  height: 80,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFBC8C2), 
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: TextField(
                      controller: _quantityController,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF3E302D)),
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

            const SizedBox(height: 30),

            const Text('Selecciona la medida:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF3E302D))),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: const Color(0xFF32A287).withValues(alpha: 0.3)), 
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedUnit,
                  isExpanded: true,
                  // Estilo gris para la opción por defecto
                  style: const TextStyle(color: Color(0xFF3E302D), fontSize: 16),
                  items: _units.map((String value) {
                    return DropdownMenuItem(
                      value: value, 
                      child: Text(
                        value, 
                        style: TextStyle(
                          color: value == 'Seleccione unidad' ? Colors.grey : const Color(0xFF3E302D)
                        ),
                      )
                    );
                  }).toList(),
                  onChanged: (newValue) => setState(() => _selectedUnit = newValue!),
                ),
              ),
            ),

            const SizedBox(height: 30),

            Center(
              child: TextButton.icon(
                onPressed: _addFood,
                icon: const Icon(Icons.add_circle, color: Color(0xFF32A287)),
                label: const Text('AÑADIR AL REGISTRO', style: TextStyle(color: Color(0xFF32A287), fontWeight: FontWeight.bold)),
              ),
            ),

            const Divider(height: 40),

            if (registeredFoods.isNotEmpty) ...[
              const Text('Resumen de lo añadido:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: registeredFoods.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.white,
                    elevation: 0,
                    margin: const EdgeInsets.only(bottom: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      leading: const Icon(Icons.restaurant_menu, color: Color(0xFF32A287)),
                      title: Text(registeredFoods[index]['name']),
                      subtitle: Text('${registeredFoods[index]['quantity']} ${registeredFoods[index]['unit']} - ${registeredFoods[index]['category']}'),
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

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  if (registeredFoods.isNotEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('¡Registro guardado!')));
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF32A287),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: const Text('CONFIRMAR TODO EL DÍA', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuantityBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(border: Border.all(color: const Color(0xFF32A287)), shape: BoxShape.circle),
        child: Icon(icon, color: const Color(0xFF32A287), size: 24),
      ),
    );
  }
}