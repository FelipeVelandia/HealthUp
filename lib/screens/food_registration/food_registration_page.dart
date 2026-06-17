import 'package:flutter/material.dart';
import '../../models/food_item.dart';
import '../../services/food_service.dart';

class FoodRegistrationScreen extends StatefulWidget {
  const FoodRegistrationScreen({super.key});

  @override
  State<FoodRegistrationScreen> createState() => _FoodRegistrationScreenState();
}

class _FoodRegistrationScreenState extends State<FoodRegistrationScreen> {
  final Color customColor = const Color(0xFF32A287);

  List<FoodItem> _allFoods = [];
  FoodItem? _selectedFood;
  bool _isLoading = true;

  final TextEditingController _quantityController = TextEditingController();
  TextEditingController? _autocompleteFieldController;

  String _selectedUnit = 'Seleccione';
  int _selectedTab = 0;
  TimeOfDay _selectedTime = TimeOfDay.now();

  Map<String, List<Map<String, dynamic>>> _registry = {
    'Desayuno': [], 'Almuerzo': [], 'Cena': [], 'Merienda': [], 'Agua': []
  };

  final List<String> _categories = ['Desayuno', 'Almuerzo', 'Cena', 'Merienda', 'Agua'];
  final List<String> _units = ['Seleccione', 'Gramos', 'Taza', 'Puñado', 'Cucharada', 'Unidad', 'Porción', 'mL'];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final data = await FoodService.loadFoods();
    if (mounted) setState(() { _allFoods = data; _isLoading = false; });
  }

  Widget _buildNutr(String label, String value) => Column(
    children: [
      Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
    ],
  );

  void _addFoodToList() {
    String category = _categories[_selectedTab];
    if (_selectedFood == null || _selectedUnit == 'Seleccione' || _quantityController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Completa todos los campos')));
      return;
    }

    setState(() {
      _registry[category]!.add({
        'name': _selectedFood!.name,
        'quantity': _quantityController.text,
        'unit': _selectedUnit,
        'time': _selectedTime.format(context),
      });
      _selectedFood = null;
      _quantityController.clear();
      _selectedUnit = 'Seleccione';
      _autocompleteFieldController?.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    String category = _categories[_selectedTab];
    bool isWater = category == 'Agua';

    return Scaffold(
      appBar: AppBar(title: const Text("Registrar Consumo")),
      body: _isLoading ? const Center(child: CircularProgressIndicator()) : SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            SizedBox(height: 40, child: ListView.builder(scrollDirection: Axis.horizontal, itemCount: _categories.length, itemBuilder: (c, i) => GestureDetector(onTap: () => setState(() => _selectedTab = i), child: Container(margin: const EdgeInsets.only(right: 10), padding: const EdgeInsets.symmetric(horizontal: 20), decoration: BoxDecoration(color: _selectedTab == i ? customColor : Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: customColor)), child: Center(child: Text(_categories[i], style: TextStyle(color: _selectedTab == i ? Colors.white : customColor))))))),
            const SizedBox(height: 20),
            
            // Si es Agua, no mostramos nada (se queda en blanco)
            if (!isWater) ...[
              Autocomplete<FoodItem>(
                displayStringForOption: (item) => item.name,
                optionsBuilder: (text) => text.text.isEmpty ? const Iterable.empty() : _allFoods.where((f) => f.name.toLowerCase().contains(text.text.toLowerCase())),
                onSelected: (item) => setState(() => _selectedFood = item),
                fieldViewBuilder: (c, controller, focus, _) {
                  _autocompleteFieldController = controller;
                  return TextField(controller: controller, focusNode: focus, decoration: InputDecoration(hintText: "¿Qué comiste en $category?", prefixIcon: Icon(Icons.search, color: customColor), border: const OutlineInputBorder(), focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: customColor))));
                },
              ),
              
              if (_selectedFood != null) ...[
                const SizedBox(height: 20),
                Card(elevation: 4, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), child: Padding(padding: const EdgeInsets.all(16), child: Column(children: [
                  Text(_selectedFood!.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const Divider(),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                    _buildNutr("Kcal", "${_selectedFood!.calories.toStringAsFixed(0)}"),
                    _buildNutr("Prot", "${_selectedFood!.protein.toStringAsFixed(1)}g"),
                    _buildNutr("Grasa", "${_selectedFood!.lipids.toStringAsFixed(1)}g"),
                  ]),
                  const SizedBox(height: 10),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                    _buildNutr("Carbs", "${_selectedFood!.carbs.toStringAsFixed(1)}g"),
                    _buildNutr("Fibra", "${_selectedFood!.fiber.toStringAsFixed(1)}g"),
                  ]),
                ]))),
                const SizedBox(height: 20),
                Row(children: [
                  Expanded(child: TextField(controller: _quantityController, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: "Cantidad", border: const OutlineInputBorder(), focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: customColor))))),
                  const SizedBox(width: 10),
                  Expanded(child: DropdownButtonFormField<String>(value: _selectedUnit, items: _units.map((u) => DropdownMenuItem(value: u, child: Text(u))).toList(), onChanged: (v) => setState(() => _selectedUnit = v!), decoration: InputDecoration(labelText: "Medida", border: const OutlineInputBorder(), focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: customColor))))),
                ]),
                const SizedBox(height: 20),
                ListTile(leading: Icon(Icons.access_time, color: customColor), title: Text("Hora: ${_selectedTime.format(context)}"), onTap: () async { final t = await showTimePicker(context: context, initialTime: _selectedTime); if (t != null) setState(() => _selectedTime = t); }),
                ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: customColor, foregroundColor: Colors.white, minimumSize: const Size(double.infinity, 50)), onPressed: _addFoodToList, child: const Text("AÑADIR A LA LISTA")),
                const Divider(height: 40),
                Text("Historial de $category", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ..._registry[category]!.map((item) => ListTile(title: Text(item['name']), subtitle: Text("${item['quantity']} ${item['unit']} - ${item['time']}"))),
              ]
            ]
          ],
        ),
      ),
    );
  }
}