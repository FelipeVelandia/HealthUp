import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nutrialg_life/services/database_service.dart';

class GenomicPage extends StatefulWidget {
  const GenomicPage({super.key});

  @override
  State<GenomicPage> createState() => _GenomicPageState();
}

class _GenomicPageState extends State<GenomicPage> {
  final firestore = DatabaseService();

  // Helper para automatizar las barras activas y los colores según el nivelText
  Map<String, dynamic> _getVisualConfigByNivel(String nivel) {
    final String cleanNivel = nivel.trim().toLowerCase();

    if (cleanNivel == 'alto') {
      return {
        'barras': 4,
        'color': const Color(0xFFFA5A4A), // Rojo 🔴
      };
    } else if (cleanNivel == 'moderado' || cleanNivel == 'medio') {
      return {
        'barras': 3,
        'color': const Color(0xFFFFA827), // Naranja 🟠
      };
    } else if (cleanNivel == 'bajo') {
      return {
        'barras': 2,
        'color': const Color(0xFFFFD54F), // Amarillo 🟡
      };
    } else {
      // Maneja 'muy bajo' o cualquier otro texto no registrado por defecto
      return {
        'barras': 1,
        'color': const Color(0xFF32A287), // Verde 🟢
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color txtColorPrincipal = Color(0xFF3E302D);
    const Color bgCrema = Color(0xFFFDF8F5);

    var user = Provider.of<DatabaseService>(context).user;

    return Scaffold(
      backgroundColor: bgCrema,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Perfil de riesgo calculado",
          style: TextStyle(
              color: txtColorPrincipal,
              fontWeight: FontWeight.bold,
              fontSize: 20),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
      body: user == null
          ? const Center(child: Text("Usuario no autenticado"))
          : FutureBuilder<Map<String, dynamic>?>(
              future: firestore.getDatosGenomicos(user.uid),
              builder: (BuildContext context,
                  AsyncSnapshot<Map<String, dynamic>?> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError ||
                    !snapshot.hasData ||
                    snapshot.data == null) {
                  return const Center(
                      child: Text("Error o sin datos de perfil genómico"));
                }

                final datos = snapshot.data!;
                final String descripcion = datos['descripcion_general'] ??
                    "El motor calculó el nivel de riesgo en cada submódulo a partir de tus datos genotípicos.";

                final List<dynamic> composicionLista =
                    datos['composicion_corporal'] ?? [];
                final List<dynamic> nutrigeneticaLista =
                    datos['nutrigenetica'] ?? [];
                final List<dynamic> problemasDigestivosLista =
                    datos['problemas_digestivos'] ?? [];
                final List<dynamic> intoleranciasLista =
                    datos['intolerancias'] ?? [];

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        descripcion,
                        style: const TextStyle(
                            color: Colors.grey, fontSize: 14, height: 1.4),
                      ),
                      const SizedBox(height: 35),

                      // --- SECCIÓN 1: COMPOSICIÓN CORPORAL ---
                      if (composicionLista.isNotEmpty) ...[
                        _buildSeccionTitulo("Composición corporal"),
                        ...composicionLista.map((item) {
                          final String nivel = item['nivelText'] ?? 'Muy Bajo';
                          final visualConfig = _getVisualConfigByNivel(nivel);

                          return _buildCardRiesgo(
                            titulo: item['titulo'] ?? '',
                            subtitulo: item['subtitulo'] ?? '',
                            nivelText: nivel,
                            barrasActivas: visualConfig['barras'],
                            colorNivel: visualConfig['color'],
                          );
                        }),
                        const SizedBox(height: 30),
                      ],

                      // --- SECCIÓN 2: NUTRIGENÉTICA ---
                      if (nutrigeneticaLista.isNotEmpty) ...[
                        _buildSeccionTitulo("Nutrigenética"),
                        ...nutrigeneticaLista.map((item) {
                          final String nivel = item['nivelText'] ?? 'Muy Bajo';
                          final visualConfig = _getVisualConfigByNivel(nivel);

                          return _buildCardRiesgo(
                            titulo: item['titulo'] ?? '',
                            subtitulo: item['subtitulo'] ?? '',
                            nivelText: nivel,
                            barrasActivas: visualConfig['barras'],
                            colorNivel: visualConfig['color'],
                          );
                        }),
                        const SizedBox(height: 30),
                      ],

                      // --- SECCIÓN 3: PROBLEMAS DIGESTIVOS ---
                      if (problemasDigestivosLista.isNotEmpty) ...[
                        _buildSeccionTitulo("Problemas digestivos"),
                        ...problemasDigestivosLista.map((item) {
                          final String nivel = item['nivelText'] ?? 'Muy Bajo';
                          final visualConfig = _getVisualConfigByNivel(nivel);

                          return _buildCardRiesgo(
                            titulo: item['titulo'] ?? '',
                            subtitulo: item['subtitulo'] ?? '',
                            nivelText: nivel,
                            barrasActivas: visualConfig['barras'],
                            colorNivel: visualConfig['color'],
                          );
                        }),
                        const SizedBox(height: 30),
                      ],

                      // --- SECCIÓN 4: INTOLERANCIAS ---
                      if (intoleranciasLista.isNotEmpty) ...[
                        _buildSeccionTitulo("Intolerancias"),
                        ...intoleranciasLista.map((item) {
                          final String nivel = item['nivelText'] ?? 'Muy Bajo';
                          final visualConfig = _getVisualConfigByNivel(nivel);

                          return _buildCardRiesgo(
                            titulo: item['titulo'] ?? '',
                            subtitulo: item['subtitulo'] ?? '',
                            nivelText: nivel,
                            barrasActivas: visualConfig['barras'],
                            colorNivel: visualConfig['color'],
                          );
                        }),
                      ],
                    ],
                  ),
                );
              },
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
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
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
      ),
    );
  }
}