import 'package:flutter/material.dart';

class CinemaScreenPainter extends CustomPainter {
  final Color color;
  final bool isDark;

  CinemaScreenPainter({required this.color, this.isDark = true});

  @override
  void paint(Canvas canvas, Size size) {
    final strokeColor = isDark ? color : color.withValues(alpha: 0.7);
    final glowOpacity = isDark ? 0.25 : 0.12;
    final arcHeight = size.height * 0.4;

    var paint = Paint()
      ..color = strokeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    var path = Path();
    path.moveTo(size.width * 0.05, arcHeight);
    path.quadraticBezierTo(size.width * 0.5, -15, size.width * 0.95, arcHeight);
    canvas.drawPath(path, paint);

    var shadowPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [color.withValues(alpha: glowOpacity), Colors.transparent],
      ).createShader(Rect.fromLTWH(0, arcHeight - 5, size.width, size.height - arcHeight + 5));

    var shadowPath = Path();
    shadowPath.moveTo(size.width * 0.05, arcHeight);
    shadowPath.quadraticBezierTo(size.width * 0.5, -15, size.width * 0.95, arcHeight);
    shadowPath.lineTo(size.width * 1.1, size.height);
    shadowPath.lineTo(size.width * -0.1, size.height);
    shadowPath.close();
    canvas.drawPath(shadowPath, shadowPaint);
  }

  @override
  bool shouldRepaint(CinemaScreenPainter oldDelegate) =>
      oldDelegate.isDark != isDark || oldDelegate.color != color;
}
