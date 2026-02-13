import 'package:cine_passe_app/features/pages/checkout_page.dart';
import 'package:cine_passe_app/features/repositories/paymentrepository/i_payment_repository.dart';
import 'package:cine_passe_app/features/repositories/paymentrepository/stripe_payment_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


import 'package:cine_passe_app/features/repositories/authrepository/i_auth_repository.dart';
import 'package:cine_passe_app/features/repositories/authrepository/firebase_auth_repository.dart';
import 'package:cine_passe_app/features/repositories/movierepository/firebase_movie_repository.dart';
import 'package:cine_passe_app/features/repositories/ticketrepository/firebase_ticket_repository.dart';
import 'package:cine_passe_app/features/repositories/planrepository/i_plan_repository.dart';
import 'package:cine_passe_app/features/repositories/planrepository/firebase_plan_repository.dart';



import 'package:cine_passe_app/features/controllers/auth_viewmodel.dart'; 
import 'package:cine_passe_app/features/controllers/registration_viewmodel.dart';
import 'package:cine_passe_app/features/controllers/movie_viewmodel.dart'; 
import 'package:cine_passe_app/features/controllers/ticket_viewmodel.dart';
import 'package:cine_passe_app/features/controllers/theme_controller.dart';
import 'package:cine_passe_app/features/controllers/payment_viewmodel.dart'; 
import 'package:cine_passe_app/features/controllers/plan_controller.dart';


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
       
        Provider<IAuthRepository>(create: (_) => FirebaseAuthRepository()),
        Provider<IPlanRepository>(create: (_) => FirebasePlanRepository()),
        
        
        Provider<IPaymentRepository>(create: (_) => StripePaymentRepository()),

        
        ChangeNotifierProvider(create: (_) => ThemeController()),
        
       
        ChangeNotifierProvider(
          create: (context) => AuthViewModel(context.read<IAuthRepository>()),
        ),

        ChangeNotifierProvider(
          create: (context) => RegistrationViewModel(context.read<IAuthRepository>()),
        ),

        ChangeNotifierProvider(
          create: (_) => MovieViewModel(FirebaseMovieRepository()),
        ),

        ChangeNotifierProvider(
          create: (_) => TicketViewModel(FirebaseTicketRepository()),
        ),

        
        ChangeNotifierProvider(
          create: (context) => PaymentViewModel(
            paymentRepo: context.read<IPaymentRepository>(),
            planRepository: context.read<IPlanRepository>(),
          ),
        ),

        ChangeNotifierProvider(create: (_) => PlanController()),
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
      
      onGenerateRoute: (settings) {
        if (settings.name == '/checkout') {
          
          final args = settings.arguments as Map<String, dynamic>?;
          return MaterialPageRoute(
            builder: (context) => CheckoutPage(
              plan: args?['plan'],
              manualAmount: args?['amount'],
            ),
          );
        }
        return null; 
      },

      home: authViewModel.isLoggedIn
          ? const MainAppWrapper()
          : const LoginPage(),
    );
  }
}