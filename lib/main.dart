import 'package:cine_passe_app/features/controllers/auth_controller.dart';
import 'package:cine_passe_app/features/controllers/movie_controller.dart';
import 'package:cine_passe_app/features/controllers/registration_controller.dart';
import 'package:cine_passe_app/features/controllers/theme_controller.dart';
import 'package:cine_passe_app/features/controllers/ticket_controller.dart';
import 'package:cine_passe_app/features/pages/login_page.dart';
import 'package:cine_passe_app/features/pages/main_app_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // Certifique-se que este arquivo existe (gerado pelo flutterfire configure)

// Temas
import 'core/theme/app_themes.dart';

// Controladores (Core e Features)

void main() async {
  // Garante que a engine do Flutter esteja pronta antes de chamar código nativo
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Inicialização Real do Firebase
  // Se der erro aqui, verifique se rodou 'flutterfire configure' no terminal
  await DefaultFirebaseOptions.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        // Controladores de UI e Auth
        ChangeNotifierProvider(create: (_) => ThemeController()),
        ChangeNotifierProvider(create: (_) => AuthController()),
        ChangeNotifierProvider(create: (_) => RegistrationController()),

        // Controladores de Dados (Features)
        ChangeNotifierProvider(create: (_) => TicketController()),
        ChangeNotifierProvider(create: (_) => MovieController()),
      ],
      child: const CinePasseApp(),
    ),
  );
}

class CinePasseApp extends StatelessWidget {
  const CinePasseApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Escuta mudanças de tema e autenticação
    final themeController = context.watch<ThemeController>();
    final authController = context.watch<AuthController>();

    return MaterialApp(
      title: 'Cine Passe',
      debugShowCheckedModeBanner: false,

      // Configuração de Temas (Claro e Escuro)
      theme: kLightTheme,
      darkTheme: kDarkTheme,
      themeMode: themeController.themeMode,

      locale: const Locale('pt', 'BR'),

      // ✅ FLUXO DE ENTRADA:
      // Verifica no AuthController se existe um usuário logado (currentUser != null).
      // Se sim, vai para a Home (MainAppWrapper). Se não, vai para o Login.
      home: authController.isLoggedIn
          ? const MainAppWrapper()
          : const LoginPage(),
    );
  }
}
