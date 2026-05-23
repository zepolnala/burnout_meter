import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'shared/routing/app_router.dart';
import 'shared/theme/app_theme.dart';
import 'shared/logging/app_logger.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AppLogger.info('🚀 [LIFECYCLE] Bootstrapping BurnoutMeter application');
  
  try {
    AppLogger.info('⚡ [FIREBASE] Initializing Firebase Core...');
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyAKOFkCWQ14vp_tkTydQXjWe2ovYGDgZOo',
        authDomain: 'burnoutmeter-zepolnala.firebaseapp.com',
        projectId: 'burnoutmeter-zepolnala',
        storageBucket: 'burnoutmeter-zepolnala.appspot.com',
        messagingSenderId: '515645476384',
        appId: '1:515645476384:web:7ef1ebc4282d108bb83645',
      ),
    );

    const bool useEmulator = bool.fromEnvironment('USE_EMULATOR', defaultValue: false);
    if (useEmulator) {
      const host = '127.0.0.1';
      await FirebaseAuth.instance.useAuthEmulator(host, 9099);
      FirebaseFirestore.instance.useFirestoreEmulator(host, 8080);
      AppLogger.info('🔥 [EMULATOR] Connected to Firebase Emulators: Auth (9099), Firestore (8080)');
    } else {
      AppLogger.info('☁️ [CLOUD] Connected directly to Firebase Cloud services: burnoutmeter-zepolnala');
    }
    
    AppLogger.info('✅ [FIREBASE] Initialization sequence complete');
  } catch (e) {
    AppLogger.error('❌ [FIREBASE] Initialization/Emulator fatal error: $e');
  }

  runApp(
    const ProviderScope(
      child: BurnoutMeterApp(),
    ),
  );
}

class BurnoutMeterApp extends ConsumerWidget {
  const BurnoutMeterApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'BurnoutMeter B2B',
      debugShowCheckedModeBanner: false,
      
      // Theme binding
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark, // Defaulting to premium dark mode in this demo

      // Navigation routing
      routerConfig: router,
    );
  }
}
