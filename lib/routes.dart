import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:nutrialg_life/screens/account/account_page.dart";
import "package:nutrialg_life/screens/exercise_registration/exercise_registration_page.dart";
import "package:nutrialg_life/screens/diet/details_page.dart";
import "package:nutrialg_life/screens/screens.dart";
import "package:nutrialg_life/services/database_service.dart";
import 'package:nutrialg_life/screens/daily/daily_page.dart';
import "package:provider/provider.dart";
import 'package:nutrialg_life/screens/genomic/genomic_page.dart';
import 'package:nutrialg_life/screens/food_registration/food_registration_page.dart';

GoRouter getRouter(BuildContext context) {
  return GoRouter(
    initialLocation: "/progress",
    routes: [
      ShellRoute(
        builder: (context, state, child) => HomePage(child: child),
        routes: [
          // PROGRESO
          GoRoute(
            path: '/progress',
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: ProgressPage(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) =>
                  FadeTransition(opacity: animation, child: child),
            ),
          ),

          // DIETA (Vista principal al tocar la manzana)
          GoRoute(
            path: '/diet',
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: DietPage(), 
              transitionsBuilder: (context, animation, secondaryAnimation, child) =>
                  FadeTransition(opacity: animation, child: child),
            ),
          ),

          // REGISTRO DE ALIMENTOS (Se abre desde el botón flotante)
          GoRoute(
            path: '/food-registration',
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const FoodRegistrationScreen(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) =>
                  FadeTransition(opacity: animation, child: child),
            ),
          ),

          // EJERCICIO
          GoRoute(
            path: '/exercise-registration',
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const ExerciseRegistrationPage(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) =>
                  FadeTransition(opacity: animation, child: child),
            ),
          ),

          // GENÓMICA
          GoRoute(
            path: '/genomics',
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const GenomicPage(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) =>
                  FadeTransition(opacity: animation, child: child),
            ),
          ),
        ],
      ),

      // Rutas fuera del Shell
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      GoRoute(path: '/register', builder: (context, state) => const RegisterPage()),
      GoRoute(path: '/initial', builder: (context, state) => const InitialSurveyPage()),
      GoRoute(path: '/details', builder: (context, state) => DetailsPage()),
      GoRoute(path: '/account', builder: (context, state) => AccountPage()),
      GoRoute(path: '/daily', builder: (context, state) => DailyPage()),
    ],
    // ... lógica de redirect y refreshListenable igual ...
    redirect: (context, state) {
      final authService = Provider.of<DatabaseService>(context, listen: false);
      if (!authService.isAuthenticated && state.fullPath != '/login' && state.fullPath != '/register') return '/login';
      return null;
    },
    refreshListenable: Provider.of<DatabaseService>(context, listen: false),
  );
}