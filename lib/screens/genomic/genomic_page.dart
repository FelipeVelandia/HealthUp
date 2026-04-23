import 'package:flutter/material.dart';

class GenomicPage extends StatelessWidget {
  const GenomicPage({super.key});

  // Función para mostrar los detalles del gen
  void _showGeneDetails(BuildContext context, String titulo, String genes) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(titulo, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Genes analizados:", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
            const SizedBox(height: 8),
            Text(genes, style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cerrar", style: TextStyle(color: Color(0xFF32A287))),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> genomicItems = [
      {
        "titulo": "Sensibilidad al Sodio",
        "estado": "Rojo",
        "mensaje": "Evita la sal de mesa y alimentos procesados.",
        "genes": "AGT, AGTR1, ACE"
      },
      {
        "titulo": "Metabolismo de la Cafeína",
        "estado": "Amarillo",
        "mensaje": "Consumo moderado: máximo 1-2 tazas al día.",
        "genes": "CYP1A2, AHR"
      },
      {
        "titulo": "Tolerancia a la Lactosa",
        "estado": "Verde",
        "mensaje": "Tu cuerpo procesa bien los lácteos.",
        "genes": "MCM6"
      },
      {
        "titulo": "Respuesta a Grasas Saturadas",
        "estado": "Rojo",
        "mensaje": "Prioriza grasas saludables como aguacate o nueces.",
        "genes": "APOA2, FTO"
      },
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: ListView.builder(
        // Añadimos un pequeño padding superior ahora que no hay título
        padding: const EdgeInsets.only(top: 20, left: 16, right: 16),
        itemCount: genomicItems.length,
        itemBuilder: (context, index) {
          final item = genomicItems[index];
          
          Color colorSemaforo;
          switch (item['estado']) {
            case "Rojo":
              colorSemaforo = Colors.redAccent;
              break;
            case "Amarillo":
              colorSemaforo = Colors.orangeAccent;
              break;
            default:
              colorSemaforo = Colors.greenAccent.shade700;
          }

          return Card(
            margin: const EdgeInsets.only(bottom: 15),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: Container(
                width: 25,
                height: 25,
                decoration: BoxDecoration(
                  color: colorSemaforo,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: colorSemaforo.withOpacity(0.3),
                      blurRadius: 10,
                      spreadRadius: 2,
                    )
                  ],
                ),
              ),
              title: Text(
                item['titulo'],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(item['mensaje']),
              // Ahora la "i" es un botón funcional
              trailing: IconButton(
                icon: const Icon(Icons.info_outline, color: Colors.grey),
                onPressed: () => _showGeneDetails(
                  context, 
                  item['titulo'], 
                  item['genes']
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}