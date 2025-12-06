import 'package:flutter/material.dart';
import 'dart:math';
import '../theme/app_theme.dart';
import '../widgets/frosted_glass_panel.dart';
import '../widgets/copper_button.dart';

/// Screen 3: "Soczewka Historii" - AR View Screen
/// Field search mode (simplified mock)
class ARViewScreen extends StatefulWidget {
  const ARViewScreen({super.key});

  @override
  State<ARViewScreen> createState() => _ARViewScreenState();
}

class _ARViewScreenState extends State<ARViewScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _scanController;
  bool _objectDetected = false;
  String? _detectedName;
  
  @override
  void initState() {
    super.initState();
    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    
    // Simulate object detection after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _objectDetected = true;
          _detectedName = 'Łuczniczka';
        });
      }
    });
  }
  
  @override
  void dispose() {
    _scanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Simulated camera view (gradient placeholder)
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.grey[900]!,
                  Colors.grey[800]!,
                  Colors.grey[700]!,
                ],
              ),
            ),
            child: CustomPaint(
              painter: _GridPainter(),
            ),
          ),
          
          // Scanning effect
          if (!_objectDetected)
            AnimatedBuilder(
              animation: _scanController,
              builder: (context, child) {
                return CustomPaint(
                  painter: _ScanLinePainter(_scanController.value),
                  size: Size.infinite,
                );
              },
            ),
          
          // Detected object aura
          if (_objectDetected)
            Center(
              child: _buildDetectedObject(),
            ),
          
          // Top bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _buildTopBar(),
          ),
          
          // Bottom controls
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomControls(),
          ),
          
          // Instructions
          if (!_objectDetected)
            Positioned(
              top: MediaQuery.of(context).size.height * 0.4,
              left: 40,
              right: 40,
              child: _buildInstructions(),
            ),
        ],
      ),
    );
  }
  
  Widget _buildTopBar() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Close button
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                  ),
                ),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                ),
              ),
            ),
            
            const Spacer(),
            
            // Status
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _objectDetected
                      ? AppTheme.oldGold.withOpacity(0.5)
                      : Colors.white.withOpacity(0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _objectDetected ? Icons.check_circle : Icons.camera,
                    color: _objectDetected ? AppTheme.oldGold : Colors.white,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _objectDetected ? 'Obiekt wykryty!' : 'Skanowanie...',
                    style: TextStyle(
                      color: _objectDetected ? AppTheme.oldGold : Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildDetectedObject() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Glowing aura
        Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                AppTheme.oldGold.withOpacity(0.3),
                AppTheme.oldGold.withOpacity(0.1),
                Colors.transparent,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.oldGold.withOpacity(0.3),
                blurRadius: 40,
                spreadRadius: 20,
              ),
            ],
          ),
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppTheme.oldGold,
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.woman_2_outlined,
                color: AppTheme.oldGold,
                size: 60,
              ),
            ),
          ),
        ),
        
        const SizedBox(height: 24),
        
        // 3D floating name
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.8),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppTheme.oldGold.withOpacity(0.5),
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.oldGold.withOpacity(0.3),
                blurRadius: 20,
              ),
            ],
          ),
          child: Text(
            _detectedName ?? '',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ),
        
        const SizedBox(height: 8),
        
        Text(
          'Tier S • Ikona',
          style: TextStyle(
            color: AppTheme.oldGold.withOpacity(0.8),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
  
  Widget _buildInstructions() {
    return FrostedGlassPanel(
      backgroundColor: Colors.black.withOpacity(0.5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.center_focus_strong,
            color: Colors.white.withOpacity(0.8),
            size: 40,
          ),
          const SizedBox(height: 12),
          const Text(
            'Nakieruj kamerę na obiekt',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'System rozpozna pomnik lub rzeźbę\ni wyświetli jej informacje',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
  
  Widget _buildBottomControls() {
    return Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).padding.bottom + 24,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.black.withOpacity(0.8),
          ],
        ),
      ),
      child: _objectDetected
          ? CopperButton(
              text: 'ZMATERIALIZUJ',
              icon: Icons.auto_awesome,
              isLarge: true,
              useGoldGradient: true,
              onPressed: () {
                Navigator.of(context).pop();
                // Would navigate to discovery card
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Łuczniczka dodana do kolekcji!'),
                    backgroundColor: AppTheme.oxidizedCopper,
                  ),
                );
              },
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildControlButton(
                  Icons.flash_off,
                  'Lampa',
                  () {},
                ),
                const SizedBox(width: 24),
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 3,
                    ),
                  ),
                  child: Container(
                    margin: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                const SizedBox(width: 24),
                _buildControlButton(
                  Icons.switch_camera,
                  'Kamera',
                  () {},
                ),
              ],
            ),
    );
  }
  
  Widget _buildControlButton(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

/// Grid painter for vintage viewfinder effect
class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..strokeWidth = 1;
    
    // Draw grid
    const spacing = 50.0;
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
    
    // Draw corner markers
    final cornerPaint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    
    const cornerSize = 30.0;
    const margin = 40.0;
    
    // Top left
    canvas.drawLine(
      Offset(margin, margin),
      Offset(margin + cornerSize, margin),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(margin, margin),
      Offset(margin, margin + cornerSize),
      cornerPaint,
    );
    
    // Top right
    canvas.drawLine(
      Offset(size.width - margin, margin),
      Offset(size.width - margin - cornerSize, margin),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(size.width - margin, margin),
      Offset(size.width - margin, margin + cornerSize),
      cornerPaint,
    );
    
    // Bottom left
    canvas.drawLine(
      Offset(margin, size.height - margin),
      Offset(margin + cornerSize, size.height - margin),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(margin, size.height - margin),
      Offset(margin, size.height - margin - cornerSize),
      cornerPaint,
    );
    
    // Bottom right
    canvas.drawLine(
      Offset(size.width - margin, size.height - margin),
      Offset(size.width - margin - cornerSize, size.height - margin),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(size.width - margin, size.height - margin),
      Offset(size.width - margin, size.height - margin - cornerSize),
      cornerPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Scan line effect painter
class _ScanLinePainter extends CustomPainter {
  final double progress;
  
  _ScanLinePainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final y = size.height * progress;
    
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.transparent,
          AppTheme.oxidizedCopper.withOpacity(0.5),
          AppTheme.oxidizedCopper,
          AppTheme.oxidizedCopper.withOpacity(0.5),
          Colors.transparent,
        ],
        stops: const [0, 0.3, 0.5, 0.7, 1],
      ).createShader(Rect.fromLTWH(0, y - 50, size.width, 100));
    
    canvas.drawRect(
      Rect.fromLTWH(0, y - 50, size.width, 100),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _ScanLinePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
