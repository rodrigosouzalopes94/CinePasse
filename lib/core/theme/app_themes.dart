import 'package:flutter/material.dart';
import 'package:cine_passe_app/core/constants/colors_constants.dart';
import 'package:google_fonts/google_fonts.dart'; // PACOTE GOOGLE FONTS

// -------------------------------------------------------------------
// 💡 Tema Claro (Light Theme)
// -------------------------------------------------------------------
final ThemeData kLightTheme = ThemeData(
  // 1. Configuração Principal
  brightness: Brightness.light,
  useMaterial3: true,
  primaryColor: kPrimaryColor,

  colorScheme: ColorScheme.fromSeed(
    seedColor: kPrimaryColor,
    brightness: Brightness.light,

    // Cores M3
    primary: kPrimaryColor,
    onPrimary: kTextLight,
    secondary: kGreenCheckin,
    surface: kBgLightLight,
    onSurface: kTextLight,
    error: kRedRejected,
    onError: kBgLightLight,
  ),

  // 2. Cores de Fundo da Tela
  scaffoldBackgroundColor: kBgLight,

  // 3. Estilo de Texto Padrão (APLICAÇÃO DO POPPINS)
  textTheme:
      GoogleFonts.poppinsTextTheme(
        ThemeData.light().textTheme, // Baseia-se no TextTheme padrão light
      ).copyWith(
        // Sobrescreve as cores do Poppins para usar a cor de texto do seu tema (kTextLight)
        bodyLarge: TextStyle(color: kTextLight),
        bodyMedium: TextStyle(color: kTextLight),
        // Repita para outros estilos importantes se necessário (ex: headline, title)
      ),

  // 4. Estilos de Componentes
  appBarTheme: AppBarTheme(
    backgroundColor: kBgLightLight,
    foregroundColor: kTextLight,
    surfaceTintColor: Colors.transparent,
  ),
  cardTheme: CardThemeData(
    color: kBgLightLight,
    surfaceTintColor: Colors.transparent,
  ),
);

// -------------------------------------------------------------------
// 🌑 Tema Escuro (Dark Theme)
// -------------------------------------------------------------------
final ThemeData kDarkTheme = ThemeData(
  // 1. Configuração Principal
  brightness: Brightness.dark,
  useMaterial3: true,
  primaryColor: kPrimaryColor,

  colorScheme: ColorScheme.fromSeed(
    seedColor: kPrimaryColor,
    brightness: Brightness.dark,

    // Cores M3
    primary: kPrimaryColor,
    onPrimary: kTextDark,
    secondary: kGreenCheckin,
    surface: kBgDarkLight,
    onSurface: kTextDark,
    error: kRedRejected,
    onError: kTextDark,
  ),

  // 2. Cores de Fundo da Tela
  scaffoldBackgroundColor: kBgDark,

  // 3. Estilo de Texto Padrão (APLICAÇÃO DO POPPINS)
  textTheme:
      GoogleFonts.poppinsTextTheme(
        ThemeData.dark().textTheme, // Baseia-se no TextTheme padrão dark
      ).copyWith(
        // Sobrescreve as cores do Poppins para usar a cor de texto do seu tema (kTextDark)
        bodyLarge: TextStyle(color: kTextDark),
        bodyMedium: TextStyle(color: kTextDark),
        // Repita para outros estilos importantes
      ),

  // 4. Estilos de Componentes
  appBarTheme: AppBarTheme(
    backgroundColor: kBgDarkLight,
    foregroundColor: kTextDark,
    surfaceTintColor: Colors.transparent,
  ),
  cardTheme: CardThemeData(
    color: kBgDarkLight,
    surfaceTintColor: Colors.transparent,
  ),
);
