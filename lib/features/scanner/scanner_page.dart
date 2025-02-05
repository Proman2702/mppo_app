import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mppo_app/etc/colors/colors.dart';
import 'package:mppo_app/etc/colors/gradients/background.dart';
import 'package:mppo_app/features/drawer.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

const requiredKeys = {
  'productType',
  'productName',
  'createdTime',
  'expiredTime',
  'weight',
  'weightOption',
  'calories',
  'numOption'
};

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String? qrValue;

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
  void didChangeDependencies() {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null) {
      qrValue = args as String;
      try {
        final Map<String, dynamic> data = json.decode(qrValue!);

        // Список обязательных ключей
        const requiredKeys = {
          'productType',
          'productName',
          'createdTime',
          'expiredTime',
          'weight',
          'weightOption',
          'calories',
          'numOption'
        };

        // Проверяем, что все ключи присутствуют
        bool isParsed = requiredKeys.every(data.containsKey);
        if (!isParsed) {
          throw Exception("не прошел парсинг");
        }
      } catch (e) {
        qrValue = null; // Если ошибка при парсинге, значит JSON невалиден
      }
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      drawer: AppDrawer(chosen: 1),
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
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30))),
            ),
            leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.arrow_back, color: Colors.white, size: 35)),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30))),
            title: const Text('Сканировать QR',
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Nunito',
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1)),
          )),
      body: SingleChildScrollView(
        child: qrValue != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [Text(qrValue!, textAlign: TextAlign.center)],
              )
            : Center(
                child: Column(
                  children: [
                    SizedBox(height: 100),
                    Container(
                      width: 270,
                      height: 150,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [BoxShadow(color: Colors.black26, offset: Offset(0, 3), blurRadius: 5)]),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.highlight_remove, size: 100, color: Color(CustomColors.delete)),
                          Text('Ошибка!',
                              style: TextStyle(
                                  color: Color(CustomColors.delete), fontSize: 22, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                        width: 250,
                        child: Text(
                          'QR-код содержит данные, не предназначенные для использования приложением',
                          textAlign: TextAlign.center,
                          style:
                              TextStyle(fontSize: 16, color: Color(CustomColors.delete), fontWeight: FontWeight.w500),
                        ))
                  ],
                ),
              ),
      ),
    );
  }
}
