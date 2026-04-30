import 'package:flutter/material.dart';
import 'package:ticketa/core/theme/app_theme.dart';
import 'package:ticketa/features/main/presentation/pages/main_page.dart';
import 'package:ticketa/features/settings/presentation/pages/settings_page.dart';
import 'package:ticketa/features/splash/presentation/pages/splash_screen.dart';
import 'package:ticketa/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  
  final String languageCode = prefs.getString('language_code') ?? 'en';
  final String themeMode = prefs.getString('theme_mode') ?? 'dark';
  
  runApp(MyApp(
    initialLocale: Locale(languageCode),
    initialThemeMode: themeMode == 'dark' ? ThemeMode.dark : ThemeMode.light,
  ));
}

class MyApp extends StatefulWidget {
  final Locale initialLocale;
  final ThemeMode initialThemeMode;
  
  const MyApp({
    super.key, 
    required this.initialLocale, 
    required this.initialThemeMode
  });

  static _MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>();

  static void setLocale(BuildContext context, Locale newLocale) async {
    final state = of(context);
    if (state != null) {
      state.setState(() => state._locale = newLocale);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('language_code', newLocale.languageCode);
    }
  }

  static void setTheme(BuildContext context, ThemeMode newTheme) async {
    final state = of(context);
    if (state != null) {
      state.setState(() => state._themeMode = newTheme);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('theme_mode', newTheme == ThemeMode.dark ? 'dark' : 'light');
    }
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Locale _locale;
  late ThemeMode _themeMode;

  @override
  void initState() {
    super.initState();
    _locale = widget.initialLocale;
    _themeMode = widget.initialThemeMode;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ticketa',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeMode,
      locale: _locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
      ],
      home: const SplashScreen(),
      routes: {
        '/main': (context) => const MainPage(),
        '/settings': (context) => const SettingsPage(),
      },
    );
  }
}