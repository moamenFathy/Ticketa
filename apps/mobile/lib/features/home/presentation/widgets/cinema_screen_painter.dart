import 'package:flutter/material.dart';

class CinemaScreenPainter extends CustomPainter {
  final Color color;
  CinemaScreenPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    var path = Path();
    path.moveTo(size.width * 0.05, 35);
    path.quadraticBezierTo(size.width * 0.5, -15, size.width * 0.95, 35);
    canvas.drawPath(path, paint);

    var shadowPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [color.withOpacity(0.3), Colors.transparent],
      ).createShader(Rect.fromLTWH(0, 35, size.width, size.height));

    var shadowPath = Path();
    shadowPath.moveTo(size.width * 0.05, 35);
    shadowPath.quadraticBezierTo(size.width * 0.5, -15, size.width * 0.95, 35);
    shadowPath.lineTo(size.width * 1.1, size.height);
    shadowPath.lineTo(size.width * -0.1, size.height);
    shadowPath.close();
    canvas.drawPath(shadowPath, shadowPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
