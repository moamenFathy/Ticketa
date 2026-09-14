import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

/// Centralized logger for the application.
/// Provides formatted, tagged logs that are suppressed in release mode.
class AppLogger {
  AppLogger._();

  static const String _defaultTag = 'Ticketa';

  /// Log debug messages (useful for development flow)
  static void d(String message, {String tag = _defaultTag}) {
    if (kDebugMode) {
      developer.log('🔍 [DEBUG] $message', name: tag);
    }
  }

  /// Log informational messages (state changes, successful operations)
  static void i(String message, {String tag = _defaultTag}) {
    if (kDebugMode) {
      developer.log('ℹ️ [INFO] $message', name: tag);
    }
  }

  /// Log warnings (non-fatal issues, cancellations, missing optional data)
  static void w(String message, {String tag = _defaultTag}) {
    if (kDebugMode) {
      developer.log('⚠️ [WARN] $message', name: tag);
    }
  }

  /// Log errors with optional error object and stack trace
  static void e(
    String message, {
    String tag = _defaultTag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (kDebugMode) {
      developer.log(
        '❌ [ERROR] $message',
        name: tag,
        error: error,
        stackTrace: stackTrace,
      );
    }
  }
}
