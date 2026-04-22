import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:nutrialg_life/routes.dart';
import 'package:nutrialg_life/services/database_service.dart';
import 'package:nutrialg_life/themes.dart';
import 'package:provider/provider.dart';

// ignore: unused_import
import 'package:nutrialg_life/screens/food_registration/food_registration_page.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => DatabaseService()),
      ],
      child: Consumer<DatabaseService>(builder: (context, authService, child) {
        return MaterialApp.router(
          title: 'Nutrialg Life',
          routerConfig: getRouter(context),
          debugShowCheckedModeBanner: false,
          //* Theme data
          theme: getTheme(),
          // * localization
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate
          ],
          supportedLocales: const [Locale("en"), Locale("es")],
          locale: const Locale("es"),
        );
      }),
    );
  }
}
