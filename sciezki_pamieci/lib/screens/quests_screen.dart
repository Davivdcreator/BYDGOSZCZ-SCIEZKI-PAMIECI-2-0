import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../data/monuments_data.dart';
import '../models/badge.dart';
import '../widgets/frosted_glass_panel.dart';
import '../widgets/copper_button.dart';

/// Screen 8: "Ścieżki i Odznaczenia" - Quests & Badges Screen
/// Gamification and thematic rewards
class QuestsScreen extends StatefulWidget {
  final List<String> discoveredIds;
  
  const QuestsScreen({
    super.key,
    required this.discoveredIds,
  });

  @override
  State<QuestsScreen> createState() => _QuestsScreenState();
}

class _QuestsScreenState extends State<QuestsScreen> {
  bool _showBadgeAnimation = false;
  Badge? _unlockedBadge;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
          Container(
            decoration: BoxDecoration(
              color: AppTheme.porcelainWhite,
              image: const DecorationImage(
                image: AssetImage('assets/textures/wooden-floor-background.jpg'),
                fit: BoxFit.cover,
                opacity: 0.3,
              ),
            ),
          ),
          
          // Main content
          SafeArea(
            child: Column(
              children: [
                // App bar
                _buildAppBar(context),
                
                // Quests list
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: QuestsData.quests.length,
                    itemBuilder: (context, index) {
                      return _buildQuestCard(QuestsData.quests[index]);
                    },
                  ),
                ),
              ],
            ),
          ),
          
          // Badge unlock animation overlay
          if (_showBadgeAnimation && _unlockedBadge != null)
            _buildBadgeAnimation(_unlockedBadge!),
        ],
      ),
    );
  }
  
  Widget _buildAppBar(BuildContext context) {
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
                  'Ścieżki i Odznaczenia',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Text(
                  'Ukończ wyzwania, zdobądź nagrody',
                  style: TextStyle(
                    color: AppTheme.textMuted,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildQuestCard(Quest quest) {
    final completedCount = quest.completedCount(widget.discoveredIds);
    final totalCount = quest.monumentIds.length;
    final progress = quest.progress(widget.discoveredIds);
    final isComplete = quest.isComplete(widget.discoveredIds);
    
    Color themeColor;
    switch (quest.themeColor) {
      case 'gold':
        themeColor = AppTheme.oldGold;
        break;
      case 'silver':
        themeColor = AppTheme.tierA;
        break;
      default:
        themeColor = AppTheme.oxidizedCopper;
    }
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isComplete 
              ? themeColor.withOpacity(0.5)
              : AppTheme.textMuted.withOpacity(0.2),
          width: isComplete ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isComplete 
                ? themeColor.withOpacity(0.2)
                : Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: themeColor.withOpacity(0.1),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(15),
              ),
            ),
            child: Row(
              children: [
                // Quest icon
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: themeColor.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isComplete ? Icons.check_circle : Icons.flag_outlined,
                    color: themeColor,
                    size: 24,
                  ),
                ),
                
                const SizedBox(width: 12),
                
                // Title and description
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        quest.name,
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        quest.description,
                        style: TextStyle(
                          fontSize: 13,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Progress section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Progress bar
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: progress,
                          backgroundColor: themeColor.withOpacity(0.15),
                          valueColor: AlwaysStoppedAnimation(themeColor),
                          minHeight: 10,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '$completedCount/$totalCount',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: themeColor,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Monuments list
                ...quest.monumentIds.map((id) {
                  final monument = MonumentsData.getById(id);
                  final isCompleted = widget.discoveredIds.contains(id);
                  
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Icon(
                          isCompleted 
                              ? Icons.check_circle 
                              : Icons.radio_button_unchecked,
                          color: isCompleted ? themeColor : AppTheme.textMuted,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          monument?.name ?? id,
                          style: TextStyle(
                            color: isCompleted 
                                ? AppTheme.textPrimary 
                                : AppTheme.textMuted,
                            decoration: isCompleted 
                                ? null 
                                : null,
                            fontWeight: isCompleted 
                                ? FontWeight.w500 
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                
                const SizedBox(height: 16),
                
                // Reward preview
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.porcelainWhite,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: themeColor.withOpacity(0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: themeColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.military_tech,
                          color: themeColor,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'NAGRODA',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textMuted,
                                letterSpacing: 1,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              quest.reward.name,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: themeColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (isComplete)
                        CopperButton(
                          text: 'ODBIERZ',
                          onPressed: () => _showBadgeUnlock(quest.reward),
                          useGoldGradient: quest.themeColor == 'gold',
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  void _showBadgeUnlock(Badge badge) {
    setState(() {
      _showBadgeAnimation = true;
      _unlockedBadge = badge;
    });
  }
  
  Widget _buildBadgeAnimation(Badge badge) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _showBadgeAnimation = false;
          _unlockedBadge = null;
        });
      },
      child: Container(
        color: Colors.black.withOpacity(0.85),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Title
              Text(
                'ODZNAKA ZDOBYTA!',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.oldGold,
                  letterSpacing: 2,
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Badge
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(milliseconds: 800),
                curve: Curves.elasticOut,
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: child,
                  );
                },
                child: Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppTheme.copperGradient,
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.oxidizedCopper.withOpacity(0.5),
                        blurRadius: 40,
                        spreadRadius: 10,
                      ),
                    ],
                    border: Border.all(
                      color: AppTheme.copperLight,
                      width: 4,
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Inner ring
                      Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                      ),
                      // Icon
                      const Icon(
                        Icons.music_note,
                        color: Colors.white,
                        size: 60,
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Badge name
              Text(
                badge.name,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              
              const SizedBox(height: 12),
              
              // Description
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  badge.description,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.8),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              
              if (badge.unlockedTopic != null) ...[
                const SizedBox(height: 24),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.oldGold.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.oldGold.withOpacity(0.5),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.auto_awesome,
                        color: AppTheme.oldGold,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'BONUS: ${badge.unlockedTopic}',
                          style: const TextStyle(
                            color: AppTheme.oldGold,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              
              const SizedBox(height: 48),
              
              // Close hint
              Text(
                'Dotknij, aby zamknąć',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
