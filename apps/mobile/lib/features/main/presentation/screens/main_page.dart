import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cupertino_native/cupertino_native.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:ticketa/core/theme/app_colors.dart';
import 'package:ticketa/features/home/presentation/screens/home_page.dart';
import 'package:ticketa/features/now_showing/presentation/screens/now_showing_page.dart';
import 'package:ticketa/features/offers/presentation/screens/offers_page.dart';
import 'package:ticketa/features/settings/presentation/screens/settings_page.dart';
import 'package:ticketa/l10n/app_localizations.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;
    
    final List<Widget> _pages = [
      const HomePage(),
      const NowShowingPage(),
      const OffersPage(),
      const SettingsPage(),
    ];

    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      extendBody: true,
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(
                opacity: animation,
                child: ScaleTransition(
                  scale: Tween<double>(begin: 0.96, end: 1.0).animate(animation),
                  child: child,
                ),
              );
            },
            child: KeyedSubtree(
              key: ValueKey<int>(_currentIndex),
              child: _pages[_currentIndex],
            ),
          ),
          
          if (isIOS)
            Positioned(
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
                    label: l10n.offers,
                    icon: const CNSymbol('ticket.fill'),
                  ),
                  CNTabBarItem(
                    label: l10n.account,
                    icon: const CNSymbol('person.fill'),
                  ),
                ],
                currentIndex: _currentIndex,
                onTap: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
            )
          else
            // Floating Premium Bottom Bar for Non-iOS
            Positioned(
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
                      color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: GNav(
                      rippleColor: AppColors.warmOrange.withOpacity(0.1),
                      hoverColor: AppColors.warmOrange.withOpacity(0.1),
                      gap: 8,
                      activeColor: AppColors.warmOrange,
                      iconSize: 24,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      duration: const Duration(milliseconds: 400),
                      tabBackgroundColor: AppColors.warmOrange.withOpacity(0.1),
                      color: isDark ? Colors.white.withOpacity(0.4) : Colors.black.withOpacity(0.4),
                      tabs: [
                        GButton(
                          icon: Icons.movie_filter_rounded,
                          text: l10n.home,
                        ),
                        GButton(
                          icon: Icons.local_play_rounded,
                          text: l10n.now,
                        ),
                        GButton(
                          icon: Icons.confirmation_number_rounded,
                          text: l10n.offers,
                        ),
                        GButton(
                          icon: Icons.person_rounded,
                          text: l10n.account,
                        ),
                      ],
                      selectedIndex: _currentIndex,
                      onTabChange: (index) {
                        setState(() {
                          _currentIndex = index;
                        });
                      },
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

