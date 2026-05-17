import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          // Background Bar with Hump
          CustomPaint(
            size: const Size(double.infinity, 70),
            painter: _NavBarPainter(color: AppColors.surface),
            child: SizedBox(
              height: 70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildNavItem(Icons.home_filled, 'Inicio', true),
                  _buildNavItem(Icons.arrow_downward, 'Recibir', false),
                  const SizedBox(width: 70), // Spacer for the FAB
                  _buildNavItem(Icons.arrow_upward, 'Enviar', false),
                  _buildNavItem(
                    Icons.account_balance_wallet,
                    'Billetera',
                    false,
                  ),
                ],
              ),
            ),
          ),

          // Floating Central Button ("Operar con QR")
          Positioned(
            top: -15, // Raised above the hump
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {
                    /* QR Action */
                  },
                  child: ClipPath(
                    clipper: const _RoundedHexagonClipper(),
                    child: Container(
                      width: 64,
                      height: 64,
                      decoration: const BoxDecoration(
                        gradient: AppColors.orangeGradient,
                      ),
                      child: const Icon(
                        Icons.qr_code_scanner,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Operar con QR',
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive) {
    final color = isActive ? AppColors.textPrimary : AppColors.textSecondary;
    return Expanded(
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // Color shading (glow) for active item
          if (isActive)
            Positioned(
              top: 10,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryOrange.withValues(alpha: 0.2),
                      blurRadius: 40,
                      spreadRadius: 20,
                    ),
                  ],
                ),
              ),
            ),

          // Orange top indicator line
          if (isActive)
            Positioned(
              top: -12, // Snap perfectly to the top of the bar
              child: Container(
                width: 36, // Made it wider
                height: 4, // Made it slightly thicker for visibility
                decoration: const BoxDecoration(
                  color: AppColors.primaryOrange,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(2),
                    bottomRight: Radius.circular(2),
                  ),
                ),
              ),
            ),

          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(height: 4),
              Text(
                label,
                style: AppTextStyles.label.copyWith(color: color, fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NavBarPainter extends CustomPainter {
  final Color color;

  _NavBarPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    final width = size.width;
    final height = size.height;

    // Start at top left
    path.moveTo(0, 24);
    path.quadraticBezierTo(0, 0, 24, 0);

    // Draw the hump in the middle
    final center = width / 2;
    path.lineTo(center - 50, 0);
    // Left slope
    path.quadraticBezierTo(center - 30, 0, center - 20, -10);
    // Top flat of hump
    path.lineTo(center + 20, -10);
    // Right slope
    path.quadraticBezierTo(center + 30, 0, center + 50, 0);

    // Continue to top right
    path.lineTo(width - 24, 0);
    path.quadraticBezierTo(width, 0, width, 24);

    // Bottom edge
    path.lineTo(width, height);
    path.lineTo(0, height);
    path.close();

    // Subtle top border/glow effect for fidelity
    final borderPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    canvas.drawPath(path, paint);
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _RoundedHexagonClipper extends CustomClipper<Path> {
  final double cornerRadius;

  const _RoundedHexagonClipper({this.cornerRadius = 8.0});

  @override
  Path getClip(Size size) {
    final w = size.width;
    final h = size.height;

    // 6 vertices of a point-up hexagon fitted to the bounding box
    final vertices = [
      Offset(w / 2, 0), // top
      Offset(w, h / 4), // top-right
      Offset(w, 3 * h / 4), // bottom-right
      Offset(w / 2, h), // bottom
      Offset(0, 3 * h / 4), // bottom-left
      Offset(0, h / 4), // top-left
    ];

    final n = vertices.length;
    final path = Path();

    for (int i = 0; i < n; i++) {
      final prev = vertices[(i - 1 + n) % n];
      final curr = vertices[i];
      final next = vertices[(i + 1) % n];

      // Unit vectors from current vertex toward its two neighbors
      final toPrev = prev - curr;
      final toNext = next - curr;
      final toPrevUnit = toPrev / toPrev.distance;
      final toNextUnit = toNext / toNext.distance;

      // Points on the edges, pulled back from the vertex by cornerRadius
      final arcStart = curr + toPrevUnit * cornerRadius;
      final arcEnd = curr + toNextUnit * cornerRadius;

      if (i == 0) {
        path.moveTo(arcStart.dx, arcStart.dy);
      } else {
        path.lineTo(arcStart.dx, arcStart.dy);
      }

      // Round the corner: control point is the sharp vertex itself
      path.quadraticBezierTo(curr.dx, curr.dy, arcEnd.dx, arcEnd.dy);
    }

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
