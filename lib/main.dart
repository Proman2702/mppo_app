import 'package:mppo_app/features/auth/forgot_password_page.dart';
import 'package:mppo_app/features/auth/sign_in_page.dart';
import 'package:mppo_app/features/home/help_page.dart';
import 'package:mppo_app/features/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
        '/': (context) => const Wrapper(),
        '/help': (context) => const HelpPage(),
        '/auth/create': (context) => const FirstPage(),
        '/auth/forgot': (context) => const ForgotPasswordPage(),
      },
      theme: ThemeData(fontFamily: "Jura"),
    );
  }
}
