import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../theme/tier_colors.dart';
import '../data/monuments_data.dart';
import '../models/monument.dart';
import '../widgets/frosted_glass_panel.dart';
import '../widgets/map_marker.dart';
import 'chat_screen.dart';

/// Screen 7: "Album Pamięci" - Collection Screen
/// Archive of discoveries styled as a stamp collector album
class CollectionScreen extends StatelessWidget {
  final List<String> discoveredIds;
  
  const CollectionScreen({
    super.key,
    required this.discoveredIds,
  });

  @override
  Widget build(BuildContext context) {
    final allMonuments = MonumentsData.monuments;
    final discovered = allMonuments.where((m) => discoveredIds.contains(m.id)).toList();
    final undiscovered = allMonuments.where((m) => !discoveredIds.contains(m.id)).toList();
    
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: AppTheme.porcelainWhite,
          image: const DecorationImage(
            image: AssetImage('assets/textures/wooden-floor-background.jpg'),
            fit: BoxFit.cover,
            opacity: 0.3,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // App bar
              _buildAppBar(context, discovered.length, allMonuments.length),
              
              // Collection grid
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
      ),
    );
  }
  
  Widget _buildAppBar(BuildContext context, int discovered, int total) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_ios_new),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Album Pamięci',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Text(
                  '$discovered z $total odkrytych',
                  style: TextStyle(
                    color: AppTheme.textMuted,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          // Progress ring
          SizedBox(
            width: 48,
            height: 48,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: discovered / total,
                  backgroundColor: AppTheme.textMuted.withOpacity(0.2),
                  valueColor: const AlwaysStoppedAnimation(AppTheme.oxidizedCopper),
                  strokeWidth: 4,
                ),
                Center(
                  child: Text(
                    '${((discovered / total) * 100).round()}%',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.oxidizedCopper,
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
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            color: AppTheme.oxidizedCopper,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: GoogleFonts.playfairDisplay(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: AppTheme.oxidizedCopper.withOpacity(0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            '$count',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppTheme.oxidizedCopper,
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildGrid(BuildContext context, List<Monument> monuments, bool isDiscovered) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemCount: monuments.length,
      itemBuilder: (context, index) {
        return _buildStampCard(context, monuments[index], isDiscovered);
      },
    );
  }
  
  Widget _buildStampCard(BuildContext context, Monument monument, bool isDiscovered) {
    return GestureDetector(
      onTap: isDiscovered
          ? () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => ChatScreen(monument: monument)),
            )
          : null,
      child: Container(
        decoration: BoxDecoration(
          color: isDiscovered ? Colors.white : Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDiscovered 
                ? monument.tier.color.withOpacity(0.3)
                : Colors.grey.withOpacity(0.3),
            width: 2,
          ),
          boxShadow: isDiscovered
              ? [
                  BoxShadow(
                    color: monument.tier.color.withOpacity(0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Stack(
          children: [
            // Stamp perforated edge effect
            if (isDiscovered)
              Positioned.fill(
                child: CustomPaint(
                  painter: _PerforationPainter(monument.tier.color),
                ),
              ),
            
            // Content
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  // Tier badge
                  Align(
                    alignment: Alignment.topRight,
                    child: TierBadge(
                      tier: monument.tier,
                      showLabel: false,
                      size: 24,
                    ),
                  ),
                  
                  const Spacer(),
                  
                  // Icon
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: isDiscovered
                          ? monument.tier.color.withOpacity(0.15)
                          : Colors.grey.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isDiscovered ? Icons.account_balance : Icons.lock_outline,
                      color: isDiscovered ? monument.tier.color : Colors.grey,
                      size: 30,
                    ),
                  ),
                  
                  const Spacer(),
                  
                  // Name
                  Text(
                    monument.name,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isDiscovered ? AppTheme.textPrimary : Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 4),
                  
                  // Action hint
                  if (isDiscovered)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.replay,
                          size: 12,
                          color: AppTheme.textMuted,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Wspomnienie',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppTheme.textMuted,
                          ),
                        ),
                      ],
                    )
                  else
                    Text(
                      'Nieodkryte',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                ],
              ),
            ),
            
            // Lock overlay for undiscovered
            if (!isDiscovered)
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Painter for stamp perforation effect
class _PerforationPainter extends CustomPainter {
  final Color color;
  
  _PerforationPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.3)
      ..style = PaintingStyle.fill;
    
    const dotRadius = 3.0;
    const spacing = 12.0;
    
    // Top edge
    for (double x = spacing; x < size.width - spacing; x += spacing) {
      canvas.drawCircle(Offset(x, 0), dotRadius, paint);
    }
    
    // Bottom edge
    for (double x = spacing; x < size.width - spacing; x += spacing) {
      canvas.drawCircle(Offset(x, size.height), dotRadius, paint);
    }
    
    // Left edge
    for (double y = spacing; y < size.height - spacing; y += spacing) {
      canvas.drawCircle(Offset(0, y), dotRadius, paint);
    }
    
    // Right edge
    for (double y = spacing; y < size.height - spacing; y += spacing) {
      canvas.drawCircle(Offset(size.width, y), dotRadius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
