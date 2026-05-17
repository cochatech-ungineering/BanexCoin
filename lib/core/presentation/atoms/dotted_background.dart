import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

class DottedBackground extends StatelessWidget {
  final Widget child;

  const DottedBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Base dark background
        Container(color: AppColors.background),
        // Dotted pattern with fade
        Positioned.fill(
          child: CustomPaint(
            painter: _DottedBackgroundPainter(),
          ),
        ),
        // The actual content
        child,
      ],
    );
  }
}

class _DottedBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF3A3A4C).withValues(alpha: 0.3) // Subtle dots
      ..style = PaintingStyle.fill;

    const spacing = 20.0;
    const dotRadius = 1.5;

    // Create a radial gradient shader for the fade effect
    final Rect rect = Rect.fromLTWH(0, 0, size.width, size.height * 0.6);
    final Gradient gradient = RadialGradient(
      center: const Alignment(0, -0.8), // Top center
      radius: 1.0,
      colors: [
        Colors.white,
        Colors.white.withValues(alpha: 0.0),
      ],
      stops: const [0.2, 1.0],
    );

    canvas.saveLayer(Offset.zero & size, Paint());

    // Draw the dots
    for (double y = 0; y < size.height * 0.7; y += spacing) {
      for (double x = 0; x < size.width; x += spacing) {
        // Shift alternate rows for a staggered look (optional)
        // double offsetX = (y / spacing) % 2 == 0 ? 0 : spacing / 2;
        canvas.drawCircle(Offset(x, y), dotRadius, paint);
      }
    }

    // Apply the gradient mask
    final maskPaint = Paint()
      ..shader = gradient.createShader(rect)
      ..blendMode = BlendMode.dstIn;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), maskPaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
