import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/frosted_glass_panel.dart';

/// Screen 6: "Paszport Odkrywcy" - Profile Screen
/// User identity styled as an open passport/document
class ProfileScreen extends StatelessWidget {
  final int discoveredCount;
  final int xp;
  final int level;
  
  const ProfileScreen({
    super.key,
    this.discoveredCount = 0,
    this.xp = 0,
    this.level = 1,
  });
  
  String get rank {
    if (discoveredCount >= 50) return 'Legenda Bydgoszczy';
    if (discoveredCount >= 30) return 'Strażnik Historii';
    if (discoveredCount >= 15) return 'Kronikarz Miejski';
    if (discoveredCount >= 5) return 'Odkrywca';
    return 'Początkujący Odkrywca';
  }

  @override
  Widget build(BuildContext context) {
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
              _buildAppBar(context),
              
              // Passport document
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: _buildPassport(context),
                ),
              ),
            ],
          ),
        ),
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
          Text(
            'Paszport Odkrywcy',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ],
      ),
    );
  }
  
  Widget _buildPassport(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(
          color: AppTheme.copperLight.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          // Header with decorative border
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.oxidizedCopper.withOpacity(0.1),
                  AppTheme.oxidizedCopper.withOpacity(0.05),
                ],
              ),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(14),
              ),
              border: Border(
                bottom: BorderSide(
                  color: AppTheme.oxidizedCopper.withOpacity(0.2),
                  width: 2,
                ),
              ),
            ),
            child: Row(
              children: [
                // Bydgoszcz coat of arms placeholder
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppTheme.oxidizedCopper.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.shield_outlined,
                    color: AppTheme.oxidizedCopper,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ŚCIEŻKI PAMIĘCI',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.oxidizedCopper,
                        letterSpacing: 2,
                      ),
                    ),
                    Text(
                      'BYDGOSZCZ',
                      style: GoogleFonts.roboto(
                        fontSize: 10,
                        color: AppTheme.textMuted,
                        letterSpacing: 3,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Profile photo and info
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Photo
                Container(
                  width: 100,
                  height: 130,
                  decoration: BoxDecoration(
                    color: AppTheme.porcelainWhite,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppTheme.textMuted.withOpacity(0.3),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.person,
                        size: 50,
                        color: AppTheme.textMuted.withOpacity(0.5),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'ZDJĘCIE',
                        style: TextStyle(
                          fontSize: 10,
                          color: AppTheme.textMuted.withOpacity(0.5),
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(width: 20),
                
                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow('RANGA', rank),
                      const SizedBox(height: 12),
                      _buildInfoRow('POZIOM', 'Poziom $level'),
                      const SizedBox(height: 12),
                      _buildInfoRow('DATA DOŁĄCZENIA', '6 Grudnia 2024'),
                      const SizedBox(height: 12),
                      _buildInfoRow('ID', '#BD2024001'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Decorative divider
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  AppTheme.oxidizedCopper.withOpacity(0.3),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          
          // Statistics
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'STATYSTYKI',
                  style: GoogleFonts.roboto(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textMuted,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildStatCard(
                      Icons.route,
                      '2.5 km',
                      'Przebyte',
                      AppTheme.riverBlue,
                    ),
                    const SizedBox(width: 12),
                    _buildStatCard(
                      Icons.chat_bubble_outline,
                      '7',
                      'Rozmów',
                      AppTheme.oxidizedCopper,
                    ),
                    const SizedBox(width: 12),
                    _buildStatCard(
                      Icons.explore_outlined,
                      '$discoveredCount',
                      'Odkryć',
                      AppTheme.oldGold,
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // XP Progress
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'DOŚWIADCZENIE',
                      style: GoogleFonts.roboto(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textMuted,
                        letterSpacing: 2,
                      ),
                    ),
                    Text(
                      '$xp / ${(level + 1) * 500} XP',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.oxidizedCopper,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: (xp % 500) / 500,
                    backgroundColor: AppTheme.textMuted.withOpacity(0.1),
                    valueColor: const AlwaysStoppedAnimation(AppTheme.oxidizedCopper),
                    minHeight: 12,
                  ),
                ),
              ],
            ),
          ),
          
          // Badges section (Gablota Chwały)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppTheme.oxidizedCopper.withOpacity(0.05),
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(14),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.emoji_events,
                      color: AppTheme.oldGold,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'GABLOTA CHWAŁY',
                      style: GoogleFonts.roboto(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textMuted,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Empty state
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.textMuted.withOpacity(0.2),
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.military_tech_outlined,
                        size: 40,
                        color: AppTheme.textMuted.withOpacity(0.3),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Ukończ wyzwania, aby zdobyć odznaki',
                        style: TextStyle(
                          color: AppTheme.textMuted,
                          fontSize: 13,
                        ),
                        textAlign: TextAlign.center,
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
  
  Widget _buildInfoRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: AppTheme.textMuted,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
      ],
    );
  }
  
  Widget _buildStatCard(IconData icon, String value, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withOpacity(0.2),
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: AppTheme.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
