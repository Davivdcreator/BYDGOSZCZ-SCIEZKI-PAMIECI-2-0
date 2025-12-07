import 'package:flutter/material.dart';
import 'app_theme.dart';

/// Tier system for monuments - determines AI behavior and visual style
enum MonumentTier {
  tierC, // Echa - Faktograf
  tierB, // Świadkowie - Obserwator
  tierA, // Patroni - Postać
  tierS, // Ikony - Symbol
  tierUnique, // Unikalne - Specjalne
}

extension MonumentTierExtension on MonumentTier {
  /// Display name for the tier
  String get displayName {
    switch (this) {
      case MonumentTier.tierC:
        return 'Echa';
      case MonumentTier.tierB:
        return 'Świadkowie';
      case MonumentTier.tierA:
        return 'Patroni';
      case MonumentTier.tierS:
        return 'Ikony';
      case MonumentTier.tierUnique:
        return 'Unikalne';
    }
  }

  /// Tier letter
  String get letter {
    switch (this) {
      case MonumentTier.tierC:
        return 'C';
      case MonumentTier.tierB:
        return 'B';
      case MonumentTier.tierA:
        return 'A';
      case MonumentTier.tierS:
        return 'S';
      case MonumentTier.tierUnique:
        return 'U';
    }
  }

  /// Color for the tier (Modern palette)
  Color get color {
    switch (this) {
      case MonumentTier.tierC:
        return AppTheme.tierC;
      case MonumentTier.tierB:
        return AppTheme.tierB;
      case MonumentTier.tierA:
        return AppTheme.tierA;
      case MonumentTier.tierS:
        return AppTheme.tierS;
      case MonumentTier.tierUnique:
        return Colors.purpleAccent; // Distinct color for Unique
    }
  }

  /// Light color variant for backgrounds
  Color get lightColor {
    switch (this) {
      case MonumentTier.tierC:
        return AppTheme.tierC.withOpacity(0.1);
      case MonumentTier.tierB:
        return AppTheme.primaryBlueLight.withOpacity(0.15);
      case MonumentTier.tierA:
        return AppTheme.tierA.withOpacity(0.1);
      case MonumentTier.tierS:
        return AppTheme.accentYellowLight.withOpacity(0.2);
      case MonumentTier.tierUnique:
        return Colors.purpleAccent.withOpacity(0.15);
    }
  }

  /// Description of AI behavior
  String get aiBehavior {
    switch (this) {
      case MonumentTier.tierC:
        return 'Faktograf - krótkie fakty historyczne';
      case MonumentTier.tierB:
        return 'Obserwator - nostalgiczne narracje';
      case MonumentTier.tierA:
        return 'Postać - historyczny role-play';
      case MonumentTier.tierS:
        return 'Symbol - metafizyczna immersja';
      case MonumentTier.tierUnique:
        return 'Ekspert - unikalna wiedza specjalistyczna';
    }
  }

  /// Object type description
  String get objectType {
    switch (this) {
      case MonumentTier.tierC:
        return 'Miejsce historyczne';
      case MonumentTier.tierB:
        return 'Pomnik';
      case MonumentTier.tierA:
        return 'Postać historyczna';
      case MonumentTier.tierS:
        return 'Ikona miasta';
      case MonumentTier.tierUnique:
        return 'Unikalna atrakcja';
    }
  }

  /// Voice control availability
  bool get hasVoiceControl =>
      this == MonumentTier.tierS || this == MonumentTier.tierUnique;

  /// Get gradient for this tier
  LinearGradient? get gradient {
    switch (this) {
      case MonumentTier.tierS:
        return AppTheme.accentGradient;
      case MonumentTier.tierB:
        return AppTheme.primaryGradient;
      case MonumentTier.tierUnique:
        return const LinearGradient(
          colors: [Colors.purpleAccent, Colors.deepPurple],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      default:
        return null;
    }
  }
}
