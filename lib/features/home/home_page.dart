import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:mppo_app/etc/colors/colors.dart';
import 'package:mppo_app/etc/colors/gradients/background.dart';
import 'package:mppo_app/etc/colors/gradients/tiles.dart';
import 'package:mppo_app/features/drawer.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      drawer: AppDrawer(chosen: 0),
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: AppBar(
            toolbarHeight: 75,
            leadingWidth: 70,
            automaticallyImplyLeading: true,
            backgroundColor: Color(CustomColors.shadowLight),
            flexibleSpace: Container(
              decoration: BoxDecoration(
                  gradient: BackgroundGrad(),
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50), bottomRight: Radius.circular(50))),
            ),
            leading: IconButton(
                onPressed: () {
                  _scaffoldKey.currentState!.openDrawer();
                },
                icon: Icon(Icons.menu, color: Colors.white, size: 35)),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50), bottomRight: Radius.circular(50))),
            title: const Padding(
              padding: EdgeInsets.only(left: 20.0),
              child: const Text('SmartFridge',
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Nunito',
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2)),
            ),
          )),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Container(
                height: 40,
                width: 340,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Color.fromARGB(16, 0, 0, 0),
                ),
                child: Row(
                  children: [
                    SizedBox(width: 8),
                    Icon(Icons.search, size: 24, color: Color(CustomColors.bright)),
                    SizedBox(width: 8),
                    SizedBox(
                      width: 300,
                      height: 40,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ConstrainedBox(
                          constraints: BoxConstraints.expand(width: 400), // 18 - fontSize
                          child: TextField(
                            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: Colors.black87),
                            maxLength: 20,
                            onChanged: (value) => setState(() {}),
                            decoration: const InputDecoration(
                              floatingLabelBehavior: FloatingLabelBehavior.never,
                              contentPadding: EdgeInsets.only(bottom: 14),
                              counterText: "",
                              border: InputBorder.none,
                              labelText: "Поиск",
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
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/scan/camera');
        },
        focusColor: Color(CustomColors.main),
        backgroundColor: Color(CustomColors.main),
        child: Icon(Icons.qr_code_2_outlined, color: Colors.white, size: 40),
      ),
    );
  }
}
