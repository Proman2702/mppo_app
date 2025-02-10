import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mppo_app/etc/colors/colors.dart';
import 'package:mppo_app/etc/colors/gradients/background.dart';
import 'package:mppo_app/features/drawer.dart';
import 'package:mppo_app/features/stats/add_list_dialog.dart';
import 'package:mppo_app/repositories/database/database_service.dart';
import 'package:mppo_app/repositories/database/get_values.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  String? qrValue;
  Map<String, dynamic>? qrData;
  User? user;
  final database = DatabaseService();
  GetValues? dbGetter;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    database.getUsers().listen((snapshot) {
      List<dynamic> users = snapshot.docs;
      dbGetter = GetValues(user: user!, users: users);
      setState(() {});
    });
  }

  void updateDb({bool add = false, required data}) async {
    while (dbGetter?.getUser() == null) {
      await Future.delayed(const Duration(milliseconds: 100));
    }

    var buyingList = dbGetter!.getUser()!.buyingList;
    if (add) {
      buyingList.add(data);
    } else {
      buyingList.remove(data);
    }
    await database.updateUser(dbGetter!.getUser()!.copyWith(buyingList: buyingList));
    setState(() {});
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      drawer: const AppDrawer(chosen: 3),
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: AppBar(
            toolbarHeight: 75,
            leadingWidth: 60,
            automaticallyImplyLeading: true,
            centerTitle: true,
            elevation: 5,
            shadowColor: Colors.black,
            backgroundColor: Color(CustomColors.shadowLight),
            flexibleSpace: Container(
              decoration: BoxDecoration(
                  gradient: BackgroundGrad(),
                  borderRadius:
                      const BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30))),
            ),
            leading: IconButton(
                onPressed: () {
                  _scaffoldKey.currentState!.openDrawer();
                },
                icon: const Icon(Icons.menu, color: Colors.white, size: 35)),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30))),
            title: const Text('Список покупок',
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Nunito',
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1)),
          )),
      body: dbGetter?.getUser() != null
          ? ListView(
              children: [
                const SizedBox(height: 20),
                ListView.builder(
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20, left: 15, right: 15),
                      child: Container(
                        padding: const EdgeInsets.only(left: 15, right: 15, top: 3, bottom: 3),
                        height: 85,
                        width: 340,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: const Color(0xfff8f8f8),
                            boxShadow: const [BoxShadow(color: Colors.black26, offset: Offset(0, 4), blurRadius: 3)]),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 250,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Text(
                                      jsonDecode(dbGetter!.getUser()!.buyingList[index])['name'],
                                      style: const TextStyle(
                                          color: Color(0xFF32E474),
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          height: 1.2),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    padding: const EdgeInsets.only(bottom: 5),
                                    height: 40,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: Text(
                                        jsonDecode(dbGetter!.getUser()!.buyingList[index])['other'],
                                        style: const TextStyle(
                                            color: Color(0xFF38CACF),
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            height: 1.1),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () {
                                updateDb(add: false, data: dbGetter!.getUser()!.buyingList[index]);
                              },
                              child: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: const [
                                      BoxShadow(color: Colors.black26, offset: Offset(0, 4), blurRadius: 3)
                                    ],
                                    borderRadius: BorderRadius.circular(15)),
                                child: Icon(
                                  Icons.delete,
                                  color: Color(CustomColors.delete),
                                  size: 30,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: dbGetter!.getUser()!.buyingList.length,
                )
              ],
            )
          : const Center(child: CircularProgressIndicator()),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(context: context, builder: (context) => ListDialog(updater: updateDb));
        },
        focusColor: Color(CustomColors.main),
        backgroundColor: Color(CustomColors.main),
        child: const Icon(Icons.add, color: Colors.white, size: 40),
      ),
    );
  }
}
