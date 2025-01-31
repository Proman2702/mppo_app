// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:mppo_app/etc/colors/colors.dart';
import 'package:mppo_app/etc/colors/gradients/background.dart';
import 'dart:math' as math;
import 'package:mppo_app/etc/colors/gradients/drawer.dart';
import 'package:mppo_app/repositories/database/database_service.dart';
import 'package:mppo_app/repositories/database/get_values.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatefulWidget {
  final int chosen;

  const AppDrawer({super.key, required this.chosen});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  final double spacing = 7;

  final database = DatabaseService();
  User? user;
  List<dynamic>? users;
  GetValues? dbGetter;

  /*asyncGetter() async {
    database.getUsers().listen((snapshot) {
      List<dynamic> usersTmp = snapshot.docs;
      dbGetter = GetValues(user: user!, users: usersTmp);
      setState(() {
        users = usersTmp;
      });
    });
  }*/

  @override
  void initState() {
    user = FirebaseAuth.instance.currentUser;
    super.initState();

    //asyncGetter();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 270,
      elevation: 20,
      child: Container(
        decoration: BoxDecoration(gradient: BackgroundGrad()),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 50),
              Text('SF App',
                  style: TextStyle(
                      letterSpacing: 2,
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Nunito')),
              SizedBox(height: 10),
              Container(
                height: 90,
                width: 230,
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 10, right: 10),
                decoration: BoxDecoration(
                    color: Color.fromARGB(153, 0, 255, 247),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(color: Colors.black12, offset: Offset(0, 3), spreadRadius: 1, blurRadius: 2)
                    ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: dbGetter?.getUser()?.username == null
                      ? [CircularProgressIndicator()]
                      : [
                          Text(dbGetter!.getUser()!.username,
                              style: TextStyle(
                                  color: Color(CustomColors.bright),
                                  fontFamily: 'nunito',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17)),
                          Text(
                            dbGetter!.getUser()!.email,
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                ),
              ),
              SizedBox(height: 10),
              Container(
                width: 140,
                height: 3,
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)),
              ),
              SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  if (widget.chosen != 0) {
                    Navigator.of(context).pushNamed('/');
                  }
                },
                child: Container(
                  width: 230,
                  height: 40,
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: widget.chosen == 0 ? Colors.white24 : Colors.transparent),
                  child: Row(
                    children: [
                      Icon(
                        Icons.home_outlined,
                        color: Colors.white,
                      ),
                      SizedBox(width: 15),
                      Text(
                        "Главное меню",
                        style: TextStyle(
                            fontFamily: 'Jura', fontSize: 20, color: Colors.white, fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: spacing),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  if (widget.chosen != 1) {
                    Navigator.of(context).pushNamed('/scan/camera');
                  }
                },
                child: Container(
                  width: 230,
                  height: 40,
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: widget.chosen == 1 ? Colors.white24 : Colors.transparent),
                  child: Row(
                    children: [
                      Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                      SizedBox(width: 15),
                      Text(
                        "Сканировать",
                        style: TextStyle(
                            fontFamily: 'Jura', fontSize: 20, color: Colors.white, fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: spacing),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  if (widget.chosen != 2) {
                    Navigator.of(context).pushNamed('/stats');
                  }
                },
                child: Container(
                  width: 230,
                  height: 40,
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: widget.chosen == 2 ? Colors.white24 : Colors.transparent),
                  child: Row(
                    children: [
                      Icon(Icons.question_mark, color: Colors.white),
                      SizedBox(width: 15),
                      Text(
                        "Статистика",
                        style: TextStyle(
                            fontFamily: 'Jura', fontSize: 20, color: Colors.white, fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: spacing),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  if (widget.chosen != 3) {
                    Navigator.of(context).pushNamed('/history');
                  }
                },
                child: Container(
                  width: 230,
                  height: 40,
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: widget.chosen == 3 ? Colors.white24 : Colors.transparent),
                  child: Row(
                    children: [
                      Icon(
                        Icons.history,
                        color: Colors.white,
                      ),
                      SizedBox(width: 15),
                      Text(
                        "История",
                        style: TextStyle(
                            fontFamily: 'Jura', fontSize: 20, color: Colors.white, fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: spacing),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  if (widget.chosen != 4) {
                    Navigator.of(context).pushNamed('/scan/generator');
                  }
                },
                child: Container(
                  width: 230,
                  height: 40,
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: widget.chosen == 4 ? Colors.white24 : Colors.transparent),
                  child: Row(
                    children: [
                      Icon(Icons.qr_code, color: Colors.white),
                      SizedBox(width: 15),
                      Text(
                        "QR генератор",
                        style: TextStyle(
                            fontFamily: 'Jura', fontSize: 20, color: Colors.white, fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: spacing),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  if (widget.chosen != 5) {
                    Navigator.of(context).pushNamed('/home/settings', arguments: user);
                  }
                },
                child: Container(
                  width: 230,
                  height: 40,
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: widget.chosen == 5 ? Colors.white24 : Colors.transparent),
                  child: Row(
                    children: [
                      Icon(Icons.settings, color: Colors.white),
                      SizedBox(width: 15),
                      Text(
                        "Настройки",
                        style: TextStyle(
                            fontFamily: 'Jura', fontSize: 20, color: Colors.white, fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 15),
              Stack(
                children: [
                  Padding(
                      padding: EdgeInsets.only(left: 40, top: 35),
                      child: Transform.rotate(
                        angle: 2 * math.pi,
                        child: Image.asset(
                          "assets/images/hexagon_grad.png",
                          scale: 1.6,
                          opacity: const AlwaysStoppedAnimation(0.5),
                          alignment: Alignment.center,
                          color: Colors.white38,
                        ),
                      )),
                  Padding(
                      padding: EdgeInsets.only(right: 0, bottom: 0),
                      child: Transform.rotate(
                        angle: 2 * math.pi,
                        child: Image.asset(
                          "assets/images/hexagon_grad.png",
                          scale: 1.9,
                          opacity: const AlwaysStoppedAnimation(0.2),
                          alignment: Alignment.center,
                          color: Colors.white54,
                        ),
                      )),
                ],
              ),
              const Flexible(child: SizedBox(height: 0)),
              SizedBox(
                  height: 40,
                  width: 170,
                  child: Text(
                    'Created and designed by Proman2702',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white24),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
