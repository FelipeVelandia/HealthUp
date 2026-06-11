import 'package:flutter/material.dart';

class GenomicPage extends StatefulWidget {
  const GenomicPage({super.key});

  @override
  State<GenomicPage> createState() => _GenomicPageState();
}

class _GenomicPageState extends State<GenomicPage> {
  // Guardamos cuál tarjeta está expandida. Usa un identificador único (ej: 'titulo').
  String? _expandedCardTitle;

  @override
  Widget build(BuildContext context) {
    const Color txtColorPrincipal = Color(0xFF3E302D);
    const Color bgCrema = Color(0xFFFDF8F5);

    return Scaffold(
      backgroundColor: bgCrema,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Perfil de riesgo calculado",
          style: TextStyle(color: txtColorPrincipal, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "El motor calculó el nivel de riesgo en cada submódulo a partir de tus datos genotípicos.",
              style: TextStyle(color: Colors.grey, fontSize: 14, height: 1.4),
            ),
            const SizedBox(height: 35),

            // --- SECCIÓN 1: COMPOSICIÓN CORPORAL ---
            _buildSeccionTitulo("Composición corporal"),
            _buildCardRiesgo(
              titulo: "Predisposición a obesidad",
              subtitulo: "Alta predisposición genética. Enfatiza el control calórico.",
              nivelText: "Alto",
              barrasActivas: 4,
              colorNivel: const Color(0xFFFA5A4A),
            ),

            const SizedBox(height: 30),

            // --- SECCIÓN 2: NUTRIGENÉTICA ---
            _buildSeccionTitulo("Nutrigenética"),
            _buildCardRiesgo(
              titulo: "Sensibilidad a carbohidratos",
              subtitulo: "Tolerancia reducida.",
              nivelText: "Moderado",
              barrasActivas: 3,
              colorNivel: const Color(0xFFFFA827),
            ),
            _buildCardRiesgo(
              titulo: "Sensibilidad al Sodio",
              subtitulo: "Evita la sal de mesa y alimentos procesados.",
              nivelText: "Alto",
              barrasActivas: 4,
              colorNivel: const Color(0xFFFA5A4A),
            ),
            _buildCardRiesgo(
              titulo: "Tolerancia a la Lactosa",
              subtitulo: "Tu cuerpo procesa bien los lácteos.",
              nivelText: "Bajo",
              barrasActivas: 1,
              colorNivel: const Color(0xFF32A287),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeccionTitulo(String titulo) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0, left: 4.0),
      child: Text(
        titulo,
        style: const TextStyle(
          color: Color(0xFF3E302D),
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildCardRiesgo({
    required String titulo,
    required String subtitulo,
    required String nivelText,
    required int barrasActivas,
    required Color colorNivel,
  }) {
    final bool isExpanded = _expandedCardTitle == titulo;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.015),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        // Al tocar, si ya estaba expandida se cierra, si no, se abre esta
        onTap: () {
          setState(() {
            _expandedCardTitle = isExpanded ? null : titulo;
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Contenido principal izquierdo
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          titulo,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF3E302D),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          subtitulo,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  
                  // Bloque de la derecha: Barras + Etiqueta
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: List.generate(4, (index) {
                          bool isActive = index < barrasActivas;
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 2),
                            width: 12,
                            height: 5,
                            decoration: BoxDecoration(
                              color: isActive ? colorNivel : Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          color: colorNivel,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          nivelText,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}