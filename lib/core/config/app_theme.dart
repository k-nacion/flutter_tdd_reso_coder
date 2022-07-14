import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static final AppTheme _instance = AppTheme._();

  AppTheme._();

  factory AppTheme() => _instance;

  static ThemeData lightTheme() => FlexThemeData.light(
        scheme: FlexScheme.espresso,
        surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
        blendLevel: 20,
        appBarOpacity: 0.95,
        swapColors: true,
        subThemesData: const FlexSubThemesData(
          blendOnLevel: 20,
          blendOnColors: false,
          defaultRadius: 5,
        ),
        useMaterial3ErrorColors: true,
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        useMaterial3: true,
        // To use the playground font, add GoogleFonts package and uncomment
        // fontFamily: GoogleFonts.notoSans().fontFamily,
      );

  static ThemeData darkTheme() =>
      FlexThemeData.dark(fontFamily: GoogleFonts.quicksand().fontFamily);
}
