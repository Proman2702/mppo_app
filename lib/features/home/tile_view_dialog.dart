import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mppo_app/etc/colors/colors.dart';
import 'package:mppo_app/etc/colors/gradients/background.dart';
import 'package:mppo_app/features/home/delete_tile_dialog.dart';

class TileViewDialog extends StatelessWidget {
  final List tile;
  final Function updater;

  const TileViewDialog({super.key, required this.tile, required this.updater});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        contentPadding: EdgeInsets.all(20),
        titlePadding: EdgeInsets.only(left: 20, right: 20, top: 20),
        backgroundColor: Colors.white,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 40,
              width: 160,
              alignment: Alignment.center,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Color(CustomColors.main)),
              child: Text(
                'О товаре',
                style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Spacer(),
            GestureDetector(
              onTap: () {
                log('негрыааааа');
                showDialog(context: context, builder: (context) => DeleteTileDialog(tile: tile, updater: updater));
              },
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Color(CustomColors.main)),
                child: Icon(
                  Icons.delete_forever,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            )
          ],
        ),
        content: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 50,
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      boxShadow: const [BoxShadow(color: Colors.black26, offset: Offset(0, 3), blurRadius: 5)],
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                    ),
                    child: Text(
                      'Тип продукта',
                      style: TextStyle(
                          fontSize: 16, color: Color(CustomColors.main), fontWeight: FontWeight.bold, height: 1.2),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Container(
                    width: 120,
                    height: 50,
                    alignment: Alignment.centerLeft,
                    decoration:
                        const BoxDecoration(border: Border(bottom: BorderSide(width: 2, color: Colors.black12))),
                    child: SingleChildScrollView(
                      child: Text(
                        '${jsonDecode(tile[0])['productType']}',
                        style: TextStyle(color: Color(CustomColors.bright), fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 40,
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      boxShadow: const [BoxShadow(color: Colors.black26, offset: Offset(0, 3), blurRadius: 5)],
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                    ),
                    child: Text(
                      'Название',
                      style: TextStyle(
                          fontSize: 16, color: Color(CustomColors.main), fontWeight: FontWeight.bold, height: 1.2),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Container(
                    width: 120,
                    height: 40,
                    alignment: Alignment.centerLeft,
                    decoration:
                        const BoxDecoration(border: Border(bottom: BorderSide(width: 2, color: Colors.black12))),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        '${jsonDecode(tile[0])['productName']}',
                        style: TextStyle(color: Color(CustomColors.bright), fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      width: 120,
                      height: 60,
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                          boxShadow: const [BoxShadow(color: Colors.black26, offset: Offset(0, 3), blurRadius: 5)],
                          borderRadius: BorderRadius.circular(15),
                          gradient: BackgroundGrad()),
                      child: Text.rich(
                        TextSpan(
                            children: [
                              const TextSpan(text: 'Дата изг.\n', style: TextStyle()),
                              TextSpan(
                                text: '${jsonDecode(tile[0])['createdTime']}'.replaceAll('-', '.'),
                                style: const TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.w800),
                              )
                            ],
                            style: const TextStyle(
                                fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold, height: 1.2)),
                      )),
                  const SizedBox(width: 20),
                  Container(
                      width: 120,
                      height: 60,
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                          boxShadow: const [BoxShadow(color: Colors.black26, offset: Offset(0, 3), blurRadius: 5)],
                          borderRadius: BorderRadius.circular(15),
                          gradient: BackgroundGrad()),
                      child: Text.rich(
                        TextSpan(
                            children: [
                              const TextSpan(text: 'Дата и/с\n', style: TextStyle()),
                              TextSpan(
                                text: '${jsonDecode(tile[0])['expiredTime']}'.replaceAll('-', '.'),
                                style: const TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.w800),
                              )
                            ],
                            style: const TextStyle(
                                fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold, height: 1.2)),
                      )),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 40,
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      boxShadow: const [BoxShadow(color: Colors.black26, offset: Offset(0, 3), blurRadius: 5)],
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                    ),
                    child: Text(
                      'Вес (${jsonDecode(tile[0])['weightOption'] == 1 ? 'г' : 'мл'})',
                      style: TextStyle(
                          fontSize: 16, color: Color(CustomColors.main), fontWeight: FontWeight.bold, height: 1.2),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Container(
                    width: 120,
                    height: 40,
                    alignment: Alignment.centerLeft,
                    decoration:
                        const BoxDecoration(border: Border(bottom: BorderSide(width: 2, color: Colors.black12))),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        //'${qrData!['productType']}',
                        '${jsonDecode(tile[0])!['weight']} ${jsonDecode(tile[0])['weightOption'] == 1 ? 'г' : 'мл'}',
                        style: TextStyle(color: Color(CustomColors.bright), fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 40,
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      boxShadow: const [BoxShadow(color: Colors.black26, offset: Offset(0, 3), blurRadius: 5)],
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                    ),
                    child: Text(
                      'Энерг. ц.',
                      style: TextStyle(
                          fontSize: 16, color: Color(CustomColors.main), fontWeight: FontWeight.bold, height: 1.2),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Container(
                    width: 120,
                    height: 40,
                    alignment: Alignment.centerLeft,
                    decoration:
                        const BoxDecoration(border: Border(bottom: BorderSide(width: 2, color: Colors.black12))),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        //'${qrData!['productType']}',
                        '${jsonDecode(tile[0])['calories']} ккал',
                        style: TextStyle(color: Color(CustomColors.bright), fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 40,
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      boxShadow: const [BoxShadow(color: Colors.black26, offset: Offset(0, 3), blurRadius: 5)],
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                    ),
                    child: Text(
                      'Аллергены',
                      style: TextStyle(
                          fontSize: 16, color: Color(CustomColors.main), fontWeight: FontWeight.bold, height: 1.2),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Container(
                    width: 120,
                    height: 40,
                    alignment: Alignment.centerLeft,
                    decoration:
                        const BoxDecoration(border: Border(bottom: BorderSide(width: 2, color: Colors.black12))),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        //'${qrData!['productType']}',
                        '${!jsonDecode(tile[0])['allergy'].values.every((value) => !value as bool) ? jsonDecode(tile[0])['allergy'].keys.where((key) => jsonDecode(tile[0])['allergy'][key] == true).toList().join(', ') : 'Нет'}'
                            .replaceAll('lactose', 'лактоза')
                            .replaceAll('gluten', 'глютен')
                            .replaceAll('other', 'прочее'),
                        style: TextStyle(color: Color(CustomColors.bright), fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 30),
              Container(
                decoration: BoxDecoration(color: Color(CustomColors.bright), borderRadius: BorderRadius.circular(10)),
                height: 40,
                width: 120,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Закрыть',
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, height: 1),
                  ),
                  style: ElevatedButton.styleFrom(
                    shadowColor: Colors.transparent,
                    backgroundColor: Colors.transparent,
                    padding: EdgeInsets.all(8),
                    alignment: Alignment.center,
                  ),
                ),
              )
            ]));
  }
}
