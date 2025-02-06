import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;

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
  'numOption',
  'allergy'
};

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String? qrValue;
  Map<String, dynamic>? qrData;

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
        qrData = json.decode(qrValue!);

        // Проверяем, что все ключи присутствуют
        bool isParsed = requiredKeys.every(qrData!.containsKey);
        if (!isParsed) {
          throw Exception("не прошел парсинг");
        }
      } catch (e) {
        qrData = null; // Если ошибка при парсинге, значит JSON невалиден
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
                children: [
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 150,
                        height: 70,
                        padding: EdgeInsets.only(left: 15),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          boxShadow: const [BoxShadow(color: Colors.black26, offset: Offset(0, 3), blurRadius: 5)],
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                        ),
                        child: Text(
                          'Тип продукта',
                          style: TextStyle(
                              fontSize: 20, color: Color(CustomColors.main), fontWeight: FontWeight.bold, height: 1.2),
                        ),
                      ),
                      SizedBox(width: 20),
                      Container(
                        width: 150,
                        height: 70,
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                            border: Border(bottom: BorderSide(width: 2, color: Color(CustomColors.bright)))),
                        child: Text(
                          //'${qrData!['productType']}',
                          '12345678 12345678',
                          style:
                              TextStyle(color: Color(CustomColors.bright), fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 150,
                        height: 40,
                        padding: EdgeInsets.only(left: 15),
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                          boxShadow: const [BoxShadow(color: Colors.black26, offset: Offset(0, 3), blurRadius: 5)],
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                        ),
                        child: Text(
                          'Название',
                          style: TextStyle(
                              fontSize: 20, color: Color(CustomColors.main), fontWeight: FontWeight.bold, height: 1.2),
                        ),
                      ),
                      SizedBox(width: 20),
                      Container(
                        width: 150,
                        height: 40,
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                            border: Border(bottom: BorderSide(width: 2, color: Color(CustomColors.bright)))),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(
                            //'${qrData!['productType']}',
                            '12345678901234567',
                            style:
                                TextStyle(color: Color(CustomColors.bright), fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          width: 150,
                          height: 80,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              boxShadow: const [BoxShadow(color: Colors.black26, offset: Offset(0, 3), blurRadius: 5)],
                              borderRadius: BorderRadius.circular(20),
                              gradient: BackgroundGrad()),
                          child: Text.rich(
                            TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Дата изг.\n',
                                    style: TextStyle(),
                                  ),
                                  TextSpan(
                                    text: '${qrData!['createdTime']}'.replaceAll('-', '.'),
                                    style: TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.w800),
                                  )
                                ],
                                style: const TextStyle(
                                    fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold, height: 1.2)),
                          )),
                      SizedBox(width: 20),
                      Container(
                          width: 150,
                          height: 80,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              boxShadow: const [BoxShadow(color: Colors.black26, offset: Offset(0, 3), blurRadius: 5)],
                              borderRadius: BorderRadius.circular(20),
                              gradient: BackgroundGrad()),
                          child: Text.rich(
                            TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Дата и/с\n',
                                    style: TextStyle(),
                                  ),
                                  TextSpan(
                                    text: '${qrData!['expiredTime']}'.replaceAll('-', '.'),
                                    style: TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.w800),
                                  )
                                ],
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold, height: 1.2)),
                          )),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 150,
                        height: 40,
                        padding: EdgeInsets.only(left: 15),
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                          boxShadow: const [BoxShadow(color: Colors.black26, offset: Offset(0, 3), blurRadius: 5)],
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                        ),
                        child: Text(
                          'Вес (${qrData!['weightOption'] == 1 ? 'кг' : 'мл'})',
                          style: TextStyle(
                              fontSize: 20, color: Color(CustomColors.main), fontWeight: FontWeight.bold, height: 1.2),
                        ),
                      ),
                      SizedBox(width: 20),
                      Container(
                        width: 150,
                        height: 40,
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                            border: Border(bottom: BorderSide(width: 2, color: Color(CustomColors.bright)))),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(
                            //'${qrData!['productType']}',
                            '${qrData!['weight']} ${qrData!['weightOption'] == 1 ? 'кг' : 'мл'}',
                            style:
                                TextStyle(color: Color(CustomColors.bright), fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 150,
                        height: 40,
                        padding: EdgeInsets.only(left: 15),
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                          boxShadow: const [BoxShadow(color: Colors.black26, offset: Offset(0, 3), blurRadius: 5)],
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                        ),
                        child: Text(
                          'Энерг. ц.',
                          style: TextStyle(
                              fontSize: 20, color: Color(CustomColors.main), fontWeight: FontWeight.bold, height: 1.2),
                        ),
                      ),
                      SizedBox(width: 20),
                      Container(
                        width: 150,
                        height: 40,
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                            border: Border(bottom: BorderSide(width: 2, color: Color(CustomColors.bright)))),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(
                            //'${qrData!['productType']}',
                            '${qrData!['calories']} ккал',
                            style:
                                TextStyle(color: Color(CustomColors.bright), fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 150,
                        height: 80,
                        alignment: Alignment.topLeft,
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          boxShadow: const [BoxShadow(color: Colors.black26, offset: Offset(0, 3), blurRadius: 5)],
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                        ),
                        child: Text(
                          'Аллергены',
                          style: TextStyle(
                              fontSize: 19, color: Color(CustomColors.main), fontWeight: FontWeight.bold, height: 1.2),
                        ),
                      ),
                      SizedBox(width: 20),
                      Container(
                        width: 150,
                        height: 80,
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                            border: Border(bottom: BorderSide(width: 2, color: Color(CustomColors.bright)))),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Text(
                            //'${qrData!['productType']}',
                            '${qrData!['allergy'].keys.where((key) => qrData!['allergy'][key] == true).toList().join(' ')}',
                            style:
                                TextStyle(color: Color(CustomColors.bright), fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    ],
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
                              opacity: const AlwaysStoppedAnimation(0.1),
                              alignment: Alignment.center,
                              color: Color(CustomColors.main),
                            ),
                          )),
                      Padding(
                          padding: EdgeInsets.only(right: 0, bottom: 0),
                          child: Transform.rotate(
                            angle: 2 * math.pi,
                            child: Image.asset(
                              "assets/images/hexagon_grad.png",
                              scale: 1.9,
                              opacity: const AlwaysStoppedAnimation(0.1),
                              alignment: Alignment.center,
                              color: Color(CustomColors.main),
                            ),
                          )),
                    ],
                  )
                ],
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
                    const SizedBox(height: 20),
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
