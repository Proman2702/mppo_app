import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mppo_app/etc/colors/colors.dart';
import 'package:mppo_app/etc/colors/gradients/background.dart';
import 'package:mppo_app/etc/colors/gradients/tiles.dart';
import 'package:mppo_app/features/auth/auth_error_hander.dart';
import 'package:mppo_app/repositories/auth/auth_service.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool obscureBool = true;
  String? username;
  String? password;
  AuthService auth = AuthService();

  void signIn(String em, String p) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(CustomColors.mainLight)),
            ),
          );
        });

    final List user = await auth.loginUserWithEmailAndPassword(em, p);
    Navigator.pop(context);
    Navigator.of(context).pushNamed('/');

    if (user[0] == 0) {
      if (user[1].emailVerified) {
        log(user[1].emailVerified.toString());
        log("Успешный вход");
      } else {
        showModalBottomSheet(context: context, builder: (BuildContext context) => AuthDenySheet(type: "verify"));
      }
    } else if (user[0] == 1) {
      log("Ошибка ${user[1]}");

      showModalBottomSheet(context: context, builder: (BuildContext context) => AuthDenySheet(type: user[1]));
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double height = size.height;
    double width = size.width;

    return Container(
      decoration: BoxDecoration(gradient: BackgroundGrad()),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Center(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: 200),
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: height / 10),
                        const SizedBox(
                          height: 110,
                          child: Text(
                            'Note AI',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 96,
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w800,
                              letterSpacing: 5,
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
                        const Padding(
                          padding: EdgeInsets.only(left: 210.0),
                          child: SizedBox(
                            width: 400,
                            height: 50,
                            child: Text(
                              "Explore the beauty of music language",
                              style: TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ),
                        )
                      ],
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
                          const SizedBox(height: 30),
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
                                  height: 40,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: ConstrainedBox(
                                      constraints: const BoxConstraints.expand(width: 600),
                                      child: TextField(
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w700, fontSize: 19, color: Colors.black87),
                                        maxLength: 30,
                                        onChanged: (value) => setState(() {
                                          username = value;
                                        }),
                                        decoration: const InputDecoration(
                                          floatingLabelBehavior: FloatingLabelBehavior.never,
                                          contentPadding: EdgeInsets.only(bottom: 15),
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
                          const SizedBox(height: 18),
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
                                Icon(Icons.lock_outline, size: 24, color: Color(CustomColors.bright)),
                                const SizedBox(width: 8),
                                SizedBox(
                                  width: 200,
                                  height: 40,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: ConstrainedBox(
                                      constraints: const BoxConstraints.expand(width: 450), // 18 - fontSize
                                      child: TextField(
                                        obscureText: obscureBool,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w700, fontSize: 19, color: Colors.black87),
                                        maxLength: 30,
                                        onChanged: (value) => setState(() {
                                          password = value;
                                        }),
                                        decoration: const InputDecoration(
                                          floatingLabelBehavior: FloatingLabelBehavior.never,
                                          contentPadding: EdgeInsets.only(bottom: 15),
                                          counterText: "",
                                          border: InputBorder.none,
                                          labelText: "Пароль",
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
                                IconButton(
                                    iconSize: 20,
                                    visualDensity: VisualDensity.compact,
                                    onPressed: () => setState(() {
                                          obscureBool = !obscureBool;
                                        }),
                                    icon:
                                        !obscureBool ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off))
                              ],
                            ),
                          ),
                          const SizedBox(height: 5),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed("/auth/forgot");
                              log("Forgot the password");
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(left: 170),
                              child: Text(
                                "Забыли пароль?",
                                style: TextStyle(
                                  color: Color(CustomColors.main),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Color(CustomColors.main),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 50),
                          Container(
                            height: 40,
                            width: 180,
                            decoration: BoxDecoration(
                                gradient: ButtonGrad(),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: const [
                                  BoxShadow(spreadRadius: 1, offset: Offset(0, 2), blurRadius: 2, color: Colors.black26)
                                ]),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent, shadowColor: Colors.transparent),
                              onPressed: () async {
                                if (username == null || password == null) {
                                  showModalBottomSheet(
                                      context: context,
                                      builder: (BuildContext context) => const AuthDenySheet(type: "none"));
                                } else if (username!.length < 4 || password!.length < 4) {
                                  showModalBottomSheet(
                                      context: context,
                                      builder: (BuildContext context) => AuthDenySheet(type: "length"));
                                } else {
                                  log("Логин: $username, пароль: $password");
                                  signIn(username!, password!);
                                }
                              },
                              child: const Text(
                                "Войти",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700, fontFamily: 'Jura'),
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed("/auth/create");
                            },
                            child: Text(
                              'Создать аккаунт',
                              style: TextStyle(
                                  color: Color(CustomColors.main),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Color(CustomColors.main),
                                  fontFamily: "Jura"),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 100)
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
