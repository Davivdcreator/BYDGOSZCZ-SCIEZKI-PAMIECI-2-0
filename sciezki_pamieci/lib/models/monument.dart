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
  get tierColor => tier.color;
  
  /// Get tier display name
  get tierName => tier.displayName;
}
