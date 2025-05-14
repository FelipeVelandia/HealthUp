import 'package:flutter/material.dart';
import 'package:nutrialg_life/models/models.dart';
import 'package:nutrialg_life/services/database_service.dart';
import 'package:nutrialg_life/widgets/dynamic_input.dart';
import 'package:nutrialg_life/widgets/form_step.dart';
import 'package:nutrialg_life/widgets/passwords_form.dart';
import 'package:provider/provider.dart';

import 'widgets/register_data_form.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late PageController _pageViewController;
  int _currentIndex = 0;
  Map<String, TextEditingController> pacientControllers =
      Paciente.getEmptyControllers();

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
    TextEditingController passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(right: 50),
          child: LinearProgressIndicator(value: (_currentIndex + 1) / 2),
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
                title: "¡Comencemos!",
                subtitle: "Tus datos nos ayudarán a conocerte mejor.",
                type: StepType.begin,
                next: _nextPage,
                children: [
                  RegisterDataForm(pacientControllers: pacientControllers),
                ],
              ),
              //* Page 2
              FormStep(
                title: "Último paso",
                subtitle:
                    "¡Casi terminas! Establece una contraseña segura para terminar la creación de tu cuenta.",
                type: StepType.end,
                back: _prevPage,
                send: () async {
                  if (formKey.currentState!.validate()) {
                    await auth.signUp(context, passwordController.text,
                        Paciente.fromControllers(pacientControllers));
                  }
                },
                children: [
                  FractionallySizedBox(
                    widthFactor: 0.9,
                    child: DynamicInputField(
                        type: InputType.email,
                        label: "Correo electrónico",
                        controller: pacientControllers["email"]!),
                  ),
                  const SizedBox(height: 12),
                  PasswordsForm(controller: passwordController)
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
      _currentIndex = index;
    });
  }

  void _nextPage() {
    if (formKey.currentState!.validate()) {
      _pageViewController.animateToPage(
        _currentIndex + 1,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeIn,
      );
    }
  }

  void _prevPage() {
    _pageViewController.animateToPage(
      _currentIndex - 1,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeIn,
    );
  }
}
