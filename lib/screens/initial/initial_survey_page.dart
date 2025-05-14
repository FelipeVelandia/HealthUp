import 'package:flutter/material.dart';
import 'package:nutrialg_life/models/models.dart';
import 'package:nutrialg_life/widgets/checkbox_list.dart';
import 'package:nutrialg_life/widgets/checkbox_with_descriptions.dart';
import 'package:nutrialg_life/widgets/dynamic_input.dart';
import 'package:nutrialg_life/widgets/form_step.dart';
import 'package:nutrialg_life/widgets/select_input.dart';

class InitialSurveyPage extends StatefulWidget {
  const InitialSurveyPage({super.key});

  @override
  State<InitialSurveyPage> createState() => _InitialSurveyPageState();
}

class _InitialSurveyPageState extends State<InitialSurveyPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late PageController _pageViewController;
  int currentIndex = 0;
  Map<String, TextEditingController> antecedentesController =
      Antecedentes.getEmptyControllers();
  Map<String, TextEditingController> habitosController =
      Habito.getEmptyControllers();

  @override
  void initState() {
    super.initState();
    _pageViewController = PageController();
  }

  @override
  void dispose() {
    _pageViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(right: 50),
          child: LinearProgressIndicator(value: (currentIndex + 1) / 4),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: PageView(
            controller: _pageViewController,
            onPageChanged: _handlePageViewChange,
            children: [
              //* Page 1
              FormStep(
                title: "Antecedentes familiares",
                subtitle: "Marque todas las opciones correspondientes.",
                type: StepType.begin,
                next: _nextPage,
                children: [
                  SizedBox(
                    height: 350,
                    child: SingleChildScrollView(
                      child: CheckboxList(
                          controller: antecedentesController["familiares"]!,
                          options: const [
                            "Obesidad",
                            "Diabetes",
                            "Cáncer",
                            "Hipertensión Arterial",
                            "Asma",
                            "Alergias",
                            "Desnutrición",
                            "Congénitas",
                            "Epilepsia",
                            "Tuberculosis",
                            "Tabaquismo",
                            "Alcoholismo",
                            "VIH/sida",
                          ]),
                    ),
                  )
                ],
              ),
              FormStep(
                title: "Antecedentes personales",
                subtitle: "Marque todas las opciones correspondientes.",
                type: StepType.middle,
                next: _nextPage,
                back: _prevPage,
                children: [
                  SizedBox(
                    height: 350,
                    child: SingleChildScrollView(
                      child: CheckboxWithDescriptions(
                          selectedOptionsController:
                              antecedentesController["personales_claves"]!,
                          descriptionsController: antecedentesController[
                              "personales_descripciones"]!,
                          options: const [
                            "Patológicos",
                            "Hospitalarios",
                            "Farmacológicos",
                            "Quirúrgicos",
                            "Alérgicos",
                            "Traumáticos",
                            "Tóxicos"
                          ]),
                    ),
                  )
                ],
              ),
              FormStep(
                title: "Hábitos alimenticios",
                subtitle: "Marque todas las opciones correspondientes.",
                type: StepType.middle,
                next: _nextPage,
                back: _prevPage,
                children: [
                  SelectInput(
                    label: "Apetito",
                    controller: habitosController["apetito"]!,
                    options: const ["Bueno", "Regular", "Malo"],
                  ),
                  const SizedBox(height: 12),
                  SelectInput(
                    label: "Ingesta",
                    controller: habitosController["ingesta"]!,
                    options: const ["Rápida", "Despacio", "Normal"],
                  ),
                  const SizedBox(height: 12),
                  SelectInput(
                    label: "Deglución",
                    controller: habitosController["deglucion"]!,
                    options: const ["Normal", "Deficiente"],
                  ),
                  const SizedBox(height: 12),
                  SelectInput(
                    label: "¿Mastica bien los alimentos?",
                    controller: habitosController["mastica_bien"]!,
                    options: const ["Si", "No"],
                  ),
                  const SizedBox(height: 12),
                  SelectInput(
                    label: "Hábitos intestinales",
                    controller: habitosController["habito_intestinal"]!,
                    options: const ["Normal", "Estreñimiento", "Diarrea"],
                  ),
                  const SizedBox(height: 12),
                  SelectInput(
                      label: "Síntomas gastrointestinales",
                      controller:
                          habitosController["sintomas_gastrointestinales"]!,
                      options: const ["Vómito", "Reflujo", "Ninguno"])
                ],
              ),
              FormStep(
                title: "Tolerancia de alimentos",
                subtitle: "Marque todas las opciones correspondientes.",
                type: StepType.end,
                next: _nextPage,
                send: () async {},
                children: [
                  DynamicInputField(
                    type: InputType.multiline,
                    label: "Alimentos preferidos",
                    controller: habitosController["alimentos_preferidos"]!,
                  ),
                  const SizedBox(height: 12),
                  DynamicInputField(
                    type: InputType.multiline,
                    label: "Alimentos rechazados",
                    controller: habitosController["alimentos_rechazados"]!,
                  ),
                  const SizedBox(height: 12),
                  DynamicInputField(
                    type: InputType.multiline,
                    label: "Alimentos no tolerados",
                    controller: habitosController["alimentos_no_tolerados"]!,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  // change method
  void _handlePageViewChange(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  void _nextPage() {
    if (formKey.currentState!.validate()) {
      _pageViewController.animateToPage(
        currentIndex + 1,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeIn,
      );
    }
  }

  void _prevPage() {
    _pageViewController.animateToPage(
      currentIndex - 1,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeIn,
    );
  }
}
