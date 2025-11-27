import 'package:cine_passe_app/features/controllers/auth_controller.dart';
import 'package:cine_passe_app/features/controllers/movie_controller.dart';
import 'package:cine_passe_app/features/controllers/registration_controller.dart';
import 'package:cine_passe_app/features/controllers/theme_controller.dart';
import 'package:cine_passe_app/features/controllers/ticket_controller.dart';
import 'package:cine_passe_app/features/pages/login_page.dart';
import 'package:cine_passe_app/features/pages/main_app_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart'; // Arquivo gerado pelo flutterfire configure

// -------------------------------------------------------------------
// IMPORTAÇÕES DE TEMAS E CONTROLADORES GLOBAIS
// -------------------------------------------------------------------
import 'core/theme/app_themes.dart';

void main() async {
  // 1. Garante que a engine do Flutter esteja pronta antes de código nativo
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Inicializa o Firebase com as opções da plataforma (Android/iOS)
  // Certifique-se de que o arquivo firebase_options.dart existe e está correto.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        // --- Controladores de UI e Core ---
        ChangeNotifierProvider(create: (_) => ThemeController()),

        // --- Controladores de Autenticação ---
        ChangeNotifierProvider(create: (_) => AuthController()),
        ChangeNotifierProvider(create: (_) => RegistrationController()),

        // --- Controladores de Dados (Features) ---
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
    // Escuta mudanças no Tema (Claro/Escuro) e na Autenticação
    final themeController = context.watch<ThemeController>();
    final authController = context.watch<AuthController>();

    return MaterialApp(
      title: 'Cine Passe',
      debugShowCheckedModeBanner: false, // Remove a faixa "Debug"
      // -----------------------------------------------------------------
      // CONFIGURAÇÃO DE TEMAS
      // -----------------------------------------------------------------
      theme: kLightTheme, // Tema Claro definido em app_themes.dart
      darkTheme: kDarkTheme, // Tema Escuro definido em app_themes.dart
      themeMode: themeController.themeMode, // Controlado pelo usuário
      // -----------------------------------------------------------------
      // LOCALIZAÇÃO
      // -----------------------------------------------------------------
      locale: const Locale('pt', 'BR'),

      // -----------------------------------------------------------------
      // ROTEAMENTO INICIAL
      // -----------------------------------------------------------------
      // Verifica se existe um usuário logado no Firebase Auth.
      // Se sim (isLoggedIn == true), vai direto para o App Principal.
      // Se não, mostra a tela de Login.
      home: authController.isLoggedIn
          ? const MainAppWrapper()
          : const LoginPage(),
    );
  }
}
