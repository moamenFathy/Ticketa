import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ticketa/core/theme/app_theme.dart';
import 'package:ticketa/core/services/locale_service.dart';
import 'package:ticketa/core/services/theme_service.dart';
import 'package:ticketa/features/main/presentation/screens/main_page.dart';
import 'package:ticketa/features/settings/presentation/screens/change_password_page.dart';
import 'package:ticketa/features/settings/presentation/screens/edit_profile_page.dart';
import 'package:ticketa/features/settings/presentation/screens/my_tickets_page.dart';
import 'package:ticketa/features/settings/presentation/screens/notifications_page.dart';
import 'package:ticketa/features/settings/presentation/screens/privacy_page.dart';
import 'package:ticketa/features/settings/presentation/screens/security_page.dart';
import 'package:ticketa/features/settings/presentation/screens/settings_page.dart';
import 'package:ticketa/features/splash/presentation/screens/splash_screen.dart';
import 'package:ticketa/l10n/app_localizations.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocaleService()..loadLocale()),
        ChangeNotifierProvider(create: (_) => ThemeService()..loadTheme()),
      ],
      child: Consumer2<LocaleService, ThemeService>(
        builder: (context, localeService, themeService, child) {
          return MaterialApp(
            title: 'Ticketa',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeService.themeMode,
            locale: localeService.locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('en'), Locale('ar')],
            home: const SplashScreen(),
            routes: {
              '/main': (context) => const MainPage(),
              '/settings': (context) => const SettingsPage(),
              '/my-tickets': (context) => const MyTicketsPage(),
              '/notifications': (context) => const NotificationsPage(),
              '/privacy': (context) => const PrivacyPage(),
              '/security': (context) => const SecurityPage(),
              '/change-password': (context) => const ChangePasswordPage(),
              '/edit-profile': (context) => const EditProfilePage(),
            },
          );
        },
      ),
    );
  }
}
