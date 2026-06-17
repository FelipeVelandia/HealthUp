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
import "package:nutrialg_life/screens/reports/report_page.dart";

GoRouter getRouter(BuildContext context) {
  return GoRouter(
    initialLocation: "/progress",
    routes: [
      ShellRoute(
        builder: (context, state, child) => HomePage(child: child),
        routes: [
          // RUTA DIETA
          GoRoute(
            path: '/diet',
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: DietPage(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              },
            ),
          ),

          // RUTA GENÓMICA
          GoRoute(
            path: '/genomics',
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const GenomicPage(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              },
            ),
          ),

          // RUTA PROGRESO (Home)
          GoRoute(
            path: '/progress',
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: ProgressPage(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              },
            ),
          ),

          GoRoute(
            path: '/report',
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const ReportPage(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              },
            ),
          )
        ],
      ),

      // Rutas fuera del Shell (sin barra inferior)
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: '/initial',
        builder: (context, state) => const InitialSurveyPage(),
      ),
      // Registro de comida fuera del Shell para que sea pantalla completa
      GoRoute(
        path: '/food-registration',
        builder: (context, state) => FoodRegistrationScreen(),
      ),
      // Registro de ejercicio fuera del Shell para que sea pantalla completa
      GoRoute(
        path: '/exercise-registration',
        builder: (context, state) => const ExerciseRegistrationPage(),
      ),
      GoRoute(
        path: '/details',
        builder: (context, state) => DetailsPage(),
      ),
      GoRoute(
        path: '/account',
        builder: (context, state) => AccountPage(),
      ),
      GoRoute(
        path: '/daily',
        builder: (context, state) => DailyPage(),
      ),
      GoRoute(
        path: '/report',
        builder: (context, state) => const ReportPage(),
      ),
    ],

    // Lógica de redirección (Auth Guard)
    redirect: (context, state) {
      final authService = Provider.of<DatabaseService>(context, listen: false);
      final isAuthenticated = authService.isAuthenticated;
      final onBoard = authService.onBoard;

      final goingToLogin = state.fullPath == '/login';
      final goingToRegister = state.fullPath == '/register';

      if (!isAuthenticated && !goingToLogin && !goingToRegister) {
        return '/login';
      }

      if (isAuthenticated && (goingToLogin || goingToRegister)) {
        return '/progress';
      }

      if (isAuthenticated && !onBoard && state.fullPath != '/initial') {
        return '/initial';
      }

      return null;
    },
    refreshListenable: Provider.of<DatabaseService>(context, listen: false),
  );
}