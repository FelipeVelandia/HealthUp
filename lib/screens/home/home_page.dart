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
    return Scaffold(
      appBar: AppBar(
        title: Text(GoRouterState.of(context).uri.toString() == "/diet"
            ? "Menú para hoy"
            : GoRouterState.of(context).uri.toString() == "/genomics"
                ? "Mi perfil genético"
                : GoRouterState.of(context).uri.toString() == "/exercise-registration"
                ? "Registrar Actividad Física"
                  : GoRouterState.of(context).uri.toString() == "/progress"
                  ? "Bienvenido"
                  : "Por defecto"),
        foregroundColor: scheme.primary,
        centerTitle: true,
        actions: [
          MenuAnchor(
            menuChildren: [
              MenuItemButton(
                onPressed: () {},
                child: const Text('Mis datos'),
              ),
              MenuItemButton(
                onPressed: () {},
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
      floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                onPressed: () => changePath(context, "/progress"),
                icon: const Icon(
                  FontAwesomeIcons.house,
                  size: 30,
                )),
                 const SizedBox(width: 12),
            IconButton(
                onPressed: () => changePath(context, "/diet"),
                icon: const Icon(
                  FontAwesomeIcons.appleWhole,
                  size: 30,
                )),
            const SizedBox(width: 12),
            IconButton(
                onPressed: () => changePath(context, "/genomics"),
                icon: const Icon(
                  FontAwesomeIcons.dna,
                  size: 30,
                )),
            const SizedBox(width: 12), 
            IconButton(
                onPressed: () => changePath(context, "/exercise-registration"),
                icon: const Icon(
                  FontAwesomeIcons.personRunning,
                  size: 20,
                )),    
          ],
        ),
      ),
    );
  }
}
