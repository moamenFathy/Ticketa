import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cupertino_native/cupertino_native.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:ticketa/core/theme/app_colors.dart';
import 'package:ticketa/features/home/presentation/screens/home_page.dart';
import 'package:ticketa/features/now_showing/presentation/screens/now_showing_page.dart';
import 'package:ticketa/features/settings/presentation/screens/my_tickets_page.dart';
import 'package:ticketa/features/settings/presentation/screens/settings_page.dart';
import 'package:ticketa/l10n/app_localizations.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late final AnimationController _pageTransition;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _pageTransition = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    )..forward();
    _fade = CurvedAnimation(
      parent: _pageTransition,
      curve: Curves.easeOut,
    );
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.015),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _pageTransition,
      curve: Curves.easeOutCubic,
    ));
  }

  @override
  void dispose() {
    _pageTransition.dispose();
    super.dispose();
  }

  void _switchTab(int index) {
    if (index == _currentIndex) return;
    setState(() => _currentIndex = index);
    _pageTransition.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;
    final isDark = theme.brightness == Brightness.dark;

    final List<Widget> pages = [
      HomePage(
        onProfileAvatarTap: () {
          _switchTab(3);
        },
      ),
      const NowShowingPage(),
      const MyTicketsPage(),
      const SettingsPage(),
    ];

    return Scaffold(
      extendBody: true,
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          FadeTransition(
            opacity: _fade,
            child: SlideTransition(
              position: _slide,
              child: IndexedStack(
                index: _currentIndex,
                children: pages,
              ),
            ),
          ),
          if (isIOS)
            _buildIosTabBar(l10n)
          else
            _buildAndroidTabBar(l10n, isDark),
        ],
      ),
    );
  }

  Widget _buildIosTabBar(AppLocalizations l10n) {
    return Positioned(
      left: 20,
      right: 20,
      bottom: 0,
      child: CNTabBar(
        items: [
          CNTabBarItem(
            label: l10n.home,
            icon: const CNSymbol('house.fill'),
          ),
          CNTabBarItem(
            label: l10n.now,
            icon: const CNSymbol('film.fill'),
          ),
          CNTabBarItem(
            label: l10n.myTickets,
            icon: const CNSymbol('ticket.fill'),
          ),
          CNTabBarItem(
            label: l10n.account,
            icon: const CNSymbol('person.fill'),
          ),
        ],
        currentIndex: _currentIndex,
        onTap: _switchTab,
      ),
    );
  }

  Widget _buildAndroidTabBar(AppLocalizations l10n, bool isDark) {
    return Positioned(
      left: 20,
      right: 20,
      bottom: 30,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.05),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: GNav(
              rippleColor: AppColors.warmOrange.withValues(alpha: 0.1),
              hoverColor: AppColors.warmOrange.withValues(alpha: 0.1),
              gap: 8,
              activeColor: AppColors.warmOrange,
              iconSize: 24,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: const Duration(milliseconds: 400),
              tabBackgroundColor: AppColors.warmOrange.withValues(alpha: 0.1),
              color: isDark ? Colors.white.withValues(alpha: 0.4) : Colors.black.withValues(alpha: 0.4),
              tabs: [
                GButton(icon: Icons.movie_filter_rounded, text: l10n.home),
                GButton(icon: Icons.local_play_rounded, text: l10n.now),
                GButton(icon: Icons.confirmation_number_rounded, text: l10n.myTickets),
                GButton(icon: Icons.person_rounded, text: l10n.account),
              ],
              selectedIndex: _currentIndex,
              onTabChange: _switchTab,
            ),
          ),
        ),
      ),
    );
  }
}

