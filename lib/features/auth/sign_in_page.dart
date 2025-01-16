import 'dart:developer';
import 'dart:math' as math;
import 'package:mppo_app/etc/colors/colors.dart';
import 'package:mppo_app/etc/colors/gradients/background.dart';
import 'package:mppo_app/etc/colors/gradients/tiles.dart';
import 'package:mppo_app/features/auth/auth_error_hander.dart';
import 'package:mppo_app/features/auth/auth_formats.dart';
import 'package:mppo_app/features/auth/email_notificator.dart';
import 'package:mppo_app/etc/models/user.dart';
import 'package:mppo_app/repositories/auth/auth_service.dart';
import 'package:mppo_app/repositories/database/database_service.dart';
import 'package:flutter/material.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  final auth = AuthService();
  final database = DatabaseService();

  String? username;
  String? email;
  String? password;

  bool obscureBool = true;

  //Map buildAuth() {
  //  Map defs = Defects.getAll();
  //  Map<String, int> newDefs = {};

  //  defs.forEach((i, value) {
  //    newDefs['$i'] = 0;
  //  });
  //  return newDefs;
  //}

  void signUp(String em, String p) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(CustomColors.main)),
            ),
          );
        });

    final user = await auth.createUserWithEmailAndPassword(em, p);
    Navigator.pop(context);

    if (user![0] == 0) {
      await database.addUser(CustomUser(username: username!, email: em));

      Navigator.of(context).pushNamed('/');
      await auth.sendVerification();
      showDialog(context: context, builder: (BuildContext context) => const EmailNotificator(type: "verify"));
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
      child: Stack(
        children: [
          Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(Icons.arrow_back, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    Center(
                      child: SizedBox(
                        height: 80,
                        width: 450,
                        child: Text(
                          "Регистрация",
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
                    SizedBox(height: 20),
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
                      height: 350,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 20),
                          SizedBox(
                            width: 300,
                            child: Text(
                              "Ваш никнейм:",
                              style:
                                  TextStyle(color: Color(CustomColors.main), fontSize: 15, fontWeight: FontWeight.w700),
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
                                Icon(Icons.account_circle_outlined, size: 24, color: Color(CustomColors.bright)),
                                const SizedBox(width: 8),
                                SizedBox(
                                  width: 230,
                                  height: 40,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: ConstrainedBox(
                                      constraints: BoxConstraints.expand(width: AuthSettings().maxUsernameLength * 18),
                                      child: TextField(
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w700, fontSize: 18, color: Colors.black87),
                                        maxLength: AuthSettings().maxUsernameLength,
                                        onChanged: (value) => setState(() {
                                          username = value;
                                        }),
                                        decoration: const InputDecoration(
                                          floatingLabelBehavior: FloatingLabelBehavior.never,
                                          contentPadding: EdgeInsets.only(bottom: 18),
                                          counterText: "",
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                          SizedBox(
                            width: 300,
                            child: Text(
                              "Ваша почта:",
                              style:
                                  TextStyle(color: Color(CustomColors.main), fontSize: 15, fontWeight: FontWeight.w700),
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
                                  width: 230,
                                  height: 40,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: ConstrainedBox(
                                      constraints: BoxConstraints.expand(width: AuthSettings().maxEmailLength * 18),
                                      child: TextField(
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w700, fontSize: 18, color: Colors.black87),
                                        maxLength: AuthSettings().maxEmailLength,
                                        onChanged: (value) => setState(() {
                                          email = value;
                                        }),
                                        decoration: const InputDecoration(
                                          floatingLabelBehavior: FloatingLabelBehavior.never,
                                          contentPadding: EdgeInsets.only(bottom: 18),
                                          counterText: "",
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "Пароль:",
                            style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700),
                          ),
                          Container(
                            height: 45,
                            width: 295,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.white),
                            child: Row(
                              children: [
                                const SizedBox(width: 8),
                                Icon(Icons.key_outlined, size: 24, color: Color(CustomColors.bright)),
                                const SizedBox(width: 8),
                                SizedBox(
                                  width: 210,
                                  height: 40,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: ConstrainedBox(
                                      constraints: BoxConstraints.expand(width: AuthSettings().maxPasswordLength * 18),
                                      child: TextField(
                                        obscureText: obscureBool,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w700, fontSize: 18, color: Colors.black87),
                                        maxLength: AuthSettings().maxPasswordLength,
                                        onChanged: (value) => setState(() {
                                          password = value;
                                        }),
                                        decoration: const InputDecoration(
                                          floatingLabelBehavior: FloatingLabelBehavior.never,
                                          contentPadding: EdgeInsets.only(bottom: 12),
                                          counterText: "",
                                          border: InputBorder.none,
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
                        ],
                      ),
                    ),
                    SizedBox(height: (height - width) > 0 ? height / 11 : height / 18),
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
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                        ),
                        onPressed: () async {
                          if (username == null || password == null) {
                            showModalBottomSheet(
                                context: context, builder: (BuildContext context) => const AuthDenySheet(type: "none"));
                          } else if (username!.length < 4 || password!.length < 4) {
                            showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) => const AuthDenySheet(type: "length"));
                          } else {
                            log("Логин: $username, пароль: $password");
                            signUp(email!, password!);
                          }
                        },
                        child: const Text(
                          "Создать",
                          style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
