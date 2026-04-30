import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    final List<Widget> _pages = [
      const HomePage(),
      const NowShowingPage(),
      Scaffold(body: Center(child: Text(l10n.offers))),
      const SettingsPage(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.movie_filter_rounded),
            label: l10n.home,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.local_play_rounded),
            label: l10n.now,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.confirmation_number_rounded),
            label: l10n.offers,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person_rounded),
            label: l10n.account,
          ),
        ],
      ),
    );
  }
}
