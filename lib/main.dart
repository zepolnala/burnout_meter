import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'shared/routing/app_router.dart';
import 'shared/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "demo-burnoutmeter-api-key",
        authDomain: "demo-burnoutmeter.firebaseapp.com",
        projectId: "demo-burnoutmeter",
        storageBucket: "demo-burnoutmeter.appspot.com",
        messagingSenderId: "1234567890",
        appId: "1:1234567890:web:1234567890",
      ),
    );

    if (kDebugMode) {
      const host = 'localhost';
      await FirebaseAuth.instance.useAuthEmulator(host, 9099);
      FirebaseFirestore.instance.useFirestoreEmulator(host, 8080);
      debugPrint('🔥 Connected to Firebase Emulators: Auth (9099), Firestore (8080)');
    }
  } catch (e) {
    debugPrint('⚠️ Firebase Initialization/Emulator error: $e');
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
