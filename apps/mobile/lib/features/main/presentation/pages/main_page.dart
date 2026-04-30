import 'package:flutter/material.dart';
import 'package:cupertino_native/cupertino_native.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:ticketa/core/theme/app_colors.dart';
import 'package:ticketa/features/home/presentation/pages/home_page.dart';
import 'package:ticketa/features/now_showing/presentation/pages/now_showing_page.dart';
import 'package:ticketa/features/settings/presentation/pages/settings_page.dart';
import 'package:ticketa/l10n/app_localizations.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isIOS = theme.platform == TargetPlatform.iOS;
    
    final List<Widget> _pages = [
      const HomePage(),
      const NowShowingPage(),
      Scaffold(body: Center(child: Text(l10n.offers))),
      const SettingsPage(),
    ];

    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          MediaQuery.removePadding(
            context: context,
            removeBottom: true,
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              children: _pages,
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
                  _pageController.jumpToPage(index);
                },
              ),
            ),
        ],
      ),
      bottomNavigationBar: isIOS
          ? null
          : Container(
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor.withOpacity(0.95),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 20,
                    color: Colors.black.withOpacity(.1),
                  )
                ],
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
                  child: GNav(
                    rippleColor: AppColors.warmOrange.withOpacity(0.1),
                    hoverColor: AppColors.warmOrange.withOpacity(0.1),
                    gap: 8,
                    activeColor: AppColors.warmOrange,
                    iconSize: 24,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    duration: const Duration(milliseconds: 400),
                    tabBackgroundColor: AppColors.warmOrange.withOpacity(0.1),
                    color: theme.iconTheme.color?.withOpacity(0.5),
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
                      _pageController.jumpToPage(index);
                    },
                  ),
                ),
              ),
            ),
    );
  }
}
