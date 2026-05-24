import 'package:flutter/material.dart';
import 'package:ticketa/core/theme/app_colors.dart';

class AuthBackground extends StatelessWidget {
  final Widget child;

  const AuthBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark
              ? [
                  AppColors.deepCharcoal,
                  AppColors.backgroundDark,
                  AppColors.backgroundDark,
                ]
              : [
                  const Color(0xFFFFF5F0),
                  Colors.white,
                  const Color(0xFFFEFAF8),
                ],
        ),
      ),
      child: Stack(
        children: [
          // Decorative circles
          Positioned(
            top: -120,
            right: -80,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.warmOrange.withValues(alpha: isDark ? 0.06 : 0.04),
              ),
            ),
          ),
          Positioned(
            bottom: -100,
            left: -60,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.terracotta.withValues(alpha: isDark ? 0.04 : 0.03),
              ),
            ),
          ),
          Positioned(
            top: 200,
            left: -40,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.warmOrange.withValues(alpha: isDark ? 0.03 : 0.02),
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}
