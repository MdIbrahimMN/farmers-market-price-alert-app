import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'providers/theme_provider.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'themes/app_theme.dart';

// 🔔 NOTIFICATIONS
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔥 Firebase Init
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyArPkNXYJh5KCFJ-jLPk_nsftPotdISGtg",
      appId: "1:837279673572:android:806adceec6363c3a1010f1",
      messagingSenderId: "837279673572",
      projectId: "farmer1-4b064",
    ),
  );

  // 🔔 INIT NOTIFICATIONS
  await NotificationService.init();

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Farmer App',

      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.themeMode,

      // 🔥 AUTO LOGIN HANDLER
      home: const AuthWrapper(),
    );
  }
}

// 🔥 CLEAN AUTH HANDLER (BETTER THAN DIRECT STREAM IN MAIN)
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {

        // ⏳ Loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // ✅ Logged in
        if (snapshot.hasData) {
          return const DashboardScreen();
        }

        // ❌ Not logged in
        return LoginScreen();
      },
    );
  }
}