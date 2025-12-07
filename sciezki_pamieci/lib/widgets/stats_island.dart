import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

/// Stats Island - Dynamic top bar that shows active game info or other stats
/// Replaces the search bar with contextual information
class StatsIsland extends StatelessWidget {
  final bool isVisible;
  final String? activeGameTitle;
  final String? activeGameTime;

  const StatsIsland({
    super.key,
    this.isVisible = true,
    this.activeGameTitle,
    this.activeGameTime,
  });

  @override
  Widget build(BuildContext context) {
    // Only show if we have active content
    if (!isVisible || (activeGameTitle == null && activeGameTime == null)) {
      return const SizedBox.shrink();
    }

    return SafeArea(
      child: AnimatedOpacity(
        opacity: isVisible ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 300),
        child: Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppTheme.primaryBlue,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryBlue.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),

              // Text content
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (activeGameTitle != null)
                      Text(
                        activeGameTitle!,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    if (activeGameTime != null)
                      Text(
                        activeGameTime!,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // Close/more button
              Container(
                padding: const EdgeInsets.all(4),
                child: Icon(
                  Icons.chevron_right,
                  color: Colors.white.withOpacity(0.8),
                  size: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
