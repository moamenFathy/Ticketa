import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticketa/core/theme/app_colors.dart';
import 'package:ticketa/core/constants/app_constants.dart';
import 'package:ticketa/features/main/presentation/screens/main_page.dart';
import 'package:ticketa/features/auth/presentation/screens/login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late AnimationController _dotsController;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _logoScale = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.75, curve: Curves.elasticOut),
      ),
    );

    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.45, curve: Curves.easeIn),
      ),
    );

    _dotsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();

    _controller.forward();

    Timer(const Duration(milliseconds: 3200), () {
      if (!mounted) return;
      _navigate();
    });
  }

  Future<void> _navigate() async {
    final prefs = await SharedPreferences.getInstance();
    final isGuest = prefs.getBool(AppConstants.isGuestKey) ?? false;
    final isLoggedIn = prefs.getBool(AppConstants.isLoggedInKey) ?? false;

    if (!mounted) return;

    Widget destination;
    if (isGuest || isLoggedIn) {
      destination = const MainPage();
    } else {
      destination = const LoginPage();
    }

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => destination,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 800),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _dotsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [const Color(0xFF0D0D0D), const Color(0xFF1A0F08)]
                : [const Color(0xFFFAFAFA), const Color(0xFFFFF4EF)],
          ),
        ),
        child: Stack(
          children: [
            _buildDecorativeCircles(isDark),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ScaleTransition(
                    scale: _logoScale,
                    child: FadeTransition(
                      opacity: _logoOpacity,
                      child: Image.asset(
                        isDark
                            ? 'assets/Images/Icons/no_bg_dark.png'
                            : 'assets/Images/Icons/no_bg.png',
                        width: 260,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 64),
                  FadeTransition(
                    opacity: _logoOpacity,
                    child: _BouncingDots(
                      controller: _dotsController,
                      color: AppColors.warmOrange,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDecorativeCircles(bool isDark) {
    return Stack(
      children: [
        Positioned(
          top: -120,
          right: -100,
          child: Container(
            width: 360,
            height: 360,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.warmOrange.withValues(
                alpha: isDark ? 0.04 : 0.05,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -140,
          left: -80,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.lighterOrange.withValues(
                    alpha: isDark ? 0.05 : 0.07,
                  ),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 140,
          left: -50,
          child: Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.warmOrange.withValues(
                alpha: isDark ? 0.025 : 0.04,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _BouncingDots extends StatelessWidget {
  final AnimationController controller;
  final Color color;

  const _BouncingDots({
    required this.controller,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (index) {
            final delay = index * 0.2;
            final value = ((controller.value - delay) % 1.0)
                .clamp(0.0, 1.0);
            final scale = 0.4 + 0.6 * math.sin(value * math.pi);
            final alpha = 0.3 + 0.7 * math.sin(value * math.pi);

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Transform.scale(
                scale: scale,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color.withValues(alpha: alpha),
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
