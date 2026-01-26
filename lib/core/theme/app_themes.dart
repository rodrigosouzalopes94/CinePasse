import 'package:flutter/material.dart';
import 'package:cine_passe_app/core/constants/colors_constants.dart';
import 'package:google_fonts/google_fonts.dart'; 


final ThemeData kLightTheme = ThemeData(
 
  brightness: Brightness.light,
  useMaterial3: true,
  primaryColor: kPrimaryColor,

  colorScheme: ColorScheme.fromSeed(
    seedColor: kPrimaryColor,
    brightness: Brightness.light,

    
    primary: kPrimaryColor,
    onPrimary: kTextLight,
    secondary: kGreenCheckin,
    surface: kBgLightLight,
    onSurface: kTextLight,
    error: kRedRejected,
    onError: kBgLightLight,
  ),

  
  scaffoldBackgroundColor: kBgLight,

  
  textTheme:
      GoogleFonts.poppinsTextTheme(
        ThemeData.light().textTheme, 
      ).copyWith(
        
        bodyLarge: TextStyle(color: kTextLight),
        bodyMedium: TextStyle(color: kTextLight),
        
      ),

  
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




final ThemeData kDarkTheme = ThemeData(
  
  brightness: Brightness.dark,
  useMaterial3: true,
  primaryColor: kPrimaryColor,

  colorScheme: ColorScheme.fromSeed(
    seedColor: kPrimaryColor,
    brightness: Brightness.dark,

    
    primary: kPrimaryColor,
    onPrimary: kTextDark,
    secondary: kGreenCheckin,
    surface: kBgDarkLight,
    onSurface: kTextDark,
    error: kRedRejected,
    onError: kTextDark,
  ),

  
  scaffoldBackgroundColor: kBgDark,

  
  textTheme:
      GoogleFonts.poppinsTextTheme(
        ThemeData.dark().textTheme, 
      ).copyWith(
        
        bodyLarge: TextStyle(color: kTextDark),
        bodyMedium: TextStyle(color: kTextDark),
        
      ),

  
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
