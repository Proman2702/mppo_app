import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mppo_app/etc/colors/colors.dart';
import 'package:mppo_app/etc/colors/gradients/background.dart';
import 'package:mppo_app/features/auth/auth_error_hander.dart';
import 'package:mppo_app/features/auth/auth_formats.dart';
import 'package:mppo_app/repositories/auth/auth_service.dart';
import 'package:mppo_app/repositories/database/database_service.dart';

// ignore: must_be_immutable
class SettingsDialog extends StatefulWidget {
  User? user;
  SettingsDialog({super.key, required this.user});

  @override
  State<SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  String? password;
  String? newPassword;
  String? newPassword2;
  String? newIp;

  final auth = AuthService();
  final database = DatabaseService();

  void signOut() async {
    await auth.signOut();
    Navigator.of(context).pushReplacementNamed("/");
  }

  void deleteAccount(email, password) async {
    final res = await auth.deleteAccount(email, password);

    if (res[0] == 0) {
      await database.deleteUser(email);

      Navigator.of(context).pushReplacementNamed("/");
    } else {
      showModalBottomSheet(context: context, builder: (BuildContext context) => AuthDenySheet(type: res[1]));
    }
  }

  void changePassword(email, password, newPassword) async {
    final res = await auth.changePassword(email, password, newPassword);

    if (res[0] == 0) {
      showModalBottomSheet(context: context, builder: (BuildContext context) => AuthDenySheet(type: "success"));
    } else {
      showModalBottomSheet(context: context, builder: (BuildContext context) => AuthDenySheet(type: res[1]));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.all(20),
      backgroundColor: Colors.white,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 65,
                width: 260,
                decoration: BoxDecoration(gradient: BackgroundGrad(), borderRadius: BorderRadius.circular(20)),
                alignment: Alignment.center,
                child: const Text(
                  'Настройки',
                  style:
                      TextStyle(color: Colors.white, fontSize: 32, fontFamily: 'Nunito', fontWeight: FontWeight.bold),
                ),
              ),
              const Flexible(child: SizedBox(width: 450)),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 65,
                      height: 65,
                      decoration: BoxDecoration(gradient: BackgroundGrad(), borderRadius: BorderRadius.circular(20)),
                      alignment: Alignment.center,
                      child: const Icon(Icons.text_fields, size: 35, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text('Сменить IP сервера',
                      style: TextStyle(color: Color(CustomColors.bright), fontSize: 13, fontWeight: FontWeight.bold))
                ],
              )
            ],
          ),
          const SizedBox(height: 50),
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: 180,
                      width: 180,
                      decoration: BoxDecoration(
                          color: Color(0xFFF8F8F8),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 2, offset: Offset(0, 5))]),
                      alignment: Alignment.center,
                      child: Icon(Icons.directions_walk, size: 95, color: Color(CustomColors.main)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text('Сменить аккаунт',
                      style: TextStyle(color: Color(CustomColors.bright), fontSize: 20, fontWeight: FontWeight.bold))
                ],
              ),
              SizedBox(width: 70),
              Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(
                              "Введите ваш текущий пароль и тот, на который хотите изменить его",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                            ),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  height: 40,
                                  width: 295,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(),
                                      color: Colors.white),
                                  child: Row(
                                    children: [
                                      SizedBox(width: 8),
                                      Icon(Icons.remove, size: 24, color: Color(CustomColors.bright)),
                                      SizedBox(width: 8),
                                      SizedBox(
                                        width: 210,
                                        height: 40,
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: ConstrainedBox(
                                            constraints:
                                                BoxConstraints.expand(width: AuthSettings().maxPasswordLength * 18),
                                            child: TextField(
                                              obscureText: false,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w700, fontSize: 18, color: Colors.black87),
                                              maxLength: AuthSettings().maxPasswordLength,
                                              onChanged: (value) => setState(() {
                                                password = value;
                                              }),
                                              decoration: InputDecoration(
                                                floatingLabelBehavior: FloatingLabelBehavior.never,
                                                contentPadding: EdgeInsets.only(bottom: 12),
                                                counterText: "",
                                                border: InputBorder.none,
                                                labelText: "Старый пароль",
                                                labelStyle: TextStyle(
                                                    color: Colors.black12, fontSize: 20, fontWeight: FontWeight.w700),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10),
                                Container(
                                  height: 40,
                                  width: 295,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(),
                                      color: Colors.white),
                                  child: Row(
                                    children: [
                                      SizedBox(width: 8),
                                      Icon(Icons.add, size: 24, color: Color(CustomColors.bright)),
                                      SizedBox(width: 8),
                                      SizedBox(
                                        width: 210,
                                        height: 40,
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: ConstrainedBox(
                                            constraints:
                                                BoxConstraints.expand(width: AuthSettings().maxPasswordLength * 18),
                                            child: TextField(
                                              obscureText: false,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w700, fontSize: 18, color: Colors.black87),
                                              maxLength: AuthSettings().maxPasswordLength,
                                              onChanged: (value) => setState(() {
                                                newPassword = value;
                                              }),
                                              decoration: InputDecoration(
                                                floatingLabelBehavior: FloatingLabelBehavior.never,
                                                contentPadding: EdgeInsets.only(bottom: 12),
                                                counterText: "",
                                                border: InputBorder.none,
                                                labelText: "Новый пароль",
                                                labelStyle: TextStyle(
                                                    color: Colors.black12, fontSize: 20, fontWeight: FontWeight.w700),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10),
                                Container(
                                  height: 40,
                                  width: 295,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(),
                                      color: Colors.white),
                                  child: Row(
                                    children: [
                                      SizedBox(width: 8),
                                      Icon(Icons.add, size: 24, color: Color(CustomColors.bright)),
                                      SizedBox(width: 8),
                                      SizedBox(
                                        width: 210,
                                        height: 40,
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: ConstrainedBox(
                                            constraints:
                                                BoxConstraints.expand(width: AuthSettings().maxPasswordLength * 18),
                                            child: TextField(
                                              obscureText: false,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w700, fontSize: 18, color: Colors.black87),
                                              maxLength: AuthSettings().maxPasswordLength,
                                              onChanged: (value) => setState(() {
                                                newPassword2 = value;
                                              }),
                                              decoration: InputDecoration(
                                                floatingLabelBehavior: FloatingLabelBehavior.never,
                                                contentPadding: EdgeInsets.only(bottom: 12),
                                                counterText: "",
                                                border: InputBorder.none,
                                                labelText: "Повторите пароль",
                                                labelStyle: TextStyle(
                                                    color: Colors.black12, fontSize: 20, fontWeight: FontWeight.w700),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            actionsAlignment: MainAxisAlignment.center,
                            actionsPadding: EdgeInsets.only(bottom: 20),
                            actions: [
                              SizedBox(
                                height: 35,
                                width: 130,
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(CustomColors.main),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                                    onPressed: () {
                                      if (password == null) {
                                        showModalBottomSheet(
                                            context: context,
                                            builder: (BuildContext context) => AuthDenySheet(type: "none"));
                                      } else if (newPassword != newPassword2) {
                                        showModalBottomSheet(
                                            context: context,
                                            builder: (BuildContext context) => AuthDenySheet(type: "not_equal"));
                                      } else {
                                        log("${widget.user!}");
                                        changePassword(widget.user!.email, password!, newPassword!);
                                        Navigator.pop(context);
                                      }
                                    },
                                    child: const Text("Сменить",
                                        style:
                                            TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700))),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Container(
                      height: 180,
                      width: 180,
                      decoration: BoxDecoration(
                          color: Color(0xFFF8F8F8),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 2, offset: Offset(0, 5))]),
                      alignment: Alignment.center,
                      child: Icon(Icons.edit, size: 88, color: Color(CustomColors.main)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text('Сменить пароль',
                      style: TextStyle(color: Color(CustomColors.bright), fontSize: 20, fontWeight: FontWeight.bold))
                ],
              ),
              SizedBox(width: 70),
              Column(
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: 180,
                      width: 180,
                      decoration: BoxDecoration(
                          color: Color(0xFFF8F8F8),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 2, offset: Offset(0, 5))]),
                      alignment: Alignment.center,
                      child: Icon(Icons.delete, size: 95, color: Color(CustomColors.delete)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text('Удалить аккаунт',
                      style: TextStyle(color: Color(CustomColors.bright), fontSize: 20, fontWeight: FontWeight.bold))
                ],
              )
            ],
          ),
          SizedBox(height: 50)
        ],
      ),
    );
  }
}
