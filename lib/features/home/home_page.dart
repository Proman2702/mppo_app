import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mppo_app/etc/colors/colors.dart';
import 'package:mppo_app/etc/colors/gradients/background.dart';
import 'package:mppo_app/features/drawer.dart';
import 'package:mppo_app/constants.dart' as consts;
import 'package:mppo_app/features/home/tile_builder.dart';
import 'package:mppo_app/repositories/auth/auth_service.dart';
import 'package:mppo_app/repositories/database/database_service.dart';
import 'package:mppo_app/repositories/database/get_values.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController _controller = TextEditingController();

  AuthService auth = AuthService();
  User? user;
  DatabaseService database = DatabaseService();
  GetValues? dbGetter;
  List? tileItems;
  List? filteredItems;

  @override
  void initState() {
    user = FirebaseAuth.instance.currentUser;
    database.getUsers().listen((snapshot) {
      List<dynamic> users = snapshot.docs;
      dbGetter = GetValues(user: user!, users: users);
      setState(() {});
    });
    checkValuePeriodically();
    super.initState();
  }

  List<List<dynamic>> transformList(List<dynamic> input) {
    var frequencyMap = <dynamic, int>{};
    List<List<dynamic>> result = [];

    for (var element in input) {
      if (jsonDecode(element)['numOption'] == 1) {
        result.add([element, 1]);
      } else {
        frequencyMap[element] = (frequencyMap[element] ?? 0) + 1;
      }
    }
    result.addAll(frequencyMap.entries.map((e) => [e.key, e.value]));
    return result;
  }

  void checkValuePeriodically({bool? delete, List? tile}) async {
    while (dbGetter?.getUser() == null) {
      await Future.delayed(const Duration(milliseconds: 100));
    }

    if (delete != null) {
      var tileItems = dbGetter!.getUser()!.items;
      var c = 0;
      tileItems.removeWhere((item) {
        if (item == tile![0] && c < tile[1]) {
          c++;
          return true;
        }
        return false;
      });
      await database.updateUser(dbGetter!.getUser()!.copyWith(items: tileItems));
      setState(() {});
    }

    tileItems = transformList(dbGetter!.getUser()!.items);
    setState(() {});
  }

  void filterSearch(String value) {
    if (value.startsWith('/')) {
      filteredItems = tileItems!
          .where(
            (item) => jsonDecode(item[0])['productType']
                .toLowerCase()
                .contains(value.split('/').last.trimLeft().toLowerCase()),
          )
          .toList();
    } else {
      filteredItems = tileItems!
          .where(
            (item) => jsonDecode(item[0])['productName'].toLowerCase().contains(value.toLowerCase()),
          )
          .toList();
    }

    if (value == '') {
      filteredItems = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      drawer: const AppDrawer(chosen: 0),
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: AppBar(
            toolbarHeight: 75,
            leadingWidth: 60,
            centerTitle: true,
            automaticallyImplyLeading: true,
            backgroundColor: Colors.white,
            elevation: 5,
            shadowColor: Colors.black,
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
            title: const Padding(
              padding: EdgeInsets.only(left: 0.0),
              child: Text('SmartFridge',
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Nunito',
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1)),
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/home/settings', arguments: user);
                  },
                  icon: const Icon(Icons.settings, color: Colors.white, size: 35)),
              const SizedBox(width: 10),
            ],
          )),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Container(
                height: 40,
                width: 340,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color.fromARGB(16, 0, 0, 0),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 8),
                    Icon(Icons.search, size: 24, color: Color(CustomColors.bright)),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 244,
                      height: 40,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints.expand(width: 400), // 18 - fontSize
                          child: TextField(
                            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: Colors.black87),
                            maxLength: 30,
                            controller: _controller,
                            onChanged: (value) {
                              filterSearch(value);
                              setState(() {});
                            },
                            decoration: const InputDecoration(
                              floatingLabelBehavior: FloatingLabelBehavior.never,
                              contentPadding: EdgeInsets.only(bottom: 14),
                              counterText: "",
                              border: InputBorder.none,
                              labelText: "Поиск (/ по типу)",
                              labelStyle: TextStyle(color: Colors.black12, fontSize: 20, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    PopupMenuButton<String>(
                      icon: Icon(
                        Icons.arrow_drop_down,
                        size: 24,
                        color: Color(CustomColors.bright),
                      ),
                      onSelected: (String value) {
                        _controller.text = '/$value';
                        filterSearch('/$value');
                        setState(() {});
                      },
                      itemBuilder: (BuildContext context) {
                        return consts.defaultTypes.map<PopupMenuItem<String>>((String value) {
                          return PopupMenuItem<String>(
                            padding: const EdgeInsets.all(8),
                            height: 5,
                            value: value,
                            child: Text(value),
                          );
                        }).toList();
                      },
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),
              tileItems != null
                  ? SingleChildScrollView(
                      child: SizedBox(
                        width: MediaQuery.sizeOf(context).width,
                        height: MediaQuery.sizeOf(context).height - 175,
                        child: ListView(
                          children: [
                            ListView.builder(
                                physics: const ScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: filteredItems?.length ?? tileItems!.length,
                                itemBuilder: (context, index) {
                                  final tile = filteredItems?[index] ?? tileItems![index];
                                  return TileBuilder(
                                    index: index,
                                    tile: tile,
                                    updater: checkValuePeriodically,
                                  );
                                }),
                          ],
                        ),
                      ),
                    )
                  : const CircularProgressIndicator()
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
        child: const Icon(Icons.qr_code_2_outlined, color: Colors.white, size: 40),
      ),
    );
  }
}
