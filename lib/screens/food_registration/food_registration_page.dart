import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:nutrialg_life/services/food_firestore_service.dart';
import '../../models/food_item.dart';
import '../../services/food_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FoodRegistrationScreen extends StatefulWidget {
  const FoodRegistrationScreen({super.key});

  @override
  State<FoodRegistrationScreen> createState() => _FoodRegistrationScreenState();
}

class _FoodRegistrationScreenState extends State<FoodRegistrationScreen> {
  final Color customColor = const Color(0xFFE57373);
  bool _isSubmitting = false;

  List<FoodItem> _allFoods = [];
  FoodItem? _selectedFood;
  bool _isLoading = true;

  final TextEditingController _quantityController = TextEditingController();
  TextEditingController? _autocompleteFieldController;

  String _selectedUnit = 'Seleccione';
  int _selectedTab = 0;
  TimeOfDay _selectedTime = TimeOfDay.now();

  Map<String, List<Map<String, dynamic>>> _registry = {
    'Desayuno': [],
    'Almuerzo': [],
    'Cena': [],
    'Merienda': [],
    'Agua': []
  };

  final List<String> _categories = [
    'Desayuno',
    'Almuerzo',
    'Cena',
    'Merienda',
    'Agua'
  ];
  final List<String> _units = [
    'Seleccione',
    'Gramos',
    'Taza',
    'Puñado',
    'Cucharada',
    'Unidad',
    'Porción',
    'mL'
  ];

  // Lista local para mostrar lo que se va registrando antes de guardar
  List<Map<String, dynamic>> _tempRegistry = [];

  int _waterAddedInSession = 0;

  void _addWater(int amount, String type) {
    setState(() {
      _tempRegistry.add({
        'name': 'Agua ($type)',
        'quantity': amount.toString(),
        'unit': 'mL',
        'time': _selectedTime.format(context),
        'isWater': true,
      });
      // Acumulamos el agua añadida temporalmente
      _waterAddedInSession += amount;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text('¡+$amount mL de agua añadidos! 💧'),
          duration: const Duration(seconds: 1)),
    );
  }

  // NUEVO: Función para persistir el agua acumulada en el disco duro
  Future<void> _saveWaterToStorage() async {
    if (_waterAddedInSession <= 0) return;
    final prefs = await SharedPreferences.getInstance();
    // Leemos lo que ya existía hoy y le sumamos lo nuevo
    final int currentSavedWater = prefs.getInt('user_consumed_water_key') ?? 0;
    await prefs.setInt(
        'user_consumed_water_key', currentSavedWater + _waterAddedInSession);
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null) setState(() => _selectedTime = picked);
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final data = await FoodService.loadFoods();
    if (mounted)
      setState(() {
        _allFoods = data;
        _isLoading = false;
      });
  }

  Widget _buildNutr(String label, String value) => Column(
        children: [
          Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
          Text(value,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        ],
      );

  void _addFoodToList() {
    String category = _categories[_selectedTab];

    // 1. Validación básica de selección
    if (_selectedFood == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Por favor, selecciona un alimento primero 🔍')),
      );
      return;
    }

    if (_selectedUnit == 'Seleccione') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Por favor, selecciona una unidad de medida 📏')),
      );
      return;
    }

    // 2. Validación de texto vacío
    final String quantityText = _quantityController.text.trim();
    if (quantityText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, ingresa una cantidad 🔢')),
      );
      return;
    }

    // 3. Validación de conversión numérica y valores mayores a cero
    final double? parsedQuantity = double.tryParse(quantityText);
    if (parsedQuantity == null || parsedQuantity <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('La cantidad debe ser un número mayor a cero ⚠️')),
      );
      return;
    }

    // 4. Si pasa todas las validaciones, se agrega al registro
    setState(() {
      _registry[category]!.add({
        'name': _selectedFood!.name,
        // Guardamos el número formateado de manera limpia (ej: "2" o "2.5")
        'quantity': parsedQuantity % 1 == 0
            ? parsedQuantity.toInt().toString()
            : parsedQuantity.toString(),
        'unit': _selectedUnit,
        'time': _selectedTime.format(context),

        // Datos nutricionales para el historial
        'calories': _selectedFood!.calories,
        'protein': _selectedFood!.protein,
        'lipids': _selectedFood!.lipids,
        'carbs': _selectedFood!.carbs,
        'fiber': _selectedFood!.fiber,
      });

      // Limpieza de campos post-guardado exitoso
      _selectedFood = null;
      _quantityController.clear();
      _selectedUnit = 'Seleccione';
      _autocompleteFieldController?.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('¡Alimento añadido con éxito! 🍽️'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color greenPrimary = Color(0xFFE57373);
    String category = _categories[_selectedTab];
    bool isWater = category == 'Agua';

    return Scaffold(
      appBar: AppBar(title: const Text("Registrar Consumo")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // 1. Selector de Categorías (Tabs) - SIEMPRE VISIBLE
                  SizedBox(
                      height: 40,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _categories.length,
                          itemBuilder: (c, i) => GestureDetector(
                              onTap: () => setState(() => _selectedTab = i),
                              child: Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  decoration: BoxDecoration(
                                      color: _selectedTab == i
                                          ? customColor
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(color: customColor)),
                                  child: Center(
                                      child: Text(_categories[i],
                                          style: TextStyle(
                                              color: _selectedTab == i
                                                  ? Colors.white
                                                  : customColor))))))),
                  const SizedBox(height: 25),

                  // 2. RENDERIZADO DINÁMICO SEGÚN LA PESTAÑA SELECCIONADA
                  if (isWater) ...[
                    // Sección exclusiva de Agua
                    _buildWaterSection(),

                    // Resumen temporal de agua (Solo si hay agua agregada en la sesión)
                    if (_tempRegistry.isNotEmpty) ...[
                      const Divider(height: 40),
                      const Text("Resumen actual:",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      ..._tempRegistry.map((item) => ListTile(
                            leading: Icon(
                                item['isWater'] == true
                                    ? Icons.water_drop
                                    : Icons.restaurant,
                                color: item['isWater'] == true
                                    ? Colors.blue
                                    : greenPrimary),
                            title: Text(item['name']),
                            subtitle: Text(
                                "${item['quantity']} ${item['unit']} - ${item['time']}"),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete_outline,
                                  color: Colors.red),
                              onPressed: () =>
                                  setState(() => _tempRegistry.remove(item)),
                            ),
                          )),
                    ],
                  ] else ...[
                    // Sección exclusiva de Alimentos (Buscador, Tarjeta, Formulario e Historial)
                    Autocomplete<FoodItem>(
                      displayStringForOption: (item) => item.name,
                      optionsBuilder: (text) => text.text.isEmpty
                          ? const Iterable.empty()
                          : _allFoods.where((f) => f.name
                              .toLowerCase()
                              .contains(text.text.toLowerCase())),
                      onSelected: (item) =>
                          setState(() => _selectedFood = item),
                      fieldViewBuilder: (c, controller, focus, _) {
                        _autocompleteFieldController = controller;
                        return TextField(
                            controller: controller,
                            focusNode: focus,
                            decoration: InputDecoration(
                                hintText: "¿Qué comiste en $category?",
                                prefixIcon:
                                    Icon(Icons.search, color: customColor),
                                border: const OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: customColor))));
                      },
                    ),
                    if (_selectedFood != null) ...[
                      const SizedBox(height: 20),
                      Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(children: [
                                Text(_selectedFood!.name,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16)),
                                const Divider(),
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      _buildNutr("Kcal",
                                          "${_selectedFood!.calories.toStringAsFixed(0)}"),
                                      _buildNutr("Prot",
                                          "${_selectedFood!.protein.toStringAsFixed(1)}g"),
                                      _buildNutr("Grasa",
                                          "${_selectedFood!.lipids.toStringAsFixed(1)}g"),
                                    ]),
                                const SizedBox(height: 10),
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      _buildNutr("Carbs",
                                          "${_selectedFood!.carbs.toStringAsFixed(1)}g"),
                                      _buildNutr("Fibra",
                                          "${_selectedFood!.fiber.toStringAsFixed(1)}g"),
                                    ]),
                              ]))),
                      const SizedBox(height: 20),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              child: TextField(
                                  controller: _quantityController,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          decimal: true),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'^\d*\.?\d*')),
                                  ],
                                  decoration: InputDecoration(
                                      labelText: "Cantidad",
                                      hintText: "0.00",
                                      helperText: "Use punto para decimales",
                                      border: const OutlineInputBorder(),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: customColor))))),
                          const SizedBox(width: 10),
                          Expanded(
                              child: DropdownButtonFormField<String>(
                                  value: _selectedUnit,
                                  items: _units
                                      .map((u) => DropdownMenuItem(
                                          value: u, child: Text(u)))
                                      .toList(),
                                  onChanged: (v) =>
                                      setState(() => _selectedUnit = v!),
                                  decoration: InputDecoration(
                                      labelText: "Medida",
                                      helperText: " ",
                                      border: const OutlineInputBorder(),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: customColor))))),
                        ],
                      ),
                      const SizedBox(height: 20),
                      ListTile(
                          leading: Icon(Icons.access_time, color: customColor),
                          title: Text("Hora: ${_selectedTime.format(context)}"),
                          onTap: () async {
                            final t = await showTimePicker(
                                context: context, initialTime: _selectedTime);
                            if (t != null) setState(() => _selectedTime = t);
                          }),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: customColor,
                              foregroundColor: Colors.white,
                              minimumSize: const Size(double.infinity, 50)),
                          onPressed: () {
                            _addFoodToList();
                          },
                          child: const Text("AÑADIR A LA LISTA")),
                    ],
                    const Divider(height: 40),
                    Text("Historial de $category",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 10),
                    if (_registry[category]!.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                            "No hay alimentos registrados en esta categoría hoy.",
                            style: TextStyle(color: Colors.grey, fontSize: 13)),
                      )
                    else
                      ..._registry[category]!.map((item) => ListTile(
                            isThreeLine: true,
                            leading: Icon(Icons.restaurant,
                                color: customColor, size: 20),
                            title: Text(item['name'],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            subtitle: Text(
                                "${item['quantity']} ${item['unit']} - ${item['time']}\n"
                                "${item['calories']?.toStringAsFixed(0) ?? 0} Kcal | "
                                "P: ${item['protein'] ?? 0}g | "
                                "G: ${item['lipids'] ?? 0}g | "
                                "C: ${item['carbs'] ?? 0}g | "
                                "F: ${item['fiber'] ?? 0}g",
                                style:
                                    const TextStyle(fontSize: 11, height: 1.4)),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete_outline,
                                  color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  _registry[category]!.remove(item);
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Alimento eliminado del historial'),
                                    duration: Duration(seconds: 1),
                                  ),
                                );
                              },
                            ),
                          )),
                  ],
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: greenPrimary,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                      ),
                      onPressed: _isSubmitting
                          ? null
                          : () async {
                              setState(() => _isSubmitting = true);
                              try {
                                // OBTENEMOS EL ID DEL USUARIO ACTUAL DE FIREBASE AUTH
                                final User? currentUser =
                                    FirebaseAuth.instance.currentUser;

                                if (currentUser == null) {
                                  throw Exception(
                                      "No se encontró ningún usuario autenticado.");
                                }

                                // Enviamos el historial completo a la nube pasando su UID real
                                await FoodFirestoreService.uploadRegistry(
                                  foodRegistry: _registry,
                                  waterAmount: _waterAddedInSession,
                                  userId: currentUser
                                      .uid, // Usamos el ID único del usuario autenticado
                                );

                                // Persistencia Local
                                await _saveWaterToStorage();

                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          '¡Historial sincronizado en la nube con éxito! ☁️🎉'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                  context.pop();
                                }
                              } catch (error) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Error al sincronizar: $error ❌'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              } finally {
                                if (mounted) {
                                  setState(() => _isSubmitting = false);
                                }
                              }
                            },
                      child: _isSubmitting
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("GUARDAR TODO",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildWaterSection() {
    return Column(
      children: [
        const Text("¿Cuánta agua bebiste?",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 25),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _waterBtn(FontAwesomeIcons.glassWater, "Vaso", 220),
            _waterBtn(FontAwesomeIcons.bottleWater, "Botella", 500),
            _waterBtn(FontAwesomeIcons.faucetDrip, "Jarra", 1000),
          ],
        ),
        const SizedBox(height: 30),
        ListTile(
          onTap: () => _selectTime(context),
          tileColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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
          Text("$ml mL",
              style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }
}
