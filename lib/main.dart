import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

/// Admin
import 'screens/admin_dashboard.dart';

/// User
import 'user/dashboard/user_dashboard.dart';
import 'user/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MatkaApp());
}

class MatkaApp extends StatelessWidget {
  const MatkaApp({super.key});

  /// Switch between User App and Admin App
  static const bool showUserApp = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: showUserApp ? "Matka" : "Matka Admin",
      debugShowCheckedModeBanner: false,

      themeMode: ThemeMode.light,

      theme: showUserApp
          ? UserAppTheme.light
          : ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.deepPurple,
                brightness: Brightness.light,
              ),
              scaffoldBackgroundColor: const Color(0xffF5F7FB),
              dividerColor: const Color(0xffE5E7EB),

              appBarTheme: const AppBarTheme(
                elevation: 0,
                centerTitle: false,
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                surfaceTintColor: Colors.transparent,
              ),

              cardTheme: CardThemeData(
                elevation: 1,
                margin: EdgeInsets.zero,
                color: Colors.white,
                surfaceTintColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),

              inputDecorationTheme: InputDecorationTheme(
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xffE5E7EB),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Colors.deepPurple,
                    width: 2,
                  ),
                ),
              ),

              filledButtonTheme: FilledButtonThemeData(
                style: FilledButton.styleFrom(
                  minimumSize: const Size(120, 42),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              outlinedButtonTheme: OutlinedButtonThemeData(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(120, 42),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              floatingActionButtonTheme:
                  const FloatingActionButtonThemeData(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
              ),

              snackBarTheme: SnackBarThemeData(
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

      home: showUserApp
          ? const UserDashboard()
          : const AdminDashboard(),
    );
  }
}