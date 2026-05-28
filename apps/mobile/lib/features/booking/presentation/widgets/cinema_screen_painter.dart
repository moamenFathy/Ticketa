import 'package:flutter/material.dart';

class CinemaScreenPainter extends CustomPainter {
  final Color color;
  final bool isDark;
  final String hallType;

  CinemaScreenPainter({required this.color, this.isDark = true, this.hallType = 'IMAX'});

  @override
  void paint(Canvas canvas, Size size) {
    final isImax = hallType == 'IMAX';
    final strokeColor = isDark ? color : color.withValues(alpha: 0.7);
    final glowOpacity = isDark ? 0.25 : 0.12;
    final y = isImax ? size.height * 0.4 : size.height * 0.18;
    final left = size.width * 0.05;
    final right = size.width * 0.95;

    final linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    linePaint.shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          Colors.black,
          strokeColor.withValues(alpha: 0.5),
          strokeColor.withValues(alpha: 0.9),
          strokeColor.withValues(alpha: 0.9),
          strokeColor.withValues(alpha: 0.5),
          Colors.black,
        ],
        stops: const [0.0, 0.2, 0.35, 0.65, 0.8, 1.0],
      ).createShader(Rect.fromLTWH(left, y - 5, right - left, 10));

    if (isImax) {
      final path = Path();
      path.moveTo(left, y);
      path.quadraticBezierTo(size.width * 0.5, -15, right, y);
      canvas.drawPath(path, linePaint);
    } else {
      canvas.drawLine(Offset(left, y), Offset(right, y), linePaint);
    }

    final glowPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [color.withValues(alpha: glowOpacity), Colors.transparent],
      ).createShader(Rect.fromLTWH(0, y, size.width, size.height - y));

    final glowPath = Path();
    glowPath.moveTo(left, y);
    if (isImax) {
      glowPath.quadraticBezierTo(size.width * 0.5, -15, right, y);
    } else {
      glowPath.lineTo(right, y);
    }
    glowPath.lineTo(size.width * 1.1, size.height);
    glowPath.lineTo(size.width * -0.1, size.height);
    glowPath.close();
    canvas.drawPath(glowPath, glowPaint);
  }

  @override
  bool shouldRepaint(CinemaScreenPainter oldDelegate) =>
      oldDelegate.isDark != isDark || oldDelegate.color != color || oldDelegate.hallType != hallType;
}
