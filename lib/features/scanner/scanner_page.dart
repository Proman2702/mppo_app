import 'dart:convert';
import 'dart:math' as math;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mppo_app/etc/colors/colors.dart';
import 'package:mppo_app/etc/colors/gradients/background.dart';
import 'package:mppo_app/etc/models/user.dart';
import 'package:mppo_app/features/drawer.dart';
import 'package:mppo_app/features/qr_info_handler.dart';
import 'package:mppo_app/repositories/database/database_service.dart';
import 'package:mppo_app/repositories/database/get_values.dart';

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
    });
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
        drawer: const AppDrawer(chosen: 1),
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
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      Navigator.of(context).pushReplacementNamed('/');
                    });
                  },
                  icon: const Icon(Icons.arrow_back, color: Colors.white, size: 35)),
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
            child: qrData != null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 160,
                            height: 70,
                            padding: const EdgeInsets.only(left: 15, right: 15),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              boxShadow: const [BoxShadow(color: Colors.black26, offset: Offset(0, 3), blurRadius: 5)],
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                            ),
                            child: Text(
                              'Тип продукта',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Color(CustomColors.main),
                                  fontWeight: FontWeight.bold,
                                  height: 1.2),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Container(
                            width: 160,
                            height: 70,
                            alignment: Alignment.centerLeft,
                            decoration: const BoxDecoration(
                                border: Border(bottom: BorderSide(width: 2, color: Colors.black12))),
                            child: Text(
                              '${qrData!['productType']}',
                              style: TextStyle(
                                  color: Color(CustomColors.bright), fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 160,
                            height: 40,
                            padding: const EdgeInsets.only(left: 15),
                            alignment: Alignment.centerLeft,
                            decoration: BoxDecoration(
                              boxShadow: const [BoxShadow(color: Colors.black26, offset: Offset(0, 3), blurRadius: 5)],
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                            ),
                            child: Text(
                              'Название',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Color(CustomColors.main),
                                  fontWeight: FontWeight.bold,
                                  height: 1.2),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Container(
                            width: 160,
                            height: 40,
                            alignment: Alignment.centerLeft,
                            decoration: const BoxDecoration(
                                border: Border(bottom: BorderSide(width: 2, color: Colors.black12))),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Text(
                                '${qrData!['productName']}',
                                style: TextStyle(
                                    color: Color(CustomColors.bright), fontSize: 20, fontWeight: FontWeight.bold),
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
                              width: 160,
                              height: 80,
                              padding: const EdgeInsets.only(left: 15, right: 15),
                              alignment: Alignment.centerLeft,
                              decoration: BoxDecoration(boxShadow: const [
                                BoxShadow(color: Colors.black26, offset: Offset(0, 3), blurRadius: 5)
                              ], borderRadius: BorderRadius.circular(20), gradient: BackgroundGrad()),
                              child: Text.rich(
                                TextSpan(
                                    children: [
                                      const TextSpan(text: 'Дата изг.\n', style: TextStyle()),
                                      TextSpan(
                                        text: '${qrData!['createdTime']}'.replaceAll('-', '.'),
                                        style: const TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.w800),
                                      )
                                    ],
                                    style: const TextStyle(
                                        fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold, height: 1.2)),
                              )),
                          const SizedBox(width: 20),
                          Container(
                              width: 160,
                              height: 80,
                              padding: const EdgeInsets.only(left: 15, right: 15),
                              alignment: Alignment.centerLeft,
                              decoration: BoxDecoration(boxShadow: const [
                                BoxShadow(color: Colors.black26, offset: Offset(0, 3), blurRadius: 5)
                              ], borderRadius: BorderRadius.circular(20), gradient: BackgroundGrad()),
                              child: Text.rich(
                                TextSpan(
                                    children: [
                                      const TextSpan(text: 'Дата и/с\n', style: TextStyle()),
                                      TextSpan(
                                        text: '${qrData!['expiredTime']}'.replaceAll('-', '.'),
                                        style: const TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.w800),
                                      )
                                    ],
                                    style: const TextStyle(
                                        fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold, height: 1.2)),
                              )),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 160,
                            height: 40,
                            padding: const EdgeInsets.only(left: 15),
                            alignment: Alignment.centerLeft,
                            decoration: BoxDecoration(
                              boxShadow: const [BoxShadow(color: Colors.black26, offset: Offset(0, 3), blurRadius: 5)],
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                            ),
                            child: Text(
                              'Вес (${qrData!['weightOption'] == 1 ? 'кг' : 'мл'})',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Color(CustomColors.main),
                                  fontWeight: FontWeight.bold,
                                  height: 1.2),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Container(
                            width: 160,
                            height: 40,
                            alignment: Alignment.centerLeft,
                            decoration: const BoxDecoration(
                                border: Border(bottom: BorderSide(width: 2, color: Colors.black12))),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Text(
                                //'${qrData!['productType']}',
                                '${qrData!['weight']} ${qrData!['weightOption'] == 1 ? 'кг' : 'мл'}',
                                style: TextStyle(
                                    color: Color(CustomColors.bright), fontSize: 20, fontWeight: FontWeight.bold),
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
                            width: 160,
                            height: 40,
                            padding: const EdgeInsets.only(left: 15),
                            alignment: Alignment.centerLeft,
                            decoration: BoxDecoration(
                              boxShadow: const [BoxShadow(color: Colors.black26, offset: Offset(0, 3), blurRadius: 5)],
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                            ),
                            child: Text(
                              'Энерг. ц.',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Color(CustomColors.main),
                                  fontWeight: FontWeight.bold,
                                  height: 1.2),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Container(
                            width: 160,
                            height: 40,
                            alignment: Alignment.centerLeft,
                            decoration: const BoxDecoration(
                                border: Border(bottom: BorderSide(width: 2, color: Colors.black12))),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Text(
                                //'${qrData!['productType']}',
                                '${qrData!['calories']} ккал',
                                style: TextStyle(
                                    color: Color(CustomColors.bright), fontSize: 20, fontWeight: FontWeight.bold),
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
                            width: 160,
                            height: 40,
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(left: 15),
                            decoration: BoxDecoration(
                              boxShadow: const [BoxShadow(color: Colors.black26, offset: Offset(0, 3), blurRadius: 5)],
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                            ),
                            child: Text(
                              'Аллергены',
                              style: TextStyle(
                                  fontSize: 19,
                                  color: Color(CustomColors.main),
                                  fontWeight: FontWeight.bold,
                                  height: 1.2),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Container(
                            width: 160,
                            height: 40,
                            alignment: Alignment.centerLeft,
                            decoration: const BoxDecoration(
                                border: Border(bottom: BorderSide(width: 2, color: Colors.black12))),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Text(
                                //'${qrData!['productType']}',
                                '${!qrData!['allergy'].values.every((value) => !value as bool) ? qrData!['allergy'].keys.where((key) => qrData!['allergy'][key] == true).toList().join(', ') : 'Нет'}'
                                    .replaceAll('lactose', 'лактоза')
                                    .replaceAll('gluten', 'глютен')
                                    .replaceAll('other', 'прочее'),
                                style: TextStyle(
                                    color: Color(CustomColors.bright), fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: MediaQuery.sizeOf(context).height / 4.5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 160,
                            height: 40,
                            decoration: BoxDecoration(
                                color: Color(CustomColors.delete),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: const [
                                  BoxShadow(color: Colors.black26, offset: Offset(0, 3), blurRadius: 5)
                                ]),
                            child: ElevatedButton(
                                onPressed: () async {
                                  if (dbGetter?.getUser()?.username != null) {
                                    CustomUser curUser = dbGetter!.getUser()!;
                                    var curItems = curUser.items;
                                    var curHistory = curUser.history;

                                    var firstInd = curItems.indexOf(jsonEncode(qrData));

                                    if (firstInd != -1) {
                                      curItems.removeAt(firstInd);

                                      curHistory.add(jsonEncode(
                                        {
                                          "productType": qrData!['productType'],
                                          'date':
                                              '${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}',
                                          'type': 'deleted'
                                        },
                                      ));

                                      if (curHistory.length > 1000) {
                                        curHistory.length = 1000;
                                      }
                                      await database.updateUser(curUser.copyWith(items: curItems, history: curHistory));

                                      Navigator.of(context).pushReplacementNamed('/');
                                      showModalBottomSheet(
                                          context: context, builder: (context) => InfoSheet(type: 'remove'));
                                    } else {
                                      showModalBottomSheet(
                                          context: context, builder: (context) => InfoSheet(type: 'none'));
                                    }
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent, shadowColor: Colors.transparent),
                                child: const Text(
                                  'Удалить',
                                  style: TextStyle(color: Colors.white, fontSize: 20),
                                )),
                          ),
                          const SizedBox(width: 20),
                          Container(
                            width: 160,
                            height: 40,
                            decoration: BoxDecoration(
                                color: Color(CustomColors.bright),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: const [
                                  BoxShadow(color: Colors.black26, offset: Offset(0, 3), blurRadius: 5)
                                ]),
                            child: ElevatedButton(
                                onPressed: () async {
                                  if (dbGetter?.getUser()?.username != null) {
                                    CustomUser curUser = dbGetter!.getUser()!;
                                    var curItems = curUser.items;
                                    curItems.add(jsonEncode(qrData));
                                    var curHistory = curUser.history;

                                    curHistory.add(jsonEncode(
                                      {
                                        "productType": qrData!['productType'],
                                        'date': '${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}',
                                        'type': 'added'
                                      },
                                    ));

                                    if (curHistory.length > 1000) {
                                      curHistory.length = 1000;
                                    }
                                    await database.updateUser(curUser.copyWith(items: curItems, history: curHistory));
                                  }
                                  Navigator.of(context).pushReplacementNamed('/');
                                  showModalBottomSheet(context: context, builder: (context) => InfoSheet(type: 'add'));
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent, shadowColor: Colors.transparent),
                                child: const Text(
                                  'Добавить',
                                  style: TextStyle(color: Colors.white, fontSize: 20),
                                )),
                          )
                        ],
                      ),
                    ],
                  )
                : const NullBody()));
  }
}

class NullBody extends StatelessWidget {
  const NullBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 100),
          Container(
            width: 270,
            height: 150,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [const BoxShadow(color: Colors.black26, offset: Offset(0, 3), blurRadius: 5)]),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.highlight_remove, size: 100, color: Color(CustomColors.delete)),
                Text('Ошибка!',
                    style: TextStyle(color: Color(CustomColors.delete), fontSize: 22, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
              width: 250,
              child: Text(
                'QR-код содержит данные, не предназначенные для использования приложением',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Color(CustomColors.delete), fontWeight: FontWeight.w500),
              ))
        ],
      ),
    );
  }
}
