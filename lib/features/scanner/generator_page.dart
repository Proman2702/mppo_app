import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui';

import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:mppo_app/etc/colors/colors.dart';
import 'package:mppo_app/etc/colors/gradients/background.dart';
import 'package:mppo_app/etc/colors/gradients/tiles.dart';
import 'package:mppo_app/features/drawer.dart';
import 'package:mppo_app/features/scanner/generator_error_hander.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class GeneratorPage extends StatefulWidget {
  const GeneratorPage({super.key});

  @override
  State<GeneratorPage> createState() => _GeneratorPageState();
}

class _GeneratorPageState extends State<GeneratorPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final GlobalKey _qrkey = GlobalKey();
  String? _path;

  Map<String, dynamic> qrMap = {
    'productType': null,
    'productName': null,
    'createdTime': null,
    'expiredTime': null,
    'weight': null,
    'weightOption': null,
    'calories': null,
    'numOption': null
  };

  String? qrValue;
  int? weightOption; // 1 - кг, 2 - мл
  int? numOption; // 1 - вес, 2 - штуки
  String? productType;
  String? productName;
  String? createdTime;
  String? expiredTime;
  String? weight;
  String? calories;

  Future<void> _captureAndSavePng() async {
    try {
      RenderRepaintBoundary boundary = _qrkey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      var image = await boundary.toImage(pixelRatio: 3.0);

      //Drawing White Background because Qr Code is Black
      final whitePaint = Paint()..color = Colors.white;
      final recorder = PictureRecorder();
      final canvas = Canvas(recorder, Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()));
      canvas.drawRect(Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()), whitePaint);
      canvas.drawImage(image, Offset.zero, Paint());
      final picture = recorder.endRecording();
      final img = await picture.toImage(image.width, image.height);
      ByteData? byteData = await img.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      //Check for duplicate file name to avoid Override
      String fileName = 'qr_code';
      int i = 1;
      while (await File('$_path/$fileName.png').exists()) {
        fileName = 'qr_code_$i';
        i++;
      }

      // Check if Directory Path exists or not

      final file = await File('$_path/$fileName.png').create();
      await file.writeAsBytes(pngBytes);

      if (!mounted) return;
      final snackBar = SnackBar(
        content: Text('QR код сохранен в галерею', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Color(CustomColors.main),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } catch (e) {
      if (!mounted) return;
      log(e.toString());
      final snackBar = SnackBar(
        content: Text('Что-то пошло не так', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Color(CustomColors.main),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  void initState() {
    weightOption = 1;
    numOption = 1;
    getPublicDirectoryPath();
    //database.getUsers().listen((snapshot) {
    //List<dynamic> users = snapshot.docs;
    //dbGetter = GetValues(user: user!, users: users);
    //setState(() {});
    //});
    super.initState();
  }

  Future<void> getPublicDirectoryPath() async {
    String path;

    path = await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOADS);
    log('привет');

    setState(() {
      _path = path;
      // /storage/emulated/0/Download
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      drawer: AppDrawer(chosen: 4),
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
            title: const Text('Генератор QR',
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Nunito',
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1)),
          )),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Center(
                child: RepaintBoundary(
                  key: _qrkey,
                  child: qrValue == null
                      ? Container(
                          width: 300,
                          height: 300,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black26, width: 2),
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white),
                        )
                      : QrImageView(
                          data: qrValue!,
                          version: QrVersions.auto,
                          size: 300.0,
                          gapless: true,
                          errorStateBuilder: (ctx, err) {
                            return const Center(
                              child: Text(
                                'Something went wrong!!!',
                                textAlign: TextAlign.center,
                              ),
                            );
                          },
                        ),
                ),
              ),
              const SizedBox(height: 20),
              Container(width: 340, height: 1, color: Color(CustomColors.main)),
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 45,
                    width: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Color(CustomColors.main), width: 5),
                      color: Colors.white,
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 10),
                        SizedBox(
                          width: 270,
                          height: 45,
                          child: TextField(
                            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: Colors.black87),
                            maxLength: 30,
                            inputFormatters: [
                              TextInputFormatter.withFunction(
                                (oldValue, newValue) {
                                  String text = newValue.text.replaceAll(RegExp(r' '), '');
                                  return TextEditingValue(text: text);
                                },
                              )
                            ],
                            onChanged: (value) => setState(() {
                              productType = value;
                            }),
                            decoration: const InputDecoration(
                              floatingLabelBehavior: FloatingLabelBehavior.never,
                              contentPadding: EdgeInsets.only(bottom: 10),
                              counterText: "",
                              border: InputBorder.none,
                              labelText: "...",
                              labelStyle: TextStyle(color: Colors.black12, fontSize: 20, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Text('Тип продукта', style: TextStyle(color: Color(CustomColors.bright), fontSize: 12)),
                  )
                ],
              ),
              const SizedBox(height: 5),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 45,
                    width: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Color(CustomColors.main), width: 5),
                      color: Colors.white,
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 10),
                        SizedBox(
                          width: 240,
                          height: 45,
                          child: TextField(
                            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: Colors.black87),
                            maxLength: 30,
                            inputFormatters: [
                              TextInputFormatter.withFunction(
                                (oldValue, newValue) {
                                  String text = newValue.text.replaceAll(RegExp(r' '), '');
                                  return TextEditingValue(text: text);
                                },
                              )
                            ],
                            onChanged: (value) => setState(() {
                              productName = value;
                            }),
                            decoration: const InputDecoration(
                              floatingLabelBehavior: FloatingLabelBehavior.never,
                              contentPadding: EdgeInsets.only(bottom: 10),
                              counterText: "",
                              border: InputBorder.none,
                              labelText: "...",
                              labelStyle: TextStyle(color: Colors.black12, fontSize: 20, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Text('Название продукта', style: TextStyle(color: Color(CustomColors.bright), fontSize: 12)),
                  )
                ],
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Container(
                        height: 45,
                        width: 145,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Color(CustomColors.main), width: 5),
                          color: Colors.white,
                        ),
                        child: Row(
                          // ДОДЕЛАТЬ АВТОЗАПОЛНЕНИЕ ТОЧКАМИ
                          children: [
                            SizedBox(width: 10),
                            SizedBox(
                              width: 125,
                              height: 45,
                              child: TextField(
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18,
                                    color: Colors.black87,
                                    letterSpacing: -0.5),
                                maxLength: 10,
                                inputFormatters: [
                                  TextInputFormatter.withFunction((oldValue, newValue) {
                                    String text =
                                        newValue.text.replaceAll(RegExp(r'[^0-9]'), ''); // Убираем всё, кроме цифр
                                    // Ограничиваем длину

                                    // Добавляем "-" в нужные позиции
                                    if (text.length > 4) {
                                      text = '${text.substring(0, 2)}-${text.substring(2, 4)}-${text.substring(4)}';
                                    } else if (text.length > 2) {
                                      text = '${text.substring(0, 2)}-${text.substring(2)}';
                                    }

                                    return TextEditingValue(text: text);
                                  }),
                                ],
                                onChanged: (value) => setState(() {
                                  createdTime = value;
                                }),
                                decoration: const InputDecoration(
                                  floatingLabelBehavior: FloatingLabelBehavior.never,
                                  contentPadding: EdgeInsets.only(bottom: 11),
                                  counterText: "",
                                  border: InputBorder.none,
                                  labelText: "ДД-ММ-ГГГГ",
                                  labelStyle:
                                      TextStyle(color: Colors.black12, fontSize: 18, fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text('Дата изготовления', style: TextStyle(color: Color(CustomColors.bright), fontSize: 12))
                    ],
                  ),
                  const SizedBox(width: 10),
                  Column(
                    children: [
                      Container(
                        height: 45,
                        width: 145,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Color(CustomColors.main), width: 5),
                          color: Colors.white,
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 8),
                            SizedBox(
                              width: 125,
                              height: 45,
                              child: TextField(
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18,
                                    color: Colors.black87,
                                    letterSpacing: -0.5),
                                maxLength: 10,
                                inputFormatters: [
                                  TextInputFormatter.withFunction((oldValue, newValue) {
                                    String text =
                                        newValue.text.replaceAll(RegExp(r'[^0-9]'), ''); // Убираем всё, кроме цифр
                                    // Ограничиваем длину

                                    // Добавляем "-" в нужные позиции
                                    if (text.length > 4) {
                                      text = '${text.substring(0, 2)}-${text.substring(2, 4)}-${text.substring(4)}';
                                    } else if (text.length > 2) {
                                      text = '${text.substring(0, 2)}-${text.substring(2)}';
                                    }

                                    return TextEditingValue(text: text);
                                  }),
                                ],
                                onChanged: (value) => setState(() {
                                  expiredTime = value;
                                }),
                                decoration: const InputDecoration(
                                  floatingLabelBehavior: FloatingLabelBehavior.never,
                                  contentPadding: EdgeInsets.only(bottom: 11),
                                  counterText: "",
                                  border: InputBorder.none,
                                  labelText: "ДД-ММ-ГГГГ",
                                  labelStyle:
                                      TextStyle(color: Colors.black12, fontSize: 18, fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text('Дата истечения c/г', style: TextStyle(color: Color(CustomColors.bright), fontSize: 12))
                    ],
                  )
                ],
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 45,
                        width: 220,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Color(CustomColors.main), width: 5),
                          color: Colors.white,
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 10),
                            SizedBox(
                              width: 170,
                              height: 45,
                              child: TextField(
                                style:
                                    const TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: Colors.black87),
                                maxLength: 12,
                                inputFormatters: [
                                  TextInputFormatter.withFunction(
                                    (oldValue, newValue) {
                                      String text = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
                                      return TextEditingValue(text: text);
                                    },
                                  )
                                ],
                                onChanged: (value) => setState(() {
                                  weight = value;
                                }),
                                decoration: const InputDecoration(
                                  floatingLabelBehavior: FloatingLabelBehavior.never,
                                  contentPadding: EdgeInsets.only(bottom: 10),
                                  counterText: "",
                                  border: InputBorder.none,
                                  labelText: "В кг/мл",
                                  labelStyle:
                                      TextStyle(color: Colors.black12, fontSize: 20, fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Text('Масса/объем продукта',
                            style: TextStyle(color: Color(CustomColors.bright), fontSize: 12)),
                      )
                    ],
                  ),
                  SizedBox(width: 20),
                  SizedBox(
                    width: 60,
                    child: Row(
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: Radio<int>(
                                value: 1,
                                groupValue: weightOption,
                                onChanged: (int? value) {
                                  setState(() {
                                    weightOption = value;
                                    log("Selected Option: $weightOption");
                                  });
                                },
                              ),
                            ),
                            Text("кг", style: TextStyle(color: Color(CustomColors.bright)))
                          ],
                        ),
                        const SizedBox(width: 20),
                        Column(
                          children: [
                            SizedBox(
                              height: 20,
                              width: 20,
                              child: Radio<int>(
                                value: 2,
                                groupValue: weightOption,
                                onChanged: (int? value) {
                                  setState(() {
                                    weightOption = value;
                                    log("Selected Option: $weightOption");
                                  });
                                },
                              ),
                            ),
                            Text(
                              "мл",
                              style: TextStyle(color: Color(CustomColors.bright)),
                            )
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 5),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 45,
                    width: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Color(CustomColors.main), width: 5),
                      color: Colors.white,
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 10),
                        SizedBox(
                          width: 240,
                          height: 45,
                          child: TextField(
                            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: Colors.black87),
                            maxLength: 16,
                            inputFormatters: [
                              TextInputFormatter.withFunction(
                                (oldValue, newValue) {
                                  String text = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
                                  return TextEditingValue(text: text);
                                },
                              )
                            ],
                            onChanged: (value) => setState(() {
                              calories = value;
                            }),
                            decoration: const InputDecoration(
                              floatingLabelBehavior: FloatingLabelBehavior.never,
                              contentPadding: EdgeInsets.only(bottom: 10),
                              counterText: "",
                              border: InputBorder.none,
                              labelText: "В ккал",
                              labelStyle: TextStyle(color: Colors.black12, fontSize: 20, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Text('Энергетическая ценность',
                        style: TextStyle(color: Color(CustomColors.bright), fontSize: 12)),
                  )
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      padding: EdgeInsets.only(left: 10),
                      height: 45,
                      width: 200,
                      child: Text('Ед. измерения',
                          style:
                              TextStyle(color: Color(CustomColors.main), fontSize: 20, fontWeight: FontWeight.bold))),
                  const SizedBox(width: 30),
                  SizedBox(
                    width: 80,
                    child: Row(
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              width: 30,
                              height: 20,
                              child: Radio<int>(
                                value: 1,
                                groupValue: numOption,
                                onChanged: (int? value) {
                                  setState(() {
                                    numOption = value;
                                    log("Selected Option: $numOption");
                                  });
                                },
                              ),
                            ),
                            Text("вес", style: TextStyle(color: Color(CustomColors.bright)))
                          ],
                        ),
                        const SizedBox(width: 20),
                        Column(
                          children: [
                            SizedBox(
                              height: 20,
                              width: 30,
                              child: Radio<int>(
                                value: 2,
                                groupValue: numOption,
                                onChanged: (int? value) {
                                  setState(() {
                                    numOption = value;
                                    log("Selected Option: $numOption");
                                  });
                                },
                              ),
                            ),
                            Text("шт.", style: TextStyle(color: Color(CustomColors.bright)))
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10),
              Container(
                  height: 35,
                  width: 215,
                  decoration: BoxDecoration(
                      gradient: ButtonGrad(),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(spreadRadius: 1, offset: Offset(0, 2), blurRadius: 2, color: Colors.black26)
                      ]),
                  child: ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent),
                    onPressed: () {
                      String formatDate(String input) {
                        List<String> parts = input.split('-');
                        if (parts.length == 3) {
                          return '${parts[2]}-${parts[1]}-${parts[0]}';
                        }
                        return input;
                      }

                      if ([
                        productType,
                        productName,
                        createdTime,
                        expiredTime,
                        weight,
                        weightOption,
                        calories,
                        numOption
                      ].every((element) => element != null)) {
                        if (DateTime.parse(formatDate(createdTime!))
                            .isBefore(DateTime.parse(formatDate(expiredTime!)))) {
                          qrMap['productType'] = productType;
                          qrMap['productName'] = productName;
                          qrMap['createdTime'] = createdTime;
                          qrMap['expiredTime'] = expiredTime;
                          qrMap['weight'] = weight;
                          qrMap['weightOption'] = weightOption;
                          qrMap['calories'] = calories;
                          qrMap['numOption'] = numOption;

                          qrValue = "$qrMap";
                          setState(() {});

                          Future.delayed(const Duration(milliseconds: 200), () => _captureAndSavePng());
                        } else {
                          showModalBottomSheet(
                              context: context, builder: (BuildContext context) => GeneratorDenySheet(type: 'date'));
                        }
                      } else {
                        showModalBottomSheet(
                            context: context, builder: (BuildContext context) => GeneratorDenySheet(type: 'none'));
                      }
                    },
                    child: const Text(
                      "Сгенерировать",
                      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                  )),
              const SizedBox(height: 15)
            ],
          ),
        ),
      ),
    );
  }
}
