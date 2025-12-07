import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../theme/tier_colors.dart';
import '../data/monuments_data.dart';
import '../models/monument.dart';
import 'chat_screen.dart';

/// Screen 7: Collection - Clean grid design
class CollectionScreen extends StatelessWidget {
  final List<String> discoveredIds;

  const CollectionScreen({
    super.key,
    required this.discoveredIds,
  });

  @override
  Widget build(BuildContext context) {
    const allMonuments = MonumentsData.monuments;
    final discovered =
        allMonuments.where((m) => discoveredIds.contains(m.id)).toList();
    final undiscovered =
        allMonuments.where((m) => !discoveredIds.contains(m.id)).toList();

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(context, discovered.length, allMonuments.length),

            // Grid
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (discovered.isNotEmpty) ...[
                      _buildSectionHeader('Odkryte miejsca', discovered.length),
                      const SizedBox(height: 12),
                      _buildGrid(context, discovered, true),
                      const SizedBox(height: 24),
                    ],
                    if (undiscovered.isNotEmpty) ...[
                      _buildSectionHeader('Do odkrycia', undiscovered.length),
                      const SizedBox(height: 12),
                      _buildGrid(context, undiscovered, false),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, int discovered, int total) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Album',
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '$discovered z $total odkrytych',
                  style: GoogleFonts.inter(
                    color: AppTheme.textMuted,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          // Progress ring
          SizedBox(
            width: 44,
            height: 44,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: discovered / total,
                  backgroundColor: AppTheme.surfaceSecondary,
                  valueColor:
                      const AlwaysStoppedAnimation(AppTheme.primaryBlue),
                  strokeWidth: 4,
                ),
                Center(
                  child: Text(
                    '${((discovered / total) * 100).round()}%',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryBlue,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, int count) {
    return Row(
      children: [
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: AppTheme.primaryBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            '$count',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryBlue,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGrid(
      BuildContext context, List<Monument> monuments, bool isDiscovered) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.9,
      ),
      itemCount: monuments.length,
      itemBuilder: (context, index) {
        return _buildCard(context, monuments[index], isDiscovered);
      },
    );
  }

  Widget _buildCard(
      BuildContext context, Monument monument, bool isDiscovered) {
    return GestureDetector(
      onTap: isDiscovered
          ? () => Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (_) => ChatScreen(monument: monument)),
              )
          : null,
      child: Container(
        decoration: BoxDecoration(
          color: isDiscovered ? AppTheme.background : AppTheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: isDiscovered ? AppTheme.subtleShadow : null,
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Tier badge
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: isDiscovered
                            ? monument.tier.color.withOpacity(0.1)
                            : AppTheme.surfaceSecondary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        monument.tier.letter,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isDiscovered
                              ? monument.tier.color
                              : AppTheme.textMuted,
                        ),
                      ),
                    ),
                  ),

                  const Spacer(),

                  // Icon
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: isDiscovered
                          ? monument.tier.lightColor
                          : AppTheme.surfaceSecondary,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isDiscovered ? Icons.account_balance : Icons.lock_outline,
                      color: isDiscovered
                          ? monument.tier.color
                          : AppTheme.textMuted,
                      size: 26,
                    ),
                  ),

                  const Spacer(),

                  // Name
                  Text(
                    monument.name,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: isDiscovered
                          ? AppTheme.textPrimary
                          : AppTheme.textMuted,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 4),

                  Text(
                    isDiscovered ? 'Wspomnienie' : 'Nieodkryte',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: isDiscovered
                          ? AppTheme.primaryBlue
                          : AppTheme.textMuted,
                    ),
                  ),
                ],
              ),
            ),

            // Lock overlay
            if (!isDiscovered)
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
