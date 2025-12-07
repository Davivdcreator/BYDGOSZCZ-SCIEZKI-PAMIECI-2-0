import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import '../theme/app_theme.dart';
import '../theme/tier_colors.dart';
import '../models/monument.dart';
import '../widgets/copper_button.dart';
import 'chat_screen.dart';

/// Screen 4: Discovery Card - Minimalist location widget
/// Inspired by modern app design with clean spacing
class DiscoveryCard extends StatelessWidget {
  final Monument monument;
  final bool isDiscovered;
  final VoidCallback? onDiscover;
  final LatLng? userLocation;

  const DiscoveryCard({
    super.key,
    required this.monument,
    this.isDiscovered = false,
    this.onDiscover,
    this.userLocation,
  });

  /// Calculate distance in meters from user to monument
  double? _calculateDistanceMeters() {
    if (userLocation == null) return null;
    const distance = Distance();
    return distance.as(
      LengthUnit.Meter,
      userLocation!,
      monument.location,
    );
  }

  /// Format distance for display
  String _formatDistance(double? meters) {
    if (meters == null) return 'Nieznana odległość';
    if (meters < 1000) {
      return '${meters.round()} m';
    } else {
      return '${(meters / 1000).toStringAsFixed(1)} km';
    }
  }

  /// Estimate walking time (average 5 km/h = 83.3 m/min)
  String _estimateWalkingTime(double? meters) {
    if (meters == null) return '~? min';
    const walkingSpeedMetersPerMinute = 83.3;
    final minutes = meters / walkingSpeedMetersPerMinute;
    if (minutes < 1) {
      return '<1 min';
    } else if (minutes < 60) {
      return '~${minutes.round()} min';
    } else {
      final hours = (minutes / 60).floor();
      final remainingMinutes = (minutes % 60).round();
      return '~${hours}h ${remainingMinutes}min';
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.55,
      minChildSize: 0.3,
      maxChildSize: 0.85,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: AppTheme.background,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle bar
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 12),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceSecondary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),

                // Image with heart
                _buildImageSection(),

                // Content
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        monument.name,
                        style: GoogleFonts.inter(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimary,
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Short description
                      Text(
                        monument.shortDescription,
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          color: AppTheme.textSecondary,
                          height: 1.5,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Metadata row
                      _buildMetadataRow(),

                      const SizedBox(height: 16),

                      // Tags
                      _buildTags(),

                      const SizedBox(height: 24),

                      // CTA Button
                      SizedBox(
                        width: double.infinity,
                        child: GradientButton(
                          text: 'Porozmawiaj',
                          icon: Icons.chat_bubble_outline,
                          isLarge: true,
                          onPressed: () => _openChat(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildImageSection() {
    return Stack(
      children: [
        // Image placeholder
        Container(
          margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          height: 200,
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          clipBehavior: Clip.antiAlias,
          child: Image.network(
            monument.imageUrl,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey[200],
                child: const Center(
                  child: Icon(
                    Icons.image_not_supported,
                    color: Colors.grey,
                    size: 40,
                  ),
                ),
              );
            },
          ),
        ),

        // Tier badge
        Positioned(
          top: 28,
          left: 28,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: monument.tier.color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              monument.tier.displayName,
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: monument.tier == MonumentTier.tierS
                    ? AppTheme.textPrimary
                    : Colors.white,
              ),
            ),
          ),
        ),

        // Heart button
        Positioned(
          top: 28,
          right: 28,
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.favorite_border,
              color: Colors.white,
              size: 18,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMetadataRow() {
    final distanceMeters = _calculateDistanceMeters();
    final walkingTime = _estimateWalkingTime(distanceMeters);
    final distanceText = _formatDistance(distanceMeters);

    return Row(
      children: [
        const Icon(
          Icons.schedule,
          size: 16,
          color: AppTheme.textMuted,
        ),
        const SizedBox(width: 4),
        Text(
          walkingTime,
          style: GoogleFonts.inter(
            fontSize: 13,
            color: AppTheme.textSecondary,
          ),
        ),
        const SizedBox(width: 16),
        const Icon(
          Icons.location_on_outlined,
          size: 16,
          color: AppTheme.textMuted,
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            distanceText,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: AppTheme.primaryBlue,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildTags() {
    final tags = monument.tags ?? ['Pomnik', 'Historia'];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: tags
          .map((tag) => PillTag(
                text: tag,
                color: AppTheme.primaryBlue,
              ))
          .toList(),
    );
  }

  void _openChat(BuildContext context) {
    onDiscover?.call();
    Navigator.of(context).pop();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ChatScreen(monument: monument),
      ),
    );
  }
}
