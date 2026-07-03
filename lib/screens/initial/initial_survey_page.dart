import 'package:flutter/material.dart';
import 'package:nutrialg_life/models/models.dart';
import 'package:nutrialg_life/widgets/checkbox_list.dart';
import 'package:nutrialg_life/widgets/dynamic_input.dart';
import 'package:nutrialg_life/widgets/form_step.dart';
import 'package:nutrialg_life/widgets/select_input.dart';
import 'package:provider/provider.dart';
import 'package:nutrialg_life/services/database_service.dart';

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
    final auth = Provider.of<DatabaseService>(context, listen: false);
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
                title: "Hábitos alimenticios",
                subtitle: "Marque todas las opciones correspondientes.",
                type: StepType.middle,
                next: _nextPage,
                back: _prevPage,
                children: [
                  SelectInput(
                    label: "Apetito",
                    controller: habitosController["apetito"]!,
                    options: const ["Bueno (Consume 3 o más comidas al día)", "Regular (Consume menos de 3 comidas al día)", "Malo (Consume menos de 2 comidas al día)"],
                  ),
                  const SizedBox(height: 12),
                  SelectInput(
                    label: "Ingesta",
                    controller: habitosController["ingesta"]!,
                    options: const ["Rápida (Come en menos de 20 minutos)", "Despacio (Come en menos de 30 minutos)", "Normal (Come entre 20 y 30 minutos)"],
                  ),
                  const SizedBox(height: 12),
                  SelectInput(
                    label: "Deglución",
                    controller: habitosController["deglucion"]!,
                    options: const ["Normal (Mastica lo suficiente los alimentos antes de tragar)", "Deficiente (No mastica lo suficiente y los trozos de alimento pasan enteros)"],
                  ),
                  const SizedBox(height: 12),
                  SelectInput(
                    label: "¿Mastica bien los alimentos?",
                    controller: habitosController["mastica_bien"]!,
                    options: const ["Si (El alimento esta completamente macerado antes de tragar)", "No (Traga los alimentos sin que esten completamente macerados)"],
                  ),
                  const SizedBox(height: 12),
                  SelectInput(
                    label: "Hábitos intestinales",
                    controller: habitosController["habito_intestinal"]!,
                    options: const ["Normal (1 deposición al día blanda)", "Estreñimiento (1 deposición al dia realizada con esfuerzo)", "Diarrea (Realiza deposiciones acuosas)"],
                  ),
                  const SizedBox(height: 12),
                  SelectInput(
                      label: "Síntomas gastrointestinales",
                      controller:
                          habitosController["sintomas_gastrointestinales"]!,
                      options: const ["Vómito", "Reflujo", "Producción de gases", "Ninguno"])
                ],
              ),
              FormStep(
                title: "Tolerancia de alimentos",
                subtitle: "Marque todas las opciones correspondientes.",
                type: StepType.end,
                next: _nextPage,
                back: _prevPage,
                send: () async {
                  if (formKey.currentState!.validate()) {
                          auth.initial(context, Antecedentes.fromControllers(antecedentesController), Habito.fromControllers(habitosController));
                  }
                },
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
