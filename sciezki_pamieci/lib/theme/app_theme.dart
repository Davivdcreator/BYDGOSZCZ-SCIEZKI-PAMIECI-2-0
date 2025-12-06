import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Design System: "Modern Heritage" - Papier, Miedź, Szkło
/// Filozofia: Szlachetny, cyfrowy przewodnik - unikamy estetyki typowej gry mobile

class AppTheme {
  // ============== COLOR PALETTE ==============
  
  /// Tło: Porcelain White - faktura papieru czerpanego
  static const Color porcelainWhite = Color(0xFFF5F2EB);
  
  /// Panele: Frosted Glass - mrożone szkło
  static const Color frostedGlass = Color(0xB3FFFFFF);
  static const Color frostedGlassBorder = Color(0x33FFFFFF);
  
  /// Akcent główny: Oxidized Copper - Bydgoska Miedź
  static const Color oxidizedCopper = Color(0xFFB87333);
  static const Color copperLight = Color(0xFFD4956A);
  static const Color copperDark = Color(0xFF8B5A2B);
  
  /// Akcent premium: Old Gold - dla najwyższych rang
  static const Color oldGold = Color(0xFFCFB53B);
  static const Color goldLight = Color(0xFFE5D06B);
  static const Color goldDark = Color(0xFFA69121);
  
  /// Neutralne
  static const Color textPrimary = Color(0xFF2C2C2C);
  static const Color textSecondary = Color(0xFF6B6B6B);
  static const Color textMuted = Color(0xFF9A9A9A);
  
  /// Rzeka Brda - akwarela
  static const Color riverBlue = Color(0xFF7BA3C4);
  static const Color riverBlueLight = Color(0xFFB8D4E8);
  
  /// Sepia filter dla onboardingu
  static const Color sepiaOverlay = Color(0x66A67C52);
  
  // ============== TIER COLORS ==============
  
  /// Tier C - Echa (Echoes) - Grafit
  static const Color tierC = Color(0xFF4A4A4A);
  
  /// Tier B - Świadkowie (Witnesses) - Miedź
  static const Color tierB = oxidizedCopper;
  
  /// Tier A - Patroni (Patrons) - Srebro/Stal
  static const Color tierA = Color(0xFFC0C0C0);
  
  /// Tier S - Ikony (Icons) - Złoto
  static const Color tierS = oldGold;
  
  // ============== TYPOGRAPHY ==============
  
  static TextTheme get textTheme => TextTheme(
    // Tytuły - szeryfowa (Playfair Display style)
    displayLarge: GoogleFonts.playfairDisplay(
      fontSize: 48,
      fontWeight: FontWeight.bold,
      color: textPrimary,
      letterSpacing: -1,
    ),
    displayMedium: GoogleFonts.playfairDisplay(
      fontSize: 36,
      fontWeight: FontWeight.bold,
      color: textPrimary,
    ),
    displaySmall: GoogleFonts.playfairDisplay(
      fontSize: 28,
      fontWeight: FontWeight.w600,
      color: textPrimary,
    ),
    headlineLarge: GoogleFonts.playfairDisplay(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: textPrimary,
    ),
    headlineMedium: GoogleFonts.playfairDisplay(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: textPrimary,
    ),
    headlineSmall: GoogleFonts.playfairDisplay(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: textPrimary,
    ),
    
    // Body - sans-serif (Roboto)
    titleLarge: GoogleFonts.roboto(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: textPrimary,
    ),
    titleMedium: GoogleFonts.roboto(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: textPrimary,
    ),
    titleSmall: GoogleFonts.roboto(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: textSecondary,
    ),
    bodyLarge: GoogleFonts.roboto(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: textPrimary,
      height: 1.5,
    ),
    bodyMedium: GoogleFonts.roboto(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: textPrimary,
      height: 1.5,
    ),
    bodySmall: GoogleFonts.roboto(
      fontSize: 12,
      fontWeight: FontWeight.normal,
      color: textSecondary,
      height: 1.4,
    ),
    labelLarge: GoogleFonts.roboto(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: Colors.white,
      letterSpacing: 0.5,
    ),
    labelMedium: GoogleFonts.roboto(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: textSecondary,
    ),
    labelSmall: GoogleFonts.roboto(
      fontSize: 10,
      fontWeight: FontWeight.w500,
      color: textMuted,
      letterSpacing: 0.5,
    ),
  );
  
  // ============== THEME DATA ==============
  
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      primary: oxidizedCopper,
      primaryContainer: copperLight,
      secondary: oldGold,
      secondaryContainer: goldLight,
      surface: porcelainWhite,
      background: porcelainWhite,
      error: const Color(0xFFB00020),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: textPrimary,
      onBackground: textPrimary,
    ),
    scaffoldBackgroundColor: porcelainWhite,
    textTheme: textTheme,
    appBarTheme: AppBarTheme(
      backgroundColor: frostedGlass,
      foregroundColor: textPrimary,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.playfairDisplay(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: oxidizedCopper,
      foregroundColor: Colors.white,
      elevation: 8,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: oxidizedCopper,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: GoogleFonts.roboto(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    ),
    cardTheme: CardTheme(
      color: frostedGlass,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: frostedGlassBorder, width: 1),
      ),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: frostedGlass,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: frostedGlassBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: frostedGlassBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: oxidizedCopper, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
  );
  
  // ============== DECORATIONS ==============
  
  /// Frosted glass effect decoration
  static BoxDecoration get frostedGlassDecoration => BoxDecoration(
    color: frostedGlass,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: frostedGlassBorder, width: 1),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        blurRadius: 20,
        offset: const Offset(0, 4),
      ),
    ],
  );
  
  /// Paper texture background decoration
  static BoxDecoration paperTextureDecoration(String texturePath) => BoxDecoration(
    color: porcelainWhite,
    image: DecorationImage(
      image: AssetImage(texturePath),
      fit: BoxFit.cover,
      opacity: 0.45,
    ),
  );
  
  /// Copper gradient for buttons and accents
  static const LinearGradient copperGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [copperLight, oxidizedCopper, copperDark],
  );
  
  /// Gold gradient for S-tier elements
  static const LinearGradient goldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [goldLight, oldGold, goldDark],
  );
}
