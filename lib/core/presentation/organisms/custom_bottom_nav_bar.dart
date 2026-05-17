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
          CustomPaint(
            size: const Size(double.infinity, 70),
            painter: _NavBarPainter(color: AppColors.surface),
            child: SizedBox(
              height: 70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildNavItem(Icons.lens_outlined, 'Inicio', true),
                  _buildNavItem(Icons.south_west_rounded, 'Recibir', false),
                  const SizedBox(width: 70),
                  _buildNavItem(Icons.north_east_rounded, 'Enviar', false),
                  _buildNavItem(Icons.account_balance_wallet_outlined, 'Billetera', false),
                ],
              ),
            ),
          ),

          Positioned(
            top: -15,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: ClipPath(
                    clipper: const _RoundedHexagonClipper(),
                    child: Container(
                      width: 62,
                      height: 62,
                      decoration: const BoxDecoration(
                        gradient: AppColors.qrGradient,
                      ),
                      child: const Icon(
                        Icons.close_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Operar con QR',
                  style: AppTextStyles.label.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 10,
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
          if (isActive)
            Positioned(
              top: -12,
              child: Container(
                width: 32,
                height: 3,
                decoration: BoxDecoration(
                  color: AppColors.qrOrange,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 22),
              const SizedBox(height: 4),
              Text(
                label,
                style: AppTextStyles.label.copyWith(
                  color: color,
                  fontSize: 10,
                ),
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

    path.moveTo(0, 24);
    path.quadraticBezierTo(0, 0, 24, 0);

    final center = width / 2;
    path.lineTo(center - 50, 0);
    path.quadraticBezierTo(center - 30, 0, center - 20, -10);
    path.lineTo(center + 20, -10);
    path.quadraticBezierTo(center + 30, 0, center + 50, 0);

    path.lineTo(width - 24, 0);
    path.quadraticBezierTo(width, 0, width, 24);

    path.lineTo(width, height);
    path.lineTo(0, height);
    path.close();

    final borderPaint = Paint()
      ..color = AppColors.borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    canvas.drawPath(path, paint);
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _RoundedHexagonClipper extends CustomClipper<Path> {
  const _RoundedHexagonClipper();

  static const double _cornerRadius = 10.0;

  @override
  Path getClip(Size size) {
    final w = size.width;
    final h = size.height;

    final vertices = [
      Offset(w / 2, 0),
      Offset(w, h / 4),
      Offset(w, 3 * h / 4),
      Offset(w / 2, h),
      Offset(0, 3 * h / 4),
      Offset(0, h / 4),
    ];

    final n = vertices.length;
    final path = Path();

    for (int i = 0; i < n; i++) {
      final prev = vertices[(i - 1 + n) % n];
      final curr = vertices[i];
      final next = vertices[(i + 1) % n];

      final toPrev = prev - curr;
      final toNext = next - curr;
      final toPrevUnit = toPrev / toPrev.distance;
      final toNextUnit = toNext / toNext.distance;

      final arcStart = curr + toPrevUnit * _cornerRadius;
      final arcEnd = curr + toNextUnit * _cornerRadius;

      if (i == 0) {
        path.moveTo(arcStart.dx, arcStart.dy);
      } else {
        path.lineTo(arcStart.dx, arcStart.dy);
      }

      path.quadraticBezierTo(curr.dx, curr.dy, arcEnd.dx, arcEnd.dy);
    }

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
