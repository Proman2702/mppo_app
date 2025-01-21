// ignore_for_file: prefer_const_constructors

import 'dart:developer';
import 'package:mppo_app/etc/colors/colors.dart';
import 'package:mppo_app/etc/colors/gradients/background.dart';
import 'package:mppo_app/etc/colors/gradients/tiles.dart';
import 'package:mppo_app/features/auth/auth_error_hander.dart';
import 'package:mppo_app/features/auth/email_notificator.dart';
import 'package:mppo_app/repositories/auth/auth_service.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  String? email;
  final auth = AuthService();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double height = size.height;
    double width = size.width;

    return Container(
      decoration: BoxDecoration(gradient: BackgroundGrad()),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: height / 20),
                Center(
                  child: SizedBox(
                    height: 120,
                    width: 450,
                    child: Text(
                      "Восстановление пароля",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 50,
                        fontFamily: 'Nunito',
                        color: Colors.white,
                        letterSpacing: 1,
                        height: 1.1,
                        shadows: <Shadow>[
                          Shadow(
                            offset: Offset(0.0, 4.0),
                            blurRadius: 4.0,
                            color: Colors.black26,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: height / 15),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.white,
                    boxShadow: const <BoxShadow>[
                      BoxShadow(
                        offset: Offset(0.0, 4.0),
                        blurRadius: 4.0,
                        color: Colors.black26,
                      ),
                    ],
                  ),
                  width: 375,
                  height: 300,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 60,
                        width: 300,
                        child: Text(
                          "Введите почту, к которой привязывали аккаунт",
                          style: TextStyle(color: Color(CustomColors.main), fontWeight: FontWeight.w700, fontSize: 15),
                        ),
                      ),
                      Container(
                        height: 45,
                        width: 295,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Color(CustomColors.main), width: 5),
                          color: Colors.white,
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 8),
                            Icon(Icons.mail_outline, size: 24, color: Color(CustomColors.bright)),
                            const SizedBox(width: 8),
                            SizedBox(
                              width: 235,
                              height: 45,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: ConstrainedBox(
                                  constraints: const BoxConstraints.expand(width: 600), // 18 - fontSize
                                  child: TextField(
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w700, fontSize: 16, color: Colors.black87),
                                    maxLength: 40,
                                    onChanged: (value) => setState(() {
                                      email = value;
                                    }),
                                    decoration: const InputDecoration(
                                      floatingLabelBehavior: FloatingLabelBehavior.never,
                                      contentPadding: EdgeInsets.only(bottom: 17),
                                      counterText: "",
                                      border: InputBorder.none,
                                      labelText: "Почта",
                                      labelStyle: TextStyle(
                                        color: Colors.black12,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 100),
                      Container(
                        height: 40,
                        width: 220,
                        decoration: BoxDecoration(
                            gradient: ButtonGrad(),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(spreadRadius: 1, offset: Offset(0, 2), blurRadius: 2, color: Colors.black26)
                            ]),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                          ),
                          onPressed: () async {
                            if (email == null) {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext context) => const AuthDenySheet(type: "none"));
                            } else {
                              log("Почта: $email");
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Center(
                                      child: CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation<Color>(Color(CustomColors.main)),
                                      ),
                                    );
                                  });
                              final result = await auth.resetPassword(email!);
                              Navigator.of(context).pop();
                              if (result[0] == 0) {
                                Navigator.of(context).pop();
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) => EmailNotificator(type: "sent"));
                              } else {
                                showModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext context) => AuthDenySheet(type: result[1]));
                              }
                            }
                          },
                          child: Text(
                            "Восстановить",
                            style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                    ],
                  ),
                ),
                SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
