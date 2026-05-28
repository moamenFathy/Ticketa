import 'package:flutter/material.dart';

class CinemaScreenPainter extends CustomPainter {
  final Color color;
  final bool isDark;
  final String hallType;

  CinemaScreenPainter({required this.color, this.isDark = true, this.hallType = 'IMAX'});

  @override
  void paint(Canvas canvas, Size size) {
    final strokeColor = isDark ? color : color.withValues(alpha: 0.7);
    final glowOpacity = isDark ? 0.25 : 0.12;
    final y = size.height * 0.4;

    if (hallType == 'Standard') {
      final standardY = size.height * 0.18;
      var paint = Paint()
        ..color = strokeColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round;

      canvas.drawLine(Offset(size.width * 0.05, standardY), Offset(size.width * 0.95, standardY), paint);

      var shadowPaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [color.withValues(alpha: glowOpacity), Colors.transparent],
        ).createShader(Rect.fromLTWH(0, standardY, size.width, size.height - standardY));

      var shadowPath = Path();
      shadowPath.moveTo(size.width * 0.05, standardY);
      shadowPath.lineTo(size.width * 0.95, standardY);
      shadowPath.lineTo(size.width * 1.1, size.height);
      shadowPath.lineTo(size.width * -0.1, size.height);
      shadowPath.close();
      canvas.drawPath(shadowPath, shadowPaint);
    } else {
      var paint = Paint()
        ..color = strokeColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round;

      var path = Path();
      path.moveTo(size.width * 0.05, y);
      path.quadraticBezierTo(size.width * 0.5, -15, size.width * 0.95, y);
      canvas.drawPath(path, paint);

      var shadowPaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [color.withValues(alpha: glowOpacity), Colors.transparent],
        ).createShader(Rect.fromLTWH(0, y - 5, size.width, size.height - y + 5));

      var shadowPath = Path();
      shadowPath.moveTo(size.width * 0.05, y);
      shadowPath.quadraticBezierTo(size.width * 0.5, -15, size.width * 0.95, y);
      shadowPath.lineTo(size.width * 1.1, size.height);
      shadowPath.lineTo(size.width * -0.1, size.height);
      shadowPath.close();
      canvas.drawPath(shadowPath, shadowPaint);
    }
  }

  @override
  bool shouldRepaint(CinemaScreenPainter oldDelegate) =>
      oldDelegate.isDark != isDark || oldDelegate.color != color || oldDelegate.hallType != hallType;
}
