import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mppo_app/etc/colors/colors.dart';
import 'package:mppo_app/etc/colors/gradients/background.dart';
import 'package:mppo_app/features/drawer.dart';
import 'package:mppo_app/features/stats/add_list_dialog.dart';
import 'package:mppo_app/repositories/auth/auth_service.dart';
import 'package:mppo_app/repositories/database/database_service.dart';
import 'package:mppo_app/repositories/database/get_values.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  AuthService auth = AuthService();
  User? user;
  DatabaseService database = DatabaseService();
  GetValues? dbGetter;

  @override
  void initState() {
    user = FirebaseAuth.instance.currentUser;
    database.getUsers().listen((snapshot) {
      List<dynamic> users = snapshot.docs;
      dbGetter = GetValues(user: user!, users: users);
      setState(() {});
    });
    super.initState();
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
                ListView.builder(
                  itemBuilder: (context, index) {
                    return Text("");
                  },
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: 0,
                )
              ],
            )
          : Center(child: CircularProgressIndicator()),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(context: context, builder: (context) => ListDialog());
        },
        focusColor: Color(CustomColors.main),
        backgroundColor: Color(CustomColors.main),
        child: const Icon(Icons.add, color: Colors.white, size: 40),
      ),
    );
  }
}
