import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ticketa/core/di/injection.dart';
import 'package:ticketa/core/services/navigation_service.dart';
import 'package:ticketa/core/theme/app_theme.dart';
import 'package:ticketa/core/services/locale_service.dart';
import 'package:ticketa/core/services/theme_service.dart';
import 'package:ticketa/features/main/presentation/screens/main_page.dart';
import 'package:ticketa/features/settings/presentation/screens/change_password_page.dart';
import 'package:ticketa/features/settings/presentation/screens/edit_profile_page.dart';
import 'package:ticketa/features/settings/presentation/screens/my_tickets_page.dart';
import 'package:ticketa/features/settings/presentation/screens/settings_page.dart';
import 'package:ticketa/features/splash/presentation/screens/splash_screen.dart';
import 'package:ticketa/features/auth/presentation/screens/login_page.dart';
import 'package:ticketa/features/auth/presentation/screens/register_page.dart';
import 'package:ticketa/features/auth/presentation/screens/confirm_email_page.dart';
import 'package:ticketa/features/auth/presentation/screens/forgot_password_page.dart';
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
            onGenerateTitle: (context) =>
                AppLocalizations.of(context)?.appName ?? 'Ticketa',
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
            navigatorKey: getIt<NavigationService>().navigatorKey,
            home: const SplashScreen(),
            routes: {
              '/login': (context) => const LoginPage(),
              '/register': (context) => const RegisterPage(),
              '/confirm-email': (context) => const ConfirmEmailPage(),
              '/forgot-password': (context) => const ForgotPasswordPage(),
              '/main': (context) => const MainPage(),
              '/settings': (context) => const SettingsPage(),
              '/my-tickets': (context) => const MyTicketsPage(),
              '/change-password': (context) => const ChangePasswordPage(),
              '/edit-profile': (context) => const EditProfilePage(),
            },
          );
        },
      ),
    );
  }
}
