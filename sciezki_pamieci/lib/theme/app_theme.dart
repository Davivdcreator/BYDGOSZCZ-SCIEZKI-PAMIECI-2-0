import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Design System: "Modern Vintage Light"
/// Kolory z logo Bydgoszczy + minimalistyczny, jasny design

class AppTheme {
  // ============== COLOR PALETTE (Bydgoszcz Logo) ==============

  /// Primary: Blue from Bydgoszcz logo
  static const Color primaryBlue = Color(0xFF2B7BBF);
  static const Color primaryBlueLight = Color(0xFF4A9AD4);
  static const Color primaryBlueDark = Color(0xFF1E5A8C);

  /// Accent: Yellow/Gold from Bydgoszcz logo
  static const Color accentYellow = Color(0xFFF5C842);
  static const Color accentYellowLight = Color(0xFFFAD86B);
  static const Color accentYellowDark = Color(0xFFD4A833);

  /// Warm Red from Bydgoszcz logo
  static const Color warmRed = Color(0xFFE85A4F);

  /// Backgrounds - Clean White
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFF8FAFC);
  static const Color surfaceSecondary = Color(0xFFF1F5F9);

  /// Text colors
  static const Color textPrimary = Color(0xFF1A202C);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textMuted = Color(0xFF94A3B8);

  /// Glass effect
  static const Color glassWhite = Color(0xE6FFFFFF);
  static const Color glassBorder = Color(0x33000000);

  // ============== TIER COLORS ==============

  /// Tier C - Echa (slate gray)
  static const Color tierC = Color(0xFF94A3B8);

  /// Tier B - Świadkowie (primary blue)
  static const Color tierB = primaryBlue;

  /// Tier A - Patroni (violet)
  static const Color tierA = Color(0xFF8B5CF6);

  /// Tier S - Ikony (gold)
  static const Color tierS = accentYellow;

  // Legacy aliases for backwards compatibility
  static const Color porcelainWhite = background;
  static const Color frostedGlass = glassWhite;
  static const Color frostedGlassBorder = glassBorder;
  static const Color oxidizedCopper = primaryBlue;
  static const Color copperLight = primaryBlueLight;
  static const Color copperDark = primaryBlueDark;
  static const Color oldGold = accentYellow;
  static const Color goldLight = accentYellowLight;
  static const Color goldDark = accentYellowDark;
  static const Color riverBlue = Color(0xFF7BA3C4);
  static const Color riverBlueLight = Color(0xFFB8D4E8);
  static const Color sepiaOverlay = Color(0x66A67C52);

  // ============== TYPOGRAPHY (Inter) ==============

  static TextTheme get textTheme => TextTheme(
        // Headlines - Inter SemiBold
        displayLarge: GoogleFonts.inter(
          fontSize: 48,
          fontWeight: FontWeight.w600,
          color: textPrimary,
          letterSpacing: -1,
        ),
        displayMedium: GoogleFonts.inter(
          fontSize: 36,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        displaySmall: GoogleFonts.inter(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        headlineLarge: GoogleFonts.inter(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        headlineMedium: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        headlineSmall: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: textPrimary,
        ),

        // Body - Inter Regular
        titleLarge: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: textPrimary,
        ),
        titleMedium: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: textPrimary,
        ),
        titleSmall: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: textSecondary,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: textPrimary,
          height: 1.5,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: textPrimary,
          height: 1.5,
        ),
        bodySmall: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: textSecondary,
          height: 1.4,
        ),
        labelLarge: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.white,
          letterSpacing: 0.5,
        ),
        labelMedium: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: textSecondary,
        ),
        labelSmall: GoogleFonts.inter(
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
        colorScheme: const ColorScheme.light(
          primary: primaryBlue,
          primaryContainer: primaryBlueLight,
          secondary: accentYellow,
          secondaryContainer: accentYellowLight,
          surface: background,
          error: warmRed,
          onPrimary: Colors.white,
          onSecondary: textPrimary,
          onSurface: textPrimary,
        ),
        scaffoldBackgroundColor: background,
        textTheme: textTheme,
        appBarTheme: AppBarTheme(
          backgroundColor: background,
          foregroundColor: textPrimary,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: textPrimary,
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          elevation: 4,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryBlue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0,
            textStyle: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        cardTheme: const CardThemeData(
          color: background,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
        ),
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: surfaceSecondary),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: primaryBlue, width: 2),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      );

  // ============== DECORATIONS ==============

  /// Clean card shadow
  static List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: Colors.black.withOpacity(0.06),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ];

  /// Subtle shadow
  static List<BoxShadow> get subtleShadow => [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ];

  /// Clean glass decoration
  static BoxDecoration get glassDecoration => BoxDecoration(
        color: glassWhite,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.5), width: 1),
        boxShadow: subtleShadow,
      );

  /// Card decoration
  static BoxDecoration get cardDecoration => BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
        boxShadow: cardShadow,
      );

  /// Primary gradient (Blue)
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryBlueLight, primaryBlue, primaryBlueDark],
  );

  /// Accent gradient (Yellow)
  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accentYellowLight, accentYellow, accentYellowDark],
  );

  // Legacy aliases
  static const LinearGradient copperGradient = primaryGradient;
  static const LinearGradient goldGradient = accentGradient;

  static BoxDecoration get frostedGlassDecoration => glassDecoration;

  static BoxDecoration paperTextureDecoration(String texturePath) =>
      const BoxDecoration(
        color: background,
      );
}
