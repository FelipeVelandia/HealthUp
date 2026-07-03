import 'package:flutter/material.dart';
import 'package:nutrialg_life/services/database_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailsPage extends StatelessWidget {
  DetailsPage({super.key});
  final firestore = DatabaseService();

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<DatabaseService>(context).user;

    DateTime now = DateTime.now();
    int dayNumber = now.weekday;

    if (dayNumber == DateTime.monday) {
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.surface),
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: FutureBuilder(
                future: Future.wait([
                  firestore.getLunes(user!.uid),
                  SharedPreferences.getInstance()
                ]),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.data == null) {
                      return const Text('no data');
                    } else {
                      switch (snapshot.data[1].getString('Label')) {
                        // ... dentro de tu bloque switch u operación condicional
                        case 'desayuno':
                          final index = snapshot.data[1].getInt('Index');
                          final listaComida = snapshot.data[0]?.desayuno;
                          final item = (listaComida != null &&
                                  index < listaComida.length)
                              ? listaComida[index]
                              : null;
                          return _buildNutrientCard(item);

                        case 'media':
                          final index = snapshot.data[1].getInt('Index');
                          final listaComida = snapshot.data[0]
                              ?.media; // Ajusta según el nombre real en tu modelo (ej: mediaManana)
                          final item = (listaComida != null &&
                                  index < listaComida.length)
                              ? listaComida[index]
                              : null;
                          return _buildNutrientCard(item);

                        case 'almuerzo':
                          final index = snapshot.data[1].getInt('Index');
                          final listaComida = snapshot.data[0]?.almuerzo;
                          final item = (listaComida != null &&
                                  index < listaComida.length)
                              ? listaComida[index]
                              : null;
                          return _buildNutrientCard(item);

                        case 'merienda':
                          final index = snapshot.data[1].getInt('Index');
                          final listaComida = snapshot.data[0]?.merienda;
                          final item = (listaComida != null &&
                                  index < listaComida.length)
                              ? listaComida[index]
                              : null;
                          return _buildNutrientCard(item);

                        case 'cena':
                          final index = snapshot.data[1].getInt('Index');
                          final listaComida = snapshot.data[0]?.cena;
                          final item = (listaComida != null &&
                                  index < listaComida.length)
                              ? listaComida[index]
                              : null;
                          return _buildNutrientCard(item);

                        default:
                          return const Text('Error');
                      }
                    }
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Text('Loading');
                  } else {
                    return const Text('Error');
                  }
                })),
      );
    } else if (dayNumber == DateTime.tuesday) {
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.surface),
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: FutureBuilder(
                future: Future.wait([
                  firestore.getMartes(user!.uid),
                  SharedPreferences.getInstance()
                ]),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.data == null) {
                      return const Text('no data');
                    } else {
                      switch (snapshot.data[1].getString('Label')) {
                        // ... dentro de tu bloque switch u operación condicional
                        case 'desayuno':
                          final index = snapshot.data[1].getInt('Index');
                          final listaComida = snapshot.data[0]?.desayuno;
                          final item = (listaComida != null &&
                                  index < listaComida.length)
                              ? listaComida[index]
                              : null;
                          return _buildNutrientCard(item);

                        case 'media':
                          final index = snapshot.data[1].getInt('Index');
                          final listaComida = snapshot.data[0]
                              ?.media; // Ajusta según el nombre real en tu modelo (ej: mediaManana)
                          final item = (listaComida != null &&
                                  index < listaComida.length)
                              ? listaComida[index]
                              : null;
                          return _buildNutrientCard(item);

                        case 'almuerzo':
                          final index = snapshot.data[1].getInt('Index');
                          final listaComida = snapshot.data[0]?.almuerzo;
                          final item = (listaComida != null &&
                                  index < listaComida.length)
                              ? listaComida[index]
                              : null;
                          return _buildNutrientCard(item);

                        case 'merienda':
                          final index = snapshot.data[1].getInt('Index');
                          final listaComida = snapshot.data[0]?.merienda;
                          final item = (listaComida != null &&
                                  index < listaComida.length)
                              ? listaComida[index]
                              : null;
                          return _buildNutrientCard(item);

                        case 'cena':
                          final index = snapshot.data[1].getInt('Index');
                          final listaComida = snapshot.data[0]?.cena;
                          final item = (listaComida != null &&
                                  index < listaComida.length)
                              ? listaComida[index]
                              : null;
                          return _buildNutrientCard(item);

                        default:
                          return const Text('Error');
                      }
                    }
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Text('Loading');
                  } else {
                    return const Text('Error');
                  }
                })),
      );
    } else if (dayNumber == DateTime.wednesday) {
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.surface),
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: FutureBuilder(
                future: Future.wait([
                  firestore.getMiercoles(user!.uid),
                  SharedPreferences.getInstance()
                ]),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.data == null) {
                      return const Text('no data');
                    } else {
                      switch (snapshot.data[1].getString('Label')) {
                        // ... dentro de tu bloque switch u operación condicional
                        case 'desayuno':
                          final index = snapshot.data[1].getInt('Index');
                          final listaComida = snapshot.data[0]?.desayuno;
                          final item = (listaComida != null &&
                                  index < listaComida.length)
                              ? listaComida[index]
                              : null;
                          return _buildNutrientCard(item);

                        case 'media':
                          final index = snapshot.data[1].getInt('Index');
                          final listaComida = snapshot.data[0]
                              ?.media; // Ajusta según el nombre real en tu modelo (ej: mediaManana)
                          final item = (listaComida != null &&
                                  index < listaComida.length)
                              ? listaComida[index]
                              : null;
                          return _buildNutrientCard(item);

                        case 'almuerzo':
                          final index = snapshot.data[1].getInt('Index');
                          final listaComida = snapshot.data[0]?.almuerzo;
                          final item = (listaComida != null &&
                                  index < listaComida.length)
                              ? listaComida[index]
                              : null;
                          return _buildNutrientCard(item);

                        case 'merienda':
                          final index = snapshot.data[1].getInt('Index');
                          final listaComida = snapshot.data[0]?.merienda;
                          final item = (listaComida != null &&
                                  index < listaComida.length)
                              ? listaComida[index]
                              : null;
                          return _buildNutrientCard(item);

                        case 'cena':
                          final index = snapshot.data[1].getInt('Index');
                          final listaComida = snapshot.data[0]?.cena;
                          final item = (listaComida != null &&
                                  index < listaComida.length)
                              ? listaComida[index]
                              : null;
                          return _buildNutrientCard(item);

                        default:
                          return const Text('Error');
                      }
                    }
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Text('Loading');
                  } else {
                    return const Text('Error');
                  }
                })),
      );
    } else if (dayNumber == DateTime.thursday) {
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.surface),
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: FutureBuilder(
                future: Future.wait([
                  firestore.getJueves(user!.uid),
                  SharedPreferences.getInstance()
                ]),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.data == null) {
                      return const Text('no data');
                    } else {
                      switch (snapshot.data[1].getString('Label')) {
                        // ... dentro de tu bloque switch u operación condicional
                        case 'desayuno':
                          final index = snapshot.data[1].getInt('Index');
                          final listaComida = snapshot.data[0]?.desayuno;
                          final item = (listaComida != null &&
                                  index < listaComida.length)
                              ? listaComida[index]
                              : null;
                          return _buildNutrientCard(item);

                        case 'media':
                          final index = snapshot.data[1].getInt('Index');
                          final listaComida = snapshot.data[0]
                              ?.media; // Ajusta según el nombre real en tu modelo (ej: mediaManana)
                          final item = (listaComida != null &&
                                  index < listaComida.length)
                              ? listaComida[index]
                              : null;
                          return _buildNutrientCard(item);

                        case 'almuerzo':
                          final index = snapshot.data[1].getInt('Index');
                          final listaComida = snapshot.data[0]?.almuerzo;
                          final item = (listaComida != null &&
                                  index < listaComida.length)
                              ? listaComida[index]
                              : null;
                          return _buildNutrientCard(item);

                        case 'merienda':
                          final index = snapshot.data[1].getInt('Index');
                          final listaComida = snapshot.data[0]?.merienda;
                          final item = (listaComida != null &&
                                  index < listaComida.length)
                              ? listaComida[index]
                              : null;
                          return _buildNutrientCard(item);

                        case 'cena':
                          final index = snapshot.data[1].getInt('Index');
                          final listaComida = snapshot.data[0]?.cena;
                          final item = (listaComida != null &&
                                  index < listaComida.length)
                              ? listaComida[index]
                              : null;
                          return _buildNutrientCard(item);

                        default:
                          return const Text('Error');
                      }
                    }
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Text('Loading');
                  } else {
                    return const Text('Error');
                  }
                })),
      );
    } else if (dayNumber == DateTime.friday) {
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.surface),
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: FutureBuilder(
                future: Future.wait([
                  firestore.getViernes(user!.uid),
                  SharedPreferences.getInstance()
                ]),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.data == null) {
                      return const Text('no data');
                    } else {
                      switch (snapshot.data[1].getString('Label')) {
                        // ... dentro de tu bloque switch u operación condicional
                        case 'desayuno':
                          final index = snapshot.data[1].getInt('Index');
                          final listaComida = snapshot.data[0]?.desayuno;
                          final item = (listaComida != null &&
                                  index < listaComida.length)
                              ? listaComida[index]
                              : null;
                          return _buildNutrientCard(item);

                        case 'media':
                          final index = snapshot.data[1].getInt('Index');
                          final listaComida = snapshot.data[0]
                              ?.media; // Ajusta según el nombre real en tu modelo (ej: mediaManana)
                          final item = (listaComida != null &&
                                  index < listaComida.length)
                              ? listaComida[index]
                              : null;
                          return _buildNutrientCard(item);

                        case 'almuerzo':
                          final index = snapshot.data[1].getInt('Index');
                          final listaComida = snapshot.data[0]?.almuerzo;
                          final item = (listaComida != null &&
                                  index < listaComida.length)
                              ? listaComida[index]
                              : null;
                          return _buildNutrientCard(item);

                        case 'merienda':
                          final index = snapshot.data[1].getInt('Index');
                          final listaComida = snapshot.data[0]?.merienda;
                          final item = (listaComida != null &&
                                  index < listaComida.length)
                              ? listaComida[index]
                              : null;
                          return _buildNutrientCard(item);

                        case 'cena':
                          final index = snapshot.data[1].getInt('Index');
                          final listaComida = snapshot.data[0]?.cena;
                          final item = (listaComida != null &&
                                  index < listaComida.length)
                              ? listaComida[index]
                              : null;
                          return _buildNutrientCard(item);

                        default:
                          return const Text('Error');
                      }
                    }
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Text('Loading');
                  } else {
                    return const Text('Error');
                  }
                })),
      );
    } else if (dayNumber == DateTime.saturday) {
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.surface),
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: FutureBuilder(
                future: Future.wait([
                  firestore.getSabado(user!.uid),
                  SharedPreferences.getInstance()
                ]),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.data == null) {
                      return const Text('no data');
                    } else {
                      switch (snapshot.data[1].getString('Label')) {
                        // ... dentro de tu bloque switch u operación condicional
                        case 'desayuno':
                          final index = snapshot.data[1].getInt('Index');
                          final listaComida = snapshot.data[0]?.desayuno;
                          final item = (listaComida != null &&
                                  index < listaComida.length)
                              ? listaComida[index]
                              : null;
                          return _buildNutrientCard(item);

                        case 'media':
                          final index = snapshot.data[1].getInt('Index');
                          final listaComida = snapshot.data[0]
                              ?.media; // Ajusta según el nombre real en tu modelo (ej: mediaManana)
                          final item = (listaComida != null &&
                                  index < listaComida.length)
                              ? listaComida[index]
                              : null;
                          return _buildNutrientCard(item);

                        case 'almuerzo':
                          final index = snapshot.data[1].getInt('Index');
                          final listaComida = snapshot.data[0]?.almuerzo;
                          final item = (listaComida != null &&
                                  index < listaComida.length)
                              ? listaComida[index]
                              : null;
                          return _buildNutrientCard(item);

                        case 'merienda':
                          final index = snapshot.data[1].getInt('Index');
                          final listaComida = snapshot.data[0]?.merienda;
                          final item = (listaComida != null &&
                                  index < listaComida.length)
                              ? listaComida[index]
                              : null;
                          return _buildNutrientCard(item);

                        case 'cena':
                          final index = snapshot.data[1].getInt('Index');
                          final listaComida = snapshot.data[0]?.cena;
                          final item = (listaComida != null &&
                                  index < listaComida.length)
                              ? listaComida[index]
                              : null;
                          return _buildNutrientCard(item);

                        default:
                          return const Text('Error');
                      }
                    }
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Text('Loading');
                  } else {
                    return const Text('Error');
                  }
                })),
      );
    } else {
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.surface),
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: FutureBuilder(
                future: Future.wait([
                  firestore.getDomingo(user!.uid),
                  SharedPreferences.getInstance()
                ]),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.data == null) {
                      return const Text('no data');
                    } else {
                      switch (snapshot.data[1].getString('Label')) {
                        // ... dentro de tu bloque switch u operación condicional
                        case 'desayuno':
                          final index = snapshot.data[1].getInt('Index');
                          final listaComida = snapshot.data[0]?.desayuno;
                          final item = (listaComida != null &&
                                  index < listaComida.length)
                              ? listaComida[index]
                              : null;
                          return _buildNutrientCard(item);

                        case 'media':
                          final index = snapshot.data[1].getInt('Index');
                          final listaComida = snapshot.data[0]
                              ?.media; // Ajusta según el nombre real en tu modelo (ej: mediaManana)
                          final item = (listaComida != null &&
                                  index < listaComida.length)
                              ? listaComida[index]
                              : null;
                          return _buildNutrientCard(item);

                        case 'almuerzo':
                          final index = snapshot.data[1].getInt('Index');
                          final listaComida = snapshot.data[0]?.almuerzo;
                          final item = (listaComida != null &&
                                  index < listaComida.length)
                              ? listaComida[index]
                              : null;
                          return _buildNutrientCard(item);

                        case 'merienda':
                          final index = snapshot.data[1].getInt('Index');
                          final listaComida = snapshot.data[0]?.merienda;
                          final item = (listaComida != null &&
                                  index < listaComida.length)
                              ? listaComida[index]
                              : null;
                          return _buildNutrientCard(item);

                        case 'cena':
                          final index = snapshot.data[1].getInt('Index');
                          final listaComida = snapshot.data[0]?.cena;
                          final item = (listaComida != null &&
                                  index < listaComida.length)
                              ? listaComida[index]
                              : null;
                          return _buildNutrientCard(item);

                        default:
                          return const Text('Error');
                      }
                    }
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Text('Loading');
                  } else {
                    return const Text('Error');
                  }
                })),
      );
    }
  }

  Widget _buildNutrientRow(String label, String value,
      {bool isHighlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[800],
                    fontWeight:
                        isHighlight ? FontWeight.bold : FontWeight.normal),
              ),
              Text(
                value,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color:
                        isHighlight ? const Color(0xFF32A287) : Colors.black),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Divider(color: Colors.grey[200], height: 1),
        ],
      ),
    );
  }

  Widget _buildNutrientCard(dynamic item) {
    if (item == null) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Información nutricional no disponible',
            style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4)),
        ],
      ),
      // NUEVO: Agregamos scroll interno para evitar el desborde (Bottom Overflowed)
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Composición Nutricional',
              style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5),
            ),
            const SizedBox(height: 16),

            // Macronutrientes Base
            _buildNutrientRow(
                'Energía (Kcal)', '${item['energiac'] ?? '-'} Kcal'),
            _buildNutrientRow('Proteína', '${item['proteina'] ?? '-'} g'),
            _buildNutrientRow('Lípidos', '${item['lipidos'] ?? '-'} g'),
            _buildNutrientRow(
                'Carbohidratos Totales', '${item['carbohidratos'] ?? '-'} g'),
            const Divider(height: 24),

            // Minerales
            _buildNutrientRow('Calcio (mg)', '${item['calcio'] ?? '-'} mg'),
            _buildNutrientRow('Hierro (mg)', '${item['hierro'] ?? '-'} mg'),
            _buildNutrientRow('Sodio (mg)', '${item['sodio'] ?? '-'} mg'),
            _buildNutrientRow('Fósforo (mg)', '${item['fosforo'] ?? '-'} mg'),
            _buildNutrientRow('Yodo (mcg)', '${item['yodo'] ?? '-'} mcg'),
            _buildNutrientRow('Zinc (mg)', '${item['zinc'] ?? '-'} mg'),
            _buildNutrientRow('Magnesio (mg)', '${item['magnesio'] ?? '-'} mg'),
            _buildNutrientRow('Potasio (mg)', '${item['potasio'] ?? '-'} mg'),
            const Divider(height: 24),

            // Vitaminas
            _buildNutrientRow('Tiamina (mg)', '${item['tiamina'] ?? '-'} mg'),
            _buildNutrientRow(
                'Riboflavina (mg)', '${item['riboflavina'] ?? '-'} mg'),
            _buildNutrientRow('Niacina (mg)', '${item['niacina'] ?? '-'} mg'),
            _buildNutrientRow('Folatos (mcg)', '${item['folatos'] ?? '-'} mcg'),
            _buildNutrientRow(
                'Vitamina B12 (mcg)', '${item['vitaminaB12'] ?? '-'} mcg'),
            _buildNutrientRow(
                'Vitamina C (mg)', '${item['vitaminaC'] ?? '-'} mg'),
            _buildNutrientRow(
                'Vitamina A (ER)', '${item['vitaminaA'] ?? '-'} ER'),
            const Divider(height: 24),

            // Perfil de Grasas y Colesterol
            _buildNutrientRow(
                'Grasa Saturada (g)', '${item['grasa_saturada'] ?? '-'} g'),
            _buildNutrientRow('Grasa Monoinsaturada (g)',
                '${item['grasa_monoinsaturada'] ?? '-'} g'),
            _buildNutrientRow('Grasa Poliinsaturada (g)',
                '${item['grasa_poliinsaturada'] ?? '-'} g'),
            _buildNutrientRow(
                'Colesterol (mg)', '${item['colesterol'] ?? '-'} mg'),
          ],
        ),
      ),
    );
  }
}
