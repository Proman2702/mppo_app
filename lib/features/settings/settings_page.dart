// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_import

import 'dart:developer';

import 'package:mppo_app/etc/colors/colors.dart';
import 'package:mppo_app/etc/colors/gradients/background.dart';
import 'package:mppo_app/features/auth/auth_error_hander.dart';
import 'package:mppo_app/features/settings/confirmation_dialog.dart';
import 'package:mppo_app/features/auth/auth_formats.dart';
import 'package:mppo_app/repositories/auth/auth_service.dart';
import 'package:mppo_app/repositories/database/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  User? user;
  String? password;
  String? newPassword;
  String? newPassword2;
  String? newIp;

  @override
  void didChangeDependencies() {
    final args = ModalRoute.of(context)?.settings.arguments;

    if (args != null) {
      user = args as User;
    }

    super.didChangeDependencies();
  }

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
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.transparent,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(70.0),
          child: AppBar(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30))),
            backgroundColor: Colors.white,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                  gradient: BackgroundGrad(),
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30))),
            ),
            elevation: 5,
            shadowColor: Colors.black,
            toolbarHeight: 75,
            leadingWidth: 60,
            centerTitle: true,
            automaticallyImplyLeading: true,
            leading: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 30,
                )),
            title: const Padding(
              padding: EdgeInsets.only(left: 0.0),
              child: const Text('Настройки',
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Nunito',
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1)),
            ),
            actions: [SizedBox(width: 50)],
          ),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return ChangePasswordDialog(context);
                      },
                    );
                  },
                  child: Container(
                    height: 100,
                    width: 330,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(offset: Offset(0, 3), blurRadius: 5, spreadRadius: 1, color: Colors.black26)
                        ],
                        borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: 30),
                        Container(
                          alignment: Alignment.centerLeft,
                          height: 60,
                          width: 180,
                          child: Text(
                            "Сменить пароль",
                            style: TextStyle(
                                color: Color(CustomColors.main),
                                height: 1.2,
                                fontSize: 22,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                        SizedBox(width: 20),
                        Container(width: 2, height: 50, color: Colors.black12),
                        SizedBox(width: 15),
                        Icon(Icons.lock_open_outlined, size: 50, color: Color(CustomColors.bright)),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => ConfirmationDialog(info: "Вы уверены, что хотите выйти?", action: signOut),
                    );
                  },
                  child: Container(
                    height: 100,
                    width: 330,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(offset: Offset(0, 3), blurRadius: 5, spreadRadius: 1, color: Colors.black26)
                        ],
                        borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: 30),
                        Container(
                          alignment: Alignment.centerLeft,
                          height: 60,
                          width: 180,
                          child: Text(
                            "Выйти из профиля",
                            style: TextStyle(
                                color: Color(CustomColors.main),
                                height: 1.2,
                                fontSize: 22,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                        SizedBox(width: 20),
                        Container(width: 2, height: 50, color: Colors.black12),
                        SizedBox(width: 15),
                        Icon(Icons.meeting_room, size: 50, color: Color(CustomColors.bright))
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () => showDialog(
                    context: context,
                    builder: (context) {
                      return delConfirmDialog(context);
                    },
                  ),
                  child: Container(
                    height: 100,
                    width: 330,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        gradient: BackgroundGrad(),
                        boxShadow: [
                          BoxShadow(offset: Offset(0, 3), blurRadius: 5, spreadRadius: 1, color: Colors.black26)
                        ],
                        borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            alignment: Alignment.centerLeft,
                            height: 60,
                            width: 180,
                            child: Text("Удалить аккаунт",
                                style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700))),
                        SizedBox(width: 20),
                        Container(width: 2, height: 50, color: Colors.white),
                        SizedBox(width: 15),
                        Icon(Icons.delete_outlined, size: 50, color: Colors.white)
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  AlertDialog delConfirmDialog(BuildContext context) {
    return AlertDialog(
      title: Text(
        "Повторно введите пароль, чтобы подтвердить удаление",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
      ),
      content: Container(
        height: 40,
        width: 295,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), border: Border.all(), color: Colors.white),
        child: Row(
          children: [
            SizedBox(width: 8),
            Icon(Icons.key_outlined, size: 24, color: Color(CustomColors.bright)),
            SizedBox(width: 8),
            SizedBox(
              width: 210,
              height: 40,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ConstrainedBox(
                  constraints: BoxConstraints.expand(width: AuthSettings().maxPasswordLength * 18),
                  child: TextField(
                    obscureText: false,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: Colors.black87),
                    maxLength: AuthSettings().maxPasswordLength,
                    onChanged: (value) => setState(() {
                      password = value;
                    }),
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      contentPadding: EdgeInsets.only(bottom: 12),
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
                      builder: (BuildContext context) => AuthDenySheet(
                            type: "none",
                          ));
                } else {
                  log("$user");
                  deleteAccount(user!.email, password!);
                  Navigator.pop(context);
                }
              },
              child: const Text("Удалить",
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700))),
        ),
      ],
    );
  }

  AlertDialog ChangePasswordDialog(BuildContext context) {
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
            decoration:
                BoxDecoration(borderRadius: BorderRadius.circular(20), border: Border.all(), color: Colors.white),
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
                      constraints: BoxConstraints.expand(width: AuthSettings().maxPasswordLength * 18),
                      child: TextField(
                        obscureText: false,
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: Colors.black87),
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
                          labelStyle: TextStyle(color: Colors.black12, fontSize: 20, fontWeight: FontWeight.w700),
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
            decoration:
                BoxDecoration(borderRadius: BorderRadius.circular(20), border: Border.all(), color: Colors.white),
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
                      constraints: BoxConstraints.expand(width: AuthSettings().maxPasswordLength * 18),
                      child: TextField(
                        obscureText: false,
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: Colors.black87),
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
                          labelStyle: TextStyle(color: Colors.black12, fontSize: 20, fontWeight: FontWeight.w700),
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
            decoration:
                BoxDecoration(borderRadius: BorderRadius.circular(20), border: Border.all(), color: Colors.white),
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
                      constraints: BoxConstraints.expand(width: AuthSettings().maxPasswordLength * 18),
                      child: TextField(
                        obscureText: false,
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: Colors.black87),
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
                          labelStyle: TextStyle(color: Colors.black12, fontSize: 20, fontWeight: FontWeight.w700),
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
                      builder: (BuildContext context) => AuthDenySheet(
                            type: "none",
                          ));
                } else if (newPassword != newPassword2) {
                  showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) => AuthDenySheet(
                            type: "not_equal",
                          ));
                } else {
                  log("$user");
                  changePassword(user!.email, password!, newPassword!);
                  Navigator.pop(context);
                }
              },
              child: const Text("Сменить",
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700))),
        ),
      ],
    );
  }
}
