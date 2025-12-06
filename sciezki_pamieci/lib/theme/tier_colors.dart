import 'package:flutter/material.dart';
import 'app_theme.dart';

/// Tier system for monuments - determines AI behavior depth
enum MonumentTier {
  /// Tier C - Echa (Echoes) - Basic factoids
  tierC,
  
  /// Tier B - Świadkowie (Witnesses) - Nostalgic observer
  tierB,
  
  /// Tier A - Patroni (Patrons) - Historical role-play
  tierA,
  
  /// Tier S - Ikony (Icons) - Metaphysical immersion
  tierS,
}

extension TierExtension on MonumentTier {
  /// Display name in Polish
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
    }
  }
  
  /// English subtitle
  String get englishName {
    switch (this) {
      case MonumentTier.tierC:
        return 'Echoes';
      case MonumentTier.tierB:
        return 'Witnesses';
      case MonumentTier.tierA:
        return 'Patrons';
      case MonumentTier.tierS:
        return 'Icons';
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
    }
  }
  
  /// UI color for the tier
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
    }
  }
  
  /// Description of AI behavior
  String get aiDescription {
    switch (this) {
      case MonumentTier.tierC:
        return 'Faktograf - krótkie cytaty i ciekawostki historyczne';
      case MonumentTier.tierB:
        return 'Obserwator - nostalgiczne opowieści o dawnym życiu ulicy';
      case MonumentTier.tierA:
        return 'Postać - pełne wcielenie w rolę historyczną z emocjami';
      case MonumentTier.tierS:
        return 'Symbol - metafizyczna rozmowa o uniwersalnych wartościach';
    }
  }
  
  /// Object types for this tier
  String get objectTypes {
    switch (this) {
      case MonumentTier.tierC:
        return 'Tablice pamiątkowe, detale architektoniczne, mniejsze rzeźby';
      case MonumentTier.tierB:
        return 'Kamienice, mosty, bramy, budynki użyteczności publicznej';
      case MonumentTier.tierA:
        return 'Pomniki postaci, kluczowe zabytki (Fara, Opera)';
      case MonumentTier.tierS:
        return 'Łuczniczka, Przechodzący przez rzekę, Spichrze';
    }
  }
  
  /// Whether voice control is available
  bool get hasVoiceControl => this == MonumentTier.tierS;
  
  /// Gradient for premium tiers
  LinearGradient? get gradient {
    switch (this) {
      case MonumentTier.tierB:
        return AppTheme.copperGradient;
      case MonumentTier.tierS:
        return AppTheme.goldGradient;
      default:
        return null;
    }
  }
}
