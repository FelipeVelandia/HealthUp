import 'package:flutter/material.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  bool _mostrarResultadosGenetics = true;

  // Lista estática de los genes reales basados en tu captura con su traducción amigable
  final List<Map<String, String>> _genesData = [
    {
      "nombre": "HLA-DQ (2.5/8)",
      "tecnico": "Presentación de péptidos del gluten al sistema inmune.",
      "paciente": "Este marcador evalúa cómo reacciona tu sistema inmune ante el gluten. No significa que seas celíaco, pero nos ayuda a saber si procesas mejor los granos antiguos o si es preferible reducir el trigo en tu menú diario.",
    },
    {
      "nombre": "MC4R (rs17782313)",
      "tecnico": "Receptor de melanocortina 4, regulación del hambre.",
      "paciente": "Es conocido como el 'gen del apetito'. Influye en la velocidad con la que tu cerebro recibe la señal de saciedad. Tu plan incluye alimentos con alta densidad de fibra para ayudarte a sentirte lleno por más tiempo de forma natural.",
    },
    {
      "nombre": "MCM6 (-13910C*T)",
      "tecnico": "Regula la expresión de la lactasa (LCT) en el intestino adulto.",
      "paciente": "Este gen determina la capacidad de tu cuerpo para seguir produciendo lactasa en la edad adulta. Nos dice qué tan tolerante eres a los lácteos tradicionales para decidir si priorizamos opciones deslactosadas o vegetales.",
    },
    {
      "nombre": "MTHFR (C677T)",
      "tecnico": "Convierte 5,10-metilentetrahidrofolato en 5-metiltetrahidrofolato.",
      "paciente": "Se encarga de cómo tu cuerpo procesa el ácido fólico (Vitamina B9) y limpia toxinas. Una variante aquí significa que te beneficias enormemente de hojas verdes oscuras (espinacas, brócoli) para mantener tu energía al máximo.",
    },
    {
      "nombre": "TCF7L2 (rs7903146)",
      "tecnico": "Factor de transcripción de la vía Wnt, regulación de insulina.",
      "paciente": "Este marcador se vincula directamente con la sensibilidad a la glucosa y la eficacia de la insulina. Por esta razón, tu nutricionista controla los picos de azúcar en tus comidas, distribuyendo los carbohidratos de forma inteligente.",
    },
    {
      "nombre": "VDR (FokI)",
      "tecnico": "Receptor de vitamina D, media los efectos celulares.",
      "paciente": "Controla qué tan eficiente es tu cuerpo absorbiendo la Vitamina D a nivel celular, un pilar para tus huesos y defensas. Tu plan busca optimizar esto mediante grasas saludables, exposición solar controlada o alimentos específicos.",
    },
  ];

  // Función para mostrar la explicación al paciente de forma moderna desde abajo
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
              // Línea estética superior del BottomSheet
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  const Icon(Icons.dns_rounded, color: Color(0xFF32A287), size: 24),
                  const SizedBox(width: 8),
                  Text(
                    gen["nombre"]!,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF3E302D)),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                "Descripción técnica (Médico):",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey.shade500, letterSpacing: 0.5),
              ),
              const SizedBox(height: 4),
              Text(
                gen["tecnico"]!,
                style: TextStyle(fontSize: 13, color: Colors.grey.shade700, fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 16),
              const Divider(height: 1),
              const SizedBox(height: 16),
              Text(
                "¿Qué significa para ti?",
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF32A287)),
              ),
              const SizedBox(height: 6),
              Text(
                gen["paciente"]!,
                style: const TextStyle(fontSize: 13.5, color: Color(0xFF3E302D), height: 1.45),
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

    return Scaffold(
      backgroundColor: bgCrema,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. ENCABEZADO
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.015), blurRadius: 8, offset: const Offset(0, 2))],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: greenPrimary.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                      child: const Icon(Icons.analytics_rounded, color: greenPrimary, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Informe Nutrigenético", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: txtColorPrincipal, letterSpacing: -0.3)),
                          const SizedBox(height: 2),
                          Text("Velandia", style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
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
                decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(12)),
                child: Row(
                  children: [
                    _buildTabButton("Resultados genéticos", _mostrarResultadosGenetics, greenPrimary, () => setState(() => _mostrarResultadosGenetics = true)),
                    _buildTabButton("Parámetros clínicos", !_mostrarResultadosGenetics, greenPrimary, () => setState(() => _mostrarResultadosGenetics = false)),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 4. CONTENIDO DINÁMICO
              _mostrarResultadosGenetics
                  ? _buildResultadosGeneticosMobile(txtColorPrincipal, greenPrimary)
                  : _buildParametrosClinicosMaqueta(txtColorPrincipal),
              
              const SizedBox(height: 20),

              // 5. REFERENCIAS
              _buildReferenciasMobile(txtColorPrincipal, greenPrimary),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabButton(String text, bool activo, Color brandColor, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: activo ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(9),
            boxShadow: activo ? [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 3, offset: const Offset(0, 1))] : [],
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5, color: activo ? brandColor : Colors.grey.shade600),
          ),
        ),
      ),
    );
  }

  // --- VISTA 1: GENÉTICA CON INTEGRACIÓN REAL E INTERACTIVA ---
  Widget _buildResultadosGeneticosMobile(Color txtColor, Color brandColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Marcadores Analizados", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: txtColor.withOpacity(0.8))),
              Text("Toca para entenderlos", style: TextStyle(fontSize: 11, color: brandColor, fontWeight: FontWeight.w500)),
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
            itemCount: _genesData.length,
            separatorBuilder: (context, index) => Divider(height: 1, color: Colors.grey.shade100),
            itemBuilder: (context, index) {
              final gen = _genesData[index];
              return InkWell(
                onTap: () => _mostrarExplicacionGen(context, gen),
                borderRadius: BorderRadius.circular(14),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  child: Row(
                    children: [
                      // Icono genético sutil del lado izquierdo idéntico al estilo de tu captura
                      const Icon(Icons.import_export_rounded, color: Color(0xFF32A287), size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              gen["nombre"]!,
                              style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: txtColor),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              gen["tecnico"]!,
                              style: TextStyle(fontSize: 11.5, color: Colors.grey.shade600),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis, // Si es muy largo se corta sutilmente
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.info_outline_rounded, color: Colors.grey.shade400, size: 18),
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

  // --- VISTA 2: MAQUETA CLÍNICA ESTÁTICA ---
  Widget _buildParametrosClinicosMaqueta(Color txtColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text("Última analítica de sangre", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: txtColor.withOpacity(0.8))),
        ),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.grey.shade100)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildClinicoItem("Glucosa en ayunas", "94 mg/dL", "Normal (70-100)", Colors.green),
              const Divider(height: 24, color: Color(0xFFFDF8F5)),
              _buildClinicoItem("Triglicéridos", "165 mg/dL", "Elevado (>150)", const Color(0xFFFFB300)),
              const SizedBox(height: 6),
              Text("Nota: Tus niveles están ligeramente por encima del rango óptimo. Tu menú actual controla carbohidratos para regular este valor.", style: TextStyle(fontSize: 11.5, color: Colors.grey.shade600, height: 1.3)),
              const Divider(height: 24, color: Color(0xFFFDF8F5)),
              _buildClinicoItem("Colesterol Total", "185 mg/dL", "Normal (<200)", Colors.green),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildClinicoItem(String titulo, String valor, String rango, Color estadoColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(titulo, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: Color(0xFF3E302D))),
            const SizedBox(height: 2),
            Text(rango, style: TextStyle(fontSize: 11.5, color: Colors.grey.shade500)),
          ],
        ),
        Row(
          children: [
            Text(valor, style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold, color: Color(0xFF3E302D))),
            const SizedBox(width: 8),
            Container(width: 8, height: 8, decoration: BoxDecoration(color: estadoColor, shape: BoxShape.circle)),
          ],
        )
      ],
    );
  }

  // --- VISTA 3: REFERENCIAS ---
  Widget _buildReferenciasMobile(Color txtColor, Color brandColor) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.grey.shade100)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.menu_book_rounded, color: brandColor, size: 16),
              const SizedBox(width: 6),
              Text("Referencias bibliográficas", style: TextStyle(fontWeight: FontWeight.bold, color: txtColor, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 6),
          Text("Estudios científicos que avalan tu informe:", style: TextStyle(color: Colors.grey.shade500, fontSize: 11.5)),
          const SizedBox(height: 10),
          _referenciaItemMobile("[1]", "DOI: 10.1038/ng.2007.1", brandColor),
          _referenciaItemMobile("[2]", "DOI: 10.1038/ng0595-111", brandColor),
          _referenciaItemMobile("[3]", "DOI: 10.1093/hmg/ddm123", brandColor),
        ],
      ),
    );
  }

  Widget _referenciaItemMobile(String index, String doi, Color brandColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        children: [
          Text("$index ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: brandColor)),
          const SizedBox(width: 4),
          Expanded(child: Text(doi, style: TextStyle(color: Colors.grey.shade600, fontSize: 11, fontFamily: 'monospace'))),
        ],
      ),
    );
  }
}