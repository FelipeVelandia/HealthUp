import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nutrialg_life/services/database_service.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  bool _mostrarResultadosGenetics = true;
  final firestore = DatabaseService();

  // Función para determinar el color del estado clínico dinámicamente
  Color _getEstadoColor(String? estado) {
    switch (estado?.trim().toLowerCase()) {
      case 'normal':
        return Colors.green;
      case 'elevado':
      case 'moderado':
        return const Color(0xFFFFB300); // Amarillo / Naranja
      case 'alto':
      case 'critico':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _mostrarExplicacionGen(BuildContext context, Map<String, String> gen) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  const Icon(Icons.dns_rounded,
                      color: Color(0xFF32A287), size: 24),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      gen["nombre"] ?? 'Marcador sin nombre',
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF3E302D)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                "Descripción técnica (Médico):",
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade500,
                    letterSpacing: 0.5),
              ),
              const SizedBox(height: 4),
              Text(
                gen["tecnico"] ?? 'Sin descripción médica disponible.',
                style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade700,
                    fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 16),
              const Divider(height: 1),
              const SizedBox(height: 16),
              const Text(
                "¿Qué significa para ti?",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF32A287)),
              ),
              const SizedBox(height: 6),
              Text(
                gen["paciente"] ?? 'Sin descripción amigable disponible.',
                style: const TextStyle(
                    fontSize: 13.5, color: Color(0xFF3E302D), height: 1.45),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color txtColorPrincipal = Color(0xFF3E302D);
    const Color greenPrimary = Color(0xFF32A287);
    const Color bgCrema = Color(0xFFFDF8F5);

    var user = Provider.of<DatabaseService>(context).user;

    return Scaffold(
      backgroundColor: bgCrema,
      body: SafeArea(
        child: user == null
            ? const Center(child: Text("Usuario no autenticado"))
            : FutureBuilder<Map<String, dynamic>?>(
                future: firestore.getInformeNutrigenetico(user.uid),
                builder: (BuildContext context,
                    AsyncSnapshot<Map<String, dynamic>?> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError ||
                      !snapshot.hasData ||
                      snapshot.data == null) {
                    return const Center(
                        child: Text("Sin datos de informe disponibles"));
                  }

                  final data = snapshot.data!;
                  final String apellido =
                      data['paciente_apellido']?.toString() ?? 'Paciente';
                  final List<dynamic> genesLista =
                      data['genes'] is List ? data['genes'] : [];
                  final List<dynamic> clinicosLista =
                      data['clinicos'] is List ? data['clinicos'] : [];
                  final List<dynamic> referenciasLista =
                      data['referencias'] is List ? data['referencias'] : [];

                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 1. ENCABEZADO
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.015),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2))
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: greenPrimary.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(10)),
                                child: const Icon(Icons.analytics_rounded,
                                    color: greenPrimary, size: 24),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Informe Nutrigenético",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: txtColorPrincipal,
                                            letterSpacing: -0.3)),
                                    const SizedBox(height: 2),
                                    Text(apellido,
                                        style: TextStyle(
                                            color: Colors.grey.shade600,
                                            fontSize: 12)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),

                        // 3. SELECTOR DE PESTAÑAS
                        Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(12)),
                          child: Row(
                            children: [
                              _buildTabButton(
                                  "Resultados genéticos",
                                  _mostrarResultadosGenetics,
                                  greenPrimary,
                                  () => setState(
                                      () => _mostrarResultadosGenetics = true)),
                              _buildTabButton(
                                  "Parámetros clínicos",
                                  !_mostrarResultadosGenetics,
                                  greenPrimary,
                                  () => setState(() =>
                                      _mostrarResultadosGenetics = false)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // 4. CONTENIDO DINÁMICO
                        _mostrarResultadosGenetics
                            ? _buildResultadosGeneticosMobile(
                                txtColorPrincipal, greenPrimary, genesLista)
                            : _buildParametrosClinicosMobile(
                                txtColorPrincipal, clinicosLista),
                        const SizedBox(height: 20),

                        // 5. REFERENCIAS
                        if (referenciasLista.isNotEmpty)
                          _buildReferenciasMobile(txtColorPrincipal,
                              greenPrimary, referenciasLista),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }

  Widget _buildTabButton(
      String text, bool activo, Color brandColor, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: activo ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(9),
            boxShadow: activo
                ? [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 3,
                        offset: const Offset(0, 1))
                  ]
                : [],
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12.5,
                color: activo ? brandColor : Colors.grey.shade600),
          ),
        ),
      ),
    );
  }

  Widget _buildResultadosGeneticosMobile(
      Color txtColor, Color brandColor, List<dynamic> genes) {
    if (genes.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20.0),
        child: Center(child: Text("No hay marcadores genéticos registrados.")),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Marcadores Analizados",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: txtColor.withOpacity(0.8))),
              Text("Toca para entenderlos",
                  style: TextStyle(
                      fontSize: 11,
                      color: brandColor,
                      fontWeight: FontWeight.w500)),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.grey.shade100),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: genes.length,
            separatorBuilder: (context, index) =>
                Divider(height: 1, color: Colors.grey.shade100),
            itemBuilder: (context, index) {
              final item = genes[index];
              final Map<String, String> gen = {
                "nombre": item['nombre']?.toString() ?? 'Módulo sin nombre',
                "tecnico": item['tecnico']?.toString() ?? '',
                "paciente": item['paciente']?.toString() ?? '',
              };
              return InkWell(
                onTap: () => _mostrarExplicacionGen(context, gen),
                borderRadius: BorderRadius.circular(14),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  child: Row(
                    children: [
                      const Icon(Icons.import_export_rounded,
                          color: Color(0xFF32A287), size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              gen["nombre"]!,
                              style: TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.bold,
                                  color: txtColor),
                            ),
                            if (gen["tecnico"]!.isNotEmpty) ...[
                              const SizedBox(height: 2),
                              Text(
                                gen["tecnico"]!,
                                style: TextStyle(
                                    fontSize: 11.5,
                                    color: Colors.grey.shade600),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ],
                        ),
                      ),
                      Icon(Icons.info_outline_rounded,
                          color: Colors.grey.shade400, size: 18),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildParametrosClinicosMobile(Color txtColor, List clinicos) {
    if (clinicos.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20.0),
        child: Center(child: Text("No hay parámetros clínicos registrados.")),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text("Última analítica de sangre",
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: txtColor.withOpacity(0.8))),
        ),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.grey.shade100)),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: clinicos.length,
            separatorBuilder: (context, index) =>
                const Divider(height: 24, color: Color(0xFFFDF8F5)),
            itemBuilder: (context, index) {
              final item = clinicos[index];
              final String titulo = item['titulo']?.toString() ?? 'Parámetro';
              final String valor = item['valor']?.toString() ?? 'N/A';
              final String rango = item['rango']?.toString() ?? '';
              final String? nota = item['nota']?.toString();
              final Color estadoColor =
                  _getEstadoColor(item['estado']?.toString());
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildClinicoItem(titulo, valor, rango, estadoColor),
                  if (nota != null && nota.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(nota,
                        style: TextStyle(
                            fontSize: 11.5,
                            color: Colors.grey.shade600,
                            height: 1.3)),
                  ],
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildClinicoItem(
      String titulo, String valor, String rango, Color estadoColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(titulo,
                style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3E302D))),
            if (rango.isNotEmpty) ...[
              const SizedBox(height: 2),
              Text(rango,
                  style:
                      TextStyle(fontSize: 11.5, color: Colors.grey.shade500)),
            ],
          ],
        ),
        Row(
          children: [
            Text(valor,
                style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3E302D))),
            const SizedBox(width: 8),
            Container(
                width: 8,
                height: 8,
                decoration:
                    BoxDecoration(color: estadoColor, shape: BoxShape.circle)),
          ],
        )
      ],
    );
  }

  Widget _buildReferenciasMobile(
      Color txtColor, Color brandColor, List referencias) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade100)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.menu_book_rounded, color: brandColor, size: 16),
              const SizedBox(width: 6),
              Text("Referencias bibliográficas",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: txtColor,
                      fontSize: 13)),
            ],
          ),
          const SizedBox(height: 6),
          Text("Estudios científicos que avalan tu informe:",
              style: TextStyle(color: Colors.grey.shade500, fontSize: 11.5)),
          const SizedBox(height: 10),
          ...List.generate(referencias.length, (index) {
            return _referenciaItemMobile(
                "[${index + 1}]", referencias[index].toString(), brandColor);
          }),
        ],
      ),
    );
  }

  Widget _referenciaItemMobile(String index, String doi, Color brandColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        children: [
          Text("$index ",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                  color: brandColor)),
          const SizedBox(width: 4),
          Expanded(
              child: Text(doi,
                  style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 11,
                      fontFamily: 'monospace'))),
        ],
      ),
    );
  }
}
