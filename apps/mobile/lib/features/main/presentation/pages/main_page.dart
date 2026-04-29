import 'package:flutter/material.dart';
import 'package:ticketa/features/home/presentation/pages/home_page.dart';
import 'package:ticketa/features/now_showing/presentation/pages/now_showing_page.dart';
import 'package:ticketa/features/settings/presentation/pages/settings_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const NowShowingPage(),
    const Scaffold(backgroundColor: Colors.black, body: Center(child: Text("Offers", style: TextStyle(color: Colors.white)))),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.white.withOpacity(0.05), width: 1),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          backgroundColor: Colors.black,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFFFF4500),
          unselectedItemColor: Colors.white38,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.movie_filter_rounded),
              label: "Movies",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.local_play_rounded),
              label: "Now",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.confirmation_number_rounded),
              label: "Offers",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded),
              label: "Account",
            ),
          ],
        ),
      ),
    );
  }
}
