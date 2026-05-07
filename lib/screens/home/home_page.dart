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
      GoRouter.of(context).go(path);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<DatabaseService>(context, listen: false);
    var currentPath = GoRouterState.of(context).uri.toString();
    const Color activeColor = Color(0xFF32A287);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          currentPath == "/diet" || currentPath == "/food-registration"
              ? "Menú para hoy"
              : currentPath == "/genomics"
                  ? "Mi perfil genético"
                  : currentPath == "/exercise-registration"
                      ? "Actividad Física"
                      : currentPath == "/progress"
                          ? "HealthUp"
                          : "NutriAlg Life",
        ),
        centerTitle: true,
        // RESTAURADO: Volvemos al menú de tres puntos verticales
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
              icon: const Icon(Icons.more_vert_rounded), // El icono de antes
            ),
          )
        ],
      ),
      body: child,

      // BOTÓN FLOTANTE: Solo en Dieta, posición original a la derecha
      floatingActionButton: currentPath == "/diet" 
        ? FloatingActionButton(
            onPressed: () => changePath(context, "/food-registration"),
            backgroundColor: activeColor,
            elevation: 4,
            shape: const CircleBorder(),
            child: const Icon(
              FontAwesomeIcons.utensils,
              color: Colors.white,
              size: 20,
            ),
          )
        : null,

      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      bottomNavigationBar: BottomAppBar(
        elevation: 10,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () => changePath(context, "/progress"),
              icon: Icon(
                FontAwesomeIcons.house,
                size: 22,
                color: currentPath == "/progress" ? activeColor : Colors.grey,
              ),
            ),
            IconButton(
              onPressed: () => changePath(context, "/diet"),
              icon: Icon(
                FontAwesomeIcons.appleWhole,
                size: 22,
                color: (currentPath == "/diet" || currentPath == "/food-registration") 
                    ? activeColor 
                    : Colors.grey,
              ),
            ),
            IconButton(
              onPressed: () => changePath(context, "/exercise-registration"),
              icon: Icon(
                FontAwesomeIcons.personRunning,
                size: 22,
                color: currentPath == "/exercise-registration" ? activeColor : Colors.grey,
              ),
            ),
            IconButton(
              onPressed: () => changePath(context, "/genomics"),
              icon: Icon(
                FontAwesomeIcons.dna,
                size: 22,
                color: currentPath == "/genomics" ? activeColor : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}