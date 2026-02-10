import 'package:cine_passe_app/features/repositories/ticketrepository/firebase_ticket_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// --- Repositories ---
import 'package:cine_passe_app/features/repositories/authrepositorie/firebase_auth_repository.dart';
import 'package:cine_passe_app/features/repositories/movierepositorie/firebase_movie_repository.dart';


// --- ViewModels / Controllers ---
import 'package:cine_passe_app/features/controllers/auth_viewmodel.dart'; 
import 'package:cine_passe_app/features/controllers/registration_viewmodel.dart';
import 'package:cine_passe_app/features/controllers/movie_viewmodel.dart'; 
import 'package:cine_passe_app/features/controllers/ticket_viewmodel.dart'; // ViewModel ajustada
import 'package:cine_passe_app/features/controllers/theme_controller.dart';
import 'package:cine_passe_app/features/controllers/payment_controller.dart';
import 'package:cine_passe_app/features/controllers/plan_controller.dart';

// --- Pages & Theme ---
import 'package:cine_passe_app/features/pages/login_page.dart';
import 'package:cine_passe_app/features/pages/main_app_wrapper.dart';
import 'package:cine_passe_app/core/theme/app_themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
       
        ChangeNotifierProvider(create: (_) => ThemeController()),
        
       
        ChangeNotifierProvider(
          create: (_) => AuthViewModel(FirebaseAuthRepository()),
        ),

        ChangeNotifierProvider(
          create: (_) => RegistrationViewModel(FirebaseAuthRepository()),
        ),

        ChangeNotifierProvider(
          create: (_) => MovieViewModel(FirebaseMovieRepository()),
        ),

        
        ChangeNotifierProvider(
          create: (_) => TicketViewModel(FirebaseTicketRepository()),
        ),

        
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
    final authViewModel = context.watch<AuthViewModel>();

    return MaterialApp(
      title: 'Cine Passe',
      debugShowCheckedModeBanner: false,
      theme: kLightTheme,
      darkTheme: kDarkTheme,
      themeMode: themeController.themeMode,
      locale: const Locale('pt', 'BR'),
      
     
      home: authViewModel.isLoggedIn
          ? const MainAppWrapper()
          : const LoginPage(),
    );
  }
}