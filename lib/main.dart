// lib/main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_themes.dart';
import 'features/auth/controllers/registration_controller.dart';
import 'features/auth/controllers/auth_controller.dart';
import 'features/auth/pages/login_page.dart'; // Nossa página inicial

// ⚠️ Lembre-se de adicionar as dependências do Firebase ao pubspec.yaml
// import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart'; // O arquivo gerado pelo Firebase CLI

void main() async {
  // WidgetsFlutterBinding.ensureInitialized(); // Necessário para usar plugins
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

  runApp(
    MultiProvider(
      providers: [
        // Controllers de Autenticação e Registro
        ChangeNotifierProvider(create: (_) => AuthController()),
        ChangeNotifierProvider(create: (_) => RegistrationController()),
        // Adicione outros controllers do app aqui futuramente (ex: MovieController)
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Configuração de Identificação
      title: 'Cine Passe',

      // Configuração de Temas
      theme: kLightTheme,
      darkTheme: kDarkTheme,
      themeMode:
          ThemeMode.system, // Define se o tema claro/escuro segue o sistema
      // Configuração de Localização (Idioma)
      locale: const Locale('pt', 'BR'),

      // Definição da Rota Inicial
      // A LoginPage é a primeira tela, focada em smartphones
      home: const LoginPage(),
    );
  }
}
