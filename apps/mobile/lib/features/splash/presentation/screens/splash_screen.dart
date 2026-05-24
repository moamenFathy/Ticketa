import 'package:flutter/material.dart';
import 'dart:async';
import 'package:ticketa/core/theme/app_colors.dart';
import 'package:ticketa/features/main/presentation/screens/main_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _logoScale = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.8, curve: Curves.elasticOut),
      ),
    );

    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _controller.forward();

    Timer(const Duration(milliseconds: 3000), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const MainPage(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 1000),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          // Cinematic Background Glow (Only in light mode)
          if (!isDark)
            Positioned(
              bottom: -150,
              left: -100,
              right: -100,
              child: Container(
                height: 400,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.warmOrange.withValues(alpha: 0.06),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          Center(
            child: ScaleTransition(
              scale: _logoScale,
              child: FadeTransition(
                opacity: _logoOpacity,
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: isDark ? [] : [
                      BoxShadow(
                        color: AppColors.warmOrange.withValues(alpha: 0.04),
                        blurRadius: 60,
                        spreadRadius: 20,
                      ),
                    ],
                  ),
                  child: Image.asset(
                    isDark ? 'assets/Images/Icons/no_bg_dark.png' : 'assets/Images/Icons/no_bg.png',
                    width: 280,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
          // Simple loading at the bottom
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _logoOpacity,
              child: Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 1.5,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.warmOrange.withValues(alpha: 0.4),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}