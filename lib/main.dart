import 'package:mppo_app/features/auth/forgot_password_page.dart';
import 'package:mppo_app/features/auth/sign_in_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mppo_app/features/scanner/camera.dart';
import 'package:mppo_app/features/scanner/generator_page.dart';
import 'package:mppo_app/features/scanner/scanner_page.dart';
import 'package:mppo_app/features/settings/settings_page.dart';
import 'package:mppo_app/features/stats/history_page.dart';
import 'package:mppo_app/features/stats/stats_page.dart';
import 'package:mppo_app/features/wrapper.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => Wrapper(),
        '/auth/create': (context) => FirstPage(),
        '/home/settings': (context) => SettingsPage(),
        '/auth/forgot': (context) => ForgotPasswordPage(),
        '/stats': (context) => StatsPage(),
        '/scan': (context) => ScannerPage(),
        '/scan/camera': (context) => ScannerPageMenu(),
        '/scan/generator': (context) => GeneratorPage(),
        '/history': (context) => HistoryPage(),
      },
      theme: ThemeData(fontFamily: "Jura"),
    );
  }
}
