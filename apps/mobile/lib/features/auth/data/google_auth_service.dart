import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticketa/core/utils/app_logger.dart';

const String kWebClientId =
    '768723492799-7qsjikqikqjvhtarqmqqsq6s72sjtg2s.apps.googleusercontent.com';
const String kIosClientId =
    '768723492799-p5e8fctohe7tj4ogservhok3c0rf3ll4.apps.googleusercontent.com';

class GoogleAuthService {
  GoogleAuthService._();

  static bool get _isApple =>
      defaultTargetPlatform == TargetPlatform.iOS ||
      defaultTargetPlatform == TargetPlatform.macOS;

  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: const ['email', 'profile'],
    clientId: _isApple ? kIosClientId : null,
    serverClientId: kWebClientId,
  );

  static Future<String?> signInWithGoogle() async {
    const debugTag = 'GOOGLE_SIGN_IN';
    AppLogger.d('starting sign-in (apple=$_isApple)', tag: debugTag);
    try {
      await _googleSignIn.signOut();

      final account = await _googleSignIn
          .signIn()
          .timeout(const Duration(seconds: 30));
      if (account == null) {
        AppLogger.w('account returned null -> user cancelled', tag: debugTag);
        return null;
      }
      AppLogger.i(
        'account = ${account.email} (${account.displayName ?? 'no-name'})',
        tag: debugTag,
      );

      final auth = await account.authentication;
      final idToken = auth.idToken;
      AppLogger.d(
        'got idToken? ${idToken != null} length=${idToken?.length ?? 0}',
        tag: debugTag,
      );
      if (idToken == null) {
        AppLogger.e(
          'FAILED: idToken is null (likely clientId/serverClientId misconfigured)',
          tag: debugTag,
        );
        return null;
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('google_id_token', idToken);
      await prefs.setString(
        'google_display_name',
        account.displayName ?? '',
      );
      await prefs.setString('google_email', account.email);
      return idToken;
    } catch (e, st) {
      AppLogger.e('Sign in error: $e', tag: debugTag, error: e, stackTrace: st);
      return null;
    }
  }

  static Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('google_id_token');
    await _googleSignIn.disconnect();
  }

  static bool get isGoogleSession {
    return false;
  }

  static Future<String> get savedDisplayName async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('google_display_name') ?? '';
  }

  static Future<String> get savedEmail async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('google_email') ?? '';
  }
}