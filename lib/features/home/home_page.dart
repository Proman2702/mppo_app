import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:mppo_app/etc/colors/colors.dart';
import 'package:mppo_app/etc/colors/gradients/background.dart';
import 'package:mppo_app/etc/colors/gradients/tiles.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    //database.getUsers().listen((snapshot) {
    //List<dynamic> users = snapshot.docs;
    //dbGetter = GetValues(user: user!, users: users);
    //setState(() {});
    //});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: AppBar(
            toolbarHeight: 70,
            leadingWidth: 250,
            automaticallyImplyLeading: true,
            backgroundColor: Color(CustomColors.shadowLight),
            leading: Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Row(
                  children: [
                    GradientText(
                      "SmartFridge IOT",
                      colors: [const Color(0xff38CACF), const Color(0xFF32E474)],
                      style: const TextStyle(
                          fontSize: 25, fontFamily: 'Nunito', fontWeight: FontWeight.w800, letterSpacing: 2),
                    )
                  ],
                ),
              ),
            ),
            actions: [
              IconButton(icon: const Icon(Icons.settings, size: 30), color: Color(CustomColors.main), onPressed: () {}),
              const SizedBox(width: 5)
            ],
          )),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [Text("Привет, Бурда!")],
        ),
      ),
    );
  }
}
