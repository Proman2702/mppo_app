import 'dart:developer';

import 'package:mppo_app/etc/colors/colors.dart';
import 'package:mppo_app/etc/colors/gradients/background.dart';
import 'package:mppo_app/features/auth/auth_page.dart';
import 'package:mppo_app/features/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: BackgroundGrad()),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container();
              } else if (snapshot.hasError) {
                return Text(
                  "<Wrapper> Произошла ошибка ${snapshot.error.toString()}!",
                  style: TextStyle(color: Color(CustomColors.delete), fontSize: 40, fontWeight: FontWeight.w700),
                );
              } else {
                if (snapshot.data == null) {
                  log("<Wrapper> Ошибка");
                  return const AuthPage();
                } else if (snapshot.data!.emailVerified == false) {
                  log("<Wrapper> Нет верификации!");
                  return const AuthPage();
                } else {
                  log("<Wrapper> Вход");
                  return const HomePage();
                }
              }
            }),
      ),
    );
  }
}
