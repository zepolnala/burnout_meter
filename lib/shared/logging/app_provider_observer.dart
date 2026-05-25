import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'app_logger.dart';

class AppProviderObserver extends ProviderObserver {
  @override
  void didAddProvider(
    ProviderBase<Object?> provider,
    Object? value,
    ProviderContainer container,
  ) {
    AppLogger.info('📥 [PROVIDER_ADD] ${provider.name ?? provider.runtimeType} initialized');
  }

  @override
  void didUpdateProvider(
    ProviderBase<Object?> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    // Keep it light in logs
    AppLogger.info('🔄 [PROVIDER_UPDATE] ${provider.name ?? provider.runtimeType} updated');
  }

  @override
  void didDisposeProvider(
    ProviderBase<Object?> provider,
    ProviderContainer container,
  ) {
    AppLogger.info('📤 [PROVIDER_DISPOSE] ${provider.name ?? provider.runtimeType} disposed');
  }

  @override
  void providerDidFail(
    ProviderBase<Object?> provider,
    Object error,
    StackTrace stackTrace,
    ProviderContainer container,
  ) {
    AppLogger.error('❌ [PROVIDER_FAIL] ${provider.name ?? provider.runtimeType} failed: $error');
    
    // Log to Crashlytics as a non-fatal error for B2B observability
    FirebaseCrashlytics.instance.recordError(
      error,
      stackTrace,
      reason: 'Riverpod Provider ${provider.name ?? provider.runtimeType} failed',
      fatal: false,
    );
  }
}
