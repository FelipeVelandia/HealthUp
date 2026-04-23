import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:nutrialg_life/screens/exercise_registration/exercise_registration_page.dart";
import "package:nutrialg_life/screens/diet/details_page.dart";
import "package:nutrialg_life/screens/screens.dart";
import "package:nutrialg_life/services/database_service.dart";
import "package:provider/provider.dart";

GoRouter getRouter(BuildContext context) {
  return GoRouter(
    initialLocation: "/progress",
    routes: [
      ShellRoute(
        builder: (context, state, child) => HomePage(child: child),
        routes: [
          GoRoute(
            path: '/diet',
            builder: (context, state) => DietPage(),
            pageBuilder: (context, state) {
              return CustomTransitionPage(
                key: state.pageKey,
                child: DietPage(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
              );
            },
          ),
          GoRoute(
            path: '/genomics',
            builder: (context, state) => const GenomicPage(),
            pageBuilder: (context, state) {
              return CustomTransitionPage(
                key: state.pageKey,
                child: const GenomicPage(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
              );
            },
          ),
          GoRoute(
            path: '/progress',
            builder: (context, state) => ProgressPage(),
            pageBuilder: (context, state) {
              return CustomTransitionPage(
                key: state.pageKey,
                child: ProgressPage(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
              );
            },
          )
        ],
      ),
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
      GoRoute(
        path: '/food-registration',
        builder: (context, state) => const FoodRegistrationScreen(),
      ),
      GoRoute(
        path: '/exercise-registration',
        builder: (context, state) => const ExerciseRegistrationPage(),
      ),
        path: '/details',
        builder: (context, state) => DetailsPage(),
      )
    ],
    redirect: (context, state) {
      // Obtén el estado de autenticación
      final authService = Provider.of<DatabaseService>(context, listen: false);
      final isAuthenticated = authService.isAuthenticated;
      final onBoard = authService.onBoard;
      final goingToLogin = state.fullPath == '/login';
      final goingToRegister = state.fullPath == '/register';

      // Si no está autenticado y no está en la página de login, redirige a /login
      if (!isAuthenticated && !goingToLogin && !goingToRegister) {
        return '/login';
      }

      // Si está autenticado y está tratando de ir a /login, redirige al home
      if (isAuthenticated && (goingToLogin || goingToRegister)) {
        return '/progress';
      }

      if (!onBoard) {
        return '/initial';
      }

      // No redirigir en otros casos
      return null;
    },
    refreshListenable: Provider.of<DatabaseService>(context, listen: false),
  );
}
