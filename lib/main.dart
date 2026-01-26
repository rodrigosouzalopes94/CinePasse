import 'package:cine_passe_app/features/controllers/auth_controller.dart';
import 'package:cine_passe_app/features/controllers/movie_controller.dart';
import 'package:cine_passe_app/features/controllers/payment_controller.dart';
import 'package:cine_passe_app/features/controllers/plan_controller.dart';
import 'package:cine_passe_app/features/controllers/registration_controller.dart';
import 'package:cine_passe_app/features/controllers/theme_controller.dart';
import 'package:cine_passe_app/features/controllers/ticket_controller.dart';
import 'package:cine_passe_app/features/pages/login_page.dart';
import 'package:cine_passe_app/features/pages/main_app_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'core/theme/app_themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeController()),
        ChangeNotifierProvider(create: (_) => AuthController()),
        ChangeNotifierProvider(create: (_) => RegistrationController()),
        ChangeNotifierProvider(create: (_) => TicketController()),
        ChangeNotifierProvider(create: (_) => MovieController()),

        ChangeNotifierProvider(create: (_) => PlanController()),
        ChangeNotifierProvider(create: (_) => PaymentController()),
      ],
      child: const CinePasseApp(),
    ),
  );
}

class CinePasseApp extends StatelessWidget {
  const CinePasseApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = context.watch<ThemeController>();
    final authController = context.watch<AuthController>();

    return MaterialApp(
      title: 'Cine Passe',
      debugShowCheckedModeBanner: false,

      theme: kLightTheme,
      darkTheme: kDarkTheme,
      themeMode: themeController.themeMode,

      locale: const Locale('pt', 'BR'),

      home: authController.isLoggedIn
          ? const MainAppWrapper()
          : const LoginPage(),
    );
  }
}
