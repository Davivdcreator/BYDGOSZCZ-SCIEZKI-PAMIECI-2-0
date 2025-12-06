import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Copper styled button - main action button for the app
class CopperButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool isLarge;
  final bool isPulsing;
  final bool useGoldGradient;
  
  const CopperButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isLarge = false,
    this.isPulsing = false,
    this.useGoldGradient = false,
  });

  @override
  State<CopperButton> createState() => _CopperButtonState();
}

class _CopperButtonState extends State<CopperButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  
  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    if (widget.isPulsing) {
      _pulseController.repeat(reverse: true);
    }
  }
  
  @override
  void didUpdateWidget(CopperButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPulsing && !_pulseController.isAnimating) {
      _pulseController.repeat(reverse: true);
    } else if (!widget.isPulsing && _pulseController.isAnimating) {
      _pulseController.stop();
      _pulseController.reset();
    }
  }
  
  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gradient = widget.useGoldGradient
        ? AppTheme.goldGradient
        : AppTheme.copperGradient;
    
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: widget.isPulsing ? _pulseAnimation.value : 1.0,
          child: child,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(widget.isLarge ? 16 : 12),
          boxShadow: [
            BoxShadow(
              color: (widget.useGoldGradient 
                  ? AppTheme.oldGold 
                  : AppTheme.oxidizedCopper
              ).withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.isLoading ? null : widget.onPressed,
            borderRadius: BorderRadius.circular(widget.isLarge ? 16 : 12),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: widget.isLarge ? 32 : 24,
                vertical: widget.isLarge ? 18 : 14,
              ),
              child: widget.isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (widget.icon != null) ...[
                          Icon(
                            widget.icon,
                            color: Colors.white,
                            size: widget.isLarge ? 24 : 20,
                          ),
                          const SizedBox(width: 10),
                        ],
                        Text(
                          widget.text,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: widget.isLarge ? 18 : 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Seal-style button for the onboarding screen
class SealButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final double size;
  
  const SealButton({
    super.key,
    required this.text,
    this.onPressed,
    this.size = 200,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: AppTheme.copperGradient,
          boxShadow: [
            BoxShadow(
              color: AppTheme.oxidizedCopper.withOpacity(0.5),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 30,
              offset: const Offset(0, 15),
            ),
          ],
          border: Border.all(
            color: AppTheme.copperLight.withOpacity(0.5),
            width: 3,
          ),
        ),
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 2,
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                  height: 1.3,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
