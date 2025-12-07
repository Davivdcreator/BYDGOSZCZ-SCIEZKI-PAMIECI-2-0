import 'dart:math';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../theme/tier_colors.dart';

/// Model representing a monument/POI in Bydgoszcz
class Monument {
  final String id;
  final String name;
  final String description;
  final String shortDescription;
  final LatLng location;
  final MonumentTier tier;
  final String imageUrl;
  final String? architect;
  final int? year;
  final String? style;
  final List<String> tags;
  final String aiPersonality;
  final List<String> sampleQuestions;

  const Monument({
    required this.id,
    required this.name,
    required this.description,
    required this.shortDescription,
    required this.location,
    required this.tier,
    required this.imageUrl,
    this.architect,
    this.year,
    this.style,
    this.tags = const [],
    required this.aiPersonality,
    this.sampleQuestions = const [],
  });

  /// Check if monument is discovered by user
  bool isDiscovered(List<String> discoveredIds) => discoveredIds.contains(id);

  /// Get tier color
  Color get tierColor => tier.color;

  /// Get tier display name
  String get tierName => tier.displayName;

  factory Monument.fromFirestore(Map<String, dynamic> data, String id) {
    // Better safe parsing
    double lat = 53.1235;
    double lng = 18.0084;

    if (data['location'] != null) {
      final loc = data['location'];
      // Check if it has latitude/longitude properties (GeoPoint)
      try {
        lat = loc.latitude;
        lng = loc.longitude;
      } catch (e) {
        // Fallback for Map
        if (loc is Map) {
          lat = (loc['latitude'] as num?)?.toDouble() ?? 53.1235;
          lng = (loc['longitude'] as num?)?.toDouble() ?? 18.0084;
        }
      }
    }

    // Fix stacking: if coordinates are EXACTLY default, add random jitter
    if ((lat - 53.1235).abs() < 0.0001 && (lng - 18.0084).abs() < 0.0001) {
      final random = Random(id.hashCode);
      // Spread within ~1km radius
      lat += (random.nextDouble() - 0.5) * 0.02;
      lng += (random.nextDouble() - 0.5) * 0.02;
    }

    return Monument(
      id: id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      shortDescription: data['shortDescription'] ?? '',
      location: LatLng(lat, lng),
      tier: _parseTier(data['tier']),
      imageUrl: data['imageUrl'] ?? '',
      architect: data['architect'],
      year: data['year'],
      style: data['style'],
      tags: List<String>.from(data['tags'] ?? []),
      aiPersonality: data['aiPersonality'] ?? 'Jestem monumentem w Bydgoszczy.',
      sampleQuestions: List<String>.from(data['sampleQuestions'] ?? []),
    );
  }

  static MonumentTier _parseTier(String? tierStr) {
    if (tierStr == null) return MonumentTier.tierB;
    try {
      return MonumentTier.values.firstWhere(
        (e) => e.toString().split('.').last == tierStr,
        orElse: () => MonumentTier.tierB,
      );
    } catch (_) {
      return MonumentTier.tierB;
    }
  }
}
