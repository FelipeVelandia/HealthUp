import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nutrialg_life/services/database_service.dart';
import 'package:nutrialg_life/widgets/async_button.dart';
import 'package:nutrialg_life/widgets/dynamic_input.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<DatabaseService>(context, listen: false);
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    //* Text controllers
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            //title: const Text("NutriAlg Life"),
            centerTitle: true,
            backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(80),
              child: SvgPicture.asset("assets/logo.svg", height: 120),
            )),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Text(
                "HealthUp",
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Text(
                "¡Bienvenido!",
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    //color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold),
              ),
              const Text("Inicia sesión con tu usuario y contraseña.",
                  textAlign: TextAlign.center),
              const SizedBox(height: 20),
              Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DynamicInputField(
                      type: InputType.email,
                      label: "Correo",
                      icon: FontAwesomeIcons.solidUser,
                      controller: emailController,
                    ),
                    const SizedBox(height: 8),
                    DynamicInputField(
                      type: InputType.password,
                      label: "Contraseña",
                      icon: FontAwesomeIcons.lock,
                      controller: passwordController,
                    ),
                    const SizedBox(height: 20),
                    AsyncButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          auth.signIn(context, emailController.text,
                              passwordController.text);
                        }
                      },
                      child: const Text("Iniciar sesión"),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              /*FilledButton.tonal(
                onPressed: () {
                  context.push('/register');
                },
                child: const Text("Crear cuenta"),
              ),*/
              const Spacer()
            ],
          ),
        ),
      ),
    );
  }
}
