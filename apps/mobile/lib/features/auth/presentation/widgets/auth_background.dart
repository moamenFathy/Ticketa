import 'package:flutter/material.dart';
import 'package:ticketa/core/theme/app_colors.dart';

class AuthBackground extends StatefulWidget {
  final Widget child;

  const AuthBackground({super.key, required this.child});

  @override
  State<AuthBackground> createState() => _AuthBackgroundState();
}

class _AuthBackgroundState extends State<AuthBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _drift;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 7),
    )..repeat(reverse: true);
    _drift = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
          AnimatedBuilder(
            animation: _drift,
            builder: (context, _) {
              final value = _drift.value;
              return Stack(
                children: [
                  // Decorative circles
                  Positioned(
                    top: -120 + 14 * value,
                    right: -80 - 12 * value,
                    child: Container(
                      width: 280,
                      height: 280,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.warmOrange
                            .withValues(alpha: isDark ? 0.06 : 0.04),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -100 - 16 * value,
                    left: -60 + 18 * value,
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.terracotta
                            .withValues(alpha: isDark ? 0.04 : 0.03),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 200 - 12 * value,
                    left: -40 - 20 * value,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.warmOrange
                            .withValues(alpha: isDark ? 0.03 : 0.02),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          widget.child,
        ],
      ),
    );
  }
}