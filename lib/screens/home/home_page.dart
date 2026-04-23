import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:nutrialg_life/services/database_service.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.child});
  final Widget child;

  void changePath(BuildContext context, String path) {
    if (GoRouterState.of(context).uri.toString() != path) {
      GoRouter.of(context).push(path);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<DatabaseService>(context, listen: false);

    var scheme = Theme.of(context).colorScheme;
    // Guardamos la ruta actual para la lógica del título y del botón
    var currentPath = GoRouterState.of(context).uri.toString();

    return Scaffold(
      appBar: AppBar(
        title: Text(currentPath == "/diet"
            ? "Menú para hoy"
            : currentPath == "/genomics"
                ? "Mi perfil genético"
                : currentPath == "/exercise-registration"
                    ? "Registrar Actividad Física"
                    : currentPath == "/progress"
                        ? "HealthUp"
                        : "Por defecto"),
        foregroundColor: scheme.primary,
        centerTitle: true,
        actions: [
          MenuAnchor(
            menuChildren: [
              MenuItemButton(
                onPressed: () => changePath(context, "/account"),
                child: const Text('Mi cuenta'),
              ),
              MenuItemButton(
                onPressed: () async {
                  auth.signOut();
                },
                child: const Text('Salir'),
              )
            ],
            builder: (context, controller, child) => IconButton(
                onPressed: () {
                  if (controller.isOpen) {
                    controller.close();
                  } else {
                    controller.open();
                  }
                },
                icon: const Icon(Icons.more_vert_rounded)),
          )
        ],
      ),
      body: child,

      // --- BOTÓN FLOTANTE PERSONALIZADO ---
      // Solo se muestra si estamos en la pantalla de progreso
      floatingActionButton: currentPath == "/progress" 
        ? FloatingActionButton(
            onPressed: () => changePath(context, "/exercise-registration"),
            backgroundColor: const Color(0xFF32A287), // Tu verde esmeralda
            elevation: 4,
            shape: const CircleBorder(), // Lo hace perfectamente circular
            child: const Icon(
              FontAwesomeIcons.personRunning, // El icono de ejercicio
              color: Colors.white,
              size: 24,
            ),
          )
        : null,

      // Ubicación flotante sobre el contenido, sin tocar la barra
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
                onPressed: () => changePath(context, "/progress"),
                icon: const Icon(
                  FontAwesomeIcons.house,
                  size: 25,
                )),
            IconButton(
                onPressed: () => changePath(context, "/diet"),
                icon: const Icon(
                  FontAwesomeIcons.appleWhole,
                  size: 25,
                )),
            IconButton(
                onPressed: () => changePath(context, "/genomics"),
                icon: const Icon(
                  FontAwesomeIcons.dna,
                  size: 25,
                )),
          ],
        ),
      ),
    );
  }
}