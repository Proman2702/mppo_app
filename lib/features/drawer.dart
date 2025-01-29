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
  final double spacing = 10;

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
              SizedBox(height: 60),
              Text('SF App',
                  style: TextStyle(
                      letterSpacing: 2,
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Nunito')),
              SizedBox(height: 40),
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
                    Navigator.of(context).pushNamed('/scan');
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
              const Flexible(child: SizedBox(height: 120)),
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
