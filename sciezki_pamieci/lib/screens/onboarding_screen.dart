import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import 'login_screen.dart';
import '../widgets/copper_button.dart';

/// Screen 1: Onboarding - "Wrota Czasu"
/// Clean, modern entry point with Bydgoszcz branding
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;
  late Animation<double> _slideUp;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeIn = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0, 0.6)),
    );

    _slideUp = Tween<double>(begin: 30, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.primaryBlue.withOpacity(0.05),
              AppTheme.background,
              AppTheme.background,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Opacity(
                  opacity: _fadeIn.value,
                  child: Transform.translate(
                    offset: Offset(0, _slideUp.value),
                    child: child,
                  ),
                );
              },
              child: Column(
                children: [
                  const Spacer(flex: 2),

                  // Logo area
                  _buildLogo(),

                  const SizedBox(height: 48),

                  // Title
                  Text(
                    'Ścieżki Pamięci',
                    style: GoogleFonts.inter(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                      letterSpacing: -0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Bydgoszcz',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.primaryBlue,
                      letterSpacing: 2,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Subtitle
                  Text(
                    'Odkrywaj historię miasta poprzez\npomniki, rzeźby i ciekawe miejsca',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: AppTheme.textSecondary,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const Spacer(flex: 2),

                  // CTA Button
                  SizedBox(
                    width: double.infinity,
                    child: GradientButton(
                      text: 'Rozpocznij przygodę',
                      icon: Icons.explore_outlined,
                      isLarge: true,
                      onPressed: _navigateToMap,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Skip text
                  TextButton(
                    onPressed: _navigateToMap,
                    child: Text(
                      'Mam już konto',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: AppTheme.textMuted,
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 140,
      height: 140,
      decoration: BoxDecoration(
        color: AppTheme.surface,
        shape: BoxShape.circle,
        boxShadow: AppTheme.cardShadow,
      ),
      child: ClipOval(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Image.asset(
            'assets/textures/logo bydgoszcz.png',
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              // Fallback to houses if logo not found
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildHouse(AppTheme.warmRed, 24),
                  const SizedBox(width: 4),
                  _buildHouse(AppTheme.accentYellow, 32),
                  const SizedBox(width: 4),
                  _buildHouse(AppTheme.primaryBlue, 28),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHouse(Color color, double height) {
    return CustomPaint(
      size: Size(height * 0.8, height),
      painter: _HousePainter(color),
    );
  }

  void _navigateToMap() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }
}

class _HousePainter extends CustomPainter {
  final Color color;

  _HousePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    // Roof
    path.moveTo(size.width / 2, 0);
    path.lineTo(0, size.height * 0.4);
    path.lineTo(size.width, size.height * 0.4);
    path.close();

    // Body
    path.addRect(Rect.fromLTWH(
      size.width * 0.1,
      size.height * 0.4,
      size.width * 0.8,
      size.height * 0.6,
    ));

    canvas.drawPath(path, paint);

    // Window (cutout effect)
    final windowPaint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(size.width / 2, size.height * 0.65),
        width: size.width * 0.3,
        height: size.height * 0.25,
      ),
      windowPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
