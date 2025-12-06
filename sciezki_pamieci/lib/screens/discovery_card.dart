import 'package:flutter/material.dart';
import 'dart:ui';
import '../theme/app_theme.dart';
import '../models/monument.dart';
import '../widgets/frosted_glass_panel.dart';
import '../widgets/copper_button.dart';
import '../widgets/map_marker.dart';
import 'chat_screen.dart';

/// Screen 4: Discovery Card - Bottom Sheet for POI details
/// Gateway to knowledge (before conversation)
class DiscoveryCard extends StatelessWidget {
  final Monument monument;
  final bool isDiscovered;
  final VoidCallback? onDiscover;
  
  const DiscoveryCard({
    super.key,
    required this.monument,
    this.isDiscovered = false,
    this.onDiscover,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    
    return Container(
      height: screenHeight * 0.75,
      decoration: BoxDecoration(
        color: AppTheme.porcelainWhite,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        image: const DecorationImage(
          image: AssetImage('assets/textures/wooden-floor-background.jpg'),
          fit: BoxFit.cover,
          opacity: 0.15,
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppTheme.textMuted.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Image section
          Expanded(
            flex: 4,
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Placeholder image with gradient
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            monument.tier.color.withOpacity(0.3),
                            monument.tier.color.withOpacity(0.6),
                          ],
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.account_balance,
                          size: 80,
                          color: Colors.white.withOpacity(0.5),
                        ),
                      ),
                    ),
                    
                    // Gradient overlay
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.7),
                            ],
                          ),
                        ),
                      ),
                    ),
                    
                    // Tier badge
                    Positioned(
                      top: 12,
                      right: 12,
                      child: TierBadge(
                        tier: monument.tier,
                        showLabel: false,
                        size: 40,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Content section
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and year
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          monument.name,
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (monument.year != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: monument.tier.color.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: monument.tier.color.withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            '${monument.year}',
                            style: TextStyle(
                              color: monument.tier.color,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Tags (Hard Data)
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      if (monument.style != null)
                        _buildTag(monument.style!, Icons.architecture),
                      if (monument.architect != null)
                        _buildTag(monument.architect!, Icons.person_outline),
                      ...monument.tags.take(2).map((tag) => 
                        _buildTag(tag, Icons.label_outline),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Short description
                  Text(
                    monument.shortDescription,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppTheme.textSecondary,
                      height: 1.5,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const Spacer(),
                  
                  // Talk button
                  Center(
                    child: CopperButton(
                      text: 'POROZMAWIAJ',
                      icon: Icons.edit_note,
                      isLarge: true,
                      isPulsing: true,
                      useGoldGradient: monument.tier == MonumentTier.tierS,
                      onPressed: () {
                        onDiscover?.call();
                        Navigator.of(context).pop();
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ChatScreen(monument: monument),
                          ),
                        );
                      },
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildTag(String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.frostedGlass,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.textMuted.withOpacity(0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppTheme.textMuted),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
