import 'package:flutter/foundation.dart';

class AppLogger {
  /// Startup trace logger
  static void startup(String message) {
    _print('🚀 [STARTUP] $message');
  }

  /// Authentication lifecycle trace logger
  static void auth(String message) {
    _print('🔐 [AUTH] $message');
  }

  /// Firestore integration and sync trace logger
  static void firestore(String message) {
    _print('🔥 [FIRESTORE] $message');
  }

  /// GDPR security and user consent change trace logger
  static void consent(String message) {
    _print('🛡️ [GDPR_CONSENT] $message');
  }

  /// Scoring calculations trace logger
  static void scoring(String message) {
    _print('🧮 [SCORING] $message');
  }

  /// General execution information logger
  static void info(String message) {
    _print('ℹ️ [INFO] $message');
  }

  /// Warning logger
  static void warning(String message) {
    _print('⚠️ [WARNING] $message');
  }

  /// Error logger
  static void error(String message) {
    _print('❌ [ERROR] $message');
  }

  static void _print(String formatted) {
    if (kDebugMode) {
      print(formatted);
    }
  }
}
