import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

/// Modern Gradient Button - Primary action button
class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? icon;
  final bool isLarge;
  final bool useAccentGradient;
  final bool isOutlined;

  const GradientButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.isLarge = false,
    this.useAccentGradient = false,
    this.isOutlined = false,
  });

  @override
  Widget build(BuildContext context) {
    final gradient =
        useAccentGradient ? AppTheme.accentGradient : AppTheme.primaryGradient;

    if (isOutlined) {
      return _buildOutlinedButton();
    }

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isLarge ? 32 : 24,
          vertical: isLarge ? 16 : 12,
        ),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: (useAccentGradient
                      ? AppTheme.accentYellow
                      : AppTheme.primaryBlue)
                  .withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, color: Colors.white, size: isLarge ? 24 : 20),
              SizedBox(width: isLarge ? 12 : 8),
            ],
            Text(
              text,
              style: GoogleFonts.inter(
                fontSize: isLarge ? 16 : 14,
                fontWeight: FontWeight.w600,
                color: useAccentGradient ? AppTheme.textPrimary : Colors.white,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOutlinedButton() {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isLarge ? 32 : 24,
          vertical: isLarge ? 16 : 12,
        ),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppTheme.primaryBlue,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, color: AppTheme.primaryBlue, size: isLarge ? 24 : 20),
              SizedBox(width: isLarge ? 12 : 8),
            ],
            Text(
              text,
              style: GoogleFonts.inter(
                fontSize: isLarge ? 16 : 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryBlue,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Pill Tag - for categories
class PillTag extends StatelessWidget {
  final String text;
  final Color? color;
  final bool isOutlined;
  final VoidCallback? onTap;

  const PillTag({
    super.key,
    required this.text,
    this.color,
    this.isOutlined = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tagColor = color ?? AppTheme.primaryBlue;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isOutlined ? Colors.transparent : tagColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: tagColor.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Text(
          text,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: tagColor,
          ),
        ),
      ),
    );
  }
}

// Legacy alias for backwards compatibility
class CopperButton extends GradientButton {
  const CopperButton({
    super.key,
    required super.text,
    required super.onPressed,
    super.icon,
    super.isLarge,
    bool useGoldGradient = false,
  }) : super(useAccentGradient: useGoldGradient);
}
