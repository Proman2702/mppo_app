import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mppo_app/etc/colors/colors.dart';
import 'package:mppo_app/constants.dart' as consts;
import 'package:mppo_app/features/home/tile_view_dialog.dart';

class TileBuilder extends StatelessWidget {
  final List tile;
  final int index;
  final Function() updater;

  const TileBuilder({super.key, required this.index, required this.tile, required this.updater});

  String formatDate(String input) {
    List<String> parts = input.split('-');
    if (parts.length == 3) {
      return '${parts[2]}-${parts[1]}-${parts[0]}';
    }
    return input;
  }

  String dateNontifier(List tile) {
    final exTime = jsonDecode(tile[0])['expiredTime'];

    if (DateTime.parse(formatDate(exTime)).isBefore(DateTime.now())) {
      return 'Продукт просрочен!';
    } else if (DateTime.parse(formatDate(exTime)).difference(DateTime.now()).inHours < 48) {
      return 'Прибл. срок годности!';
    } else {
      return 'Годен до $exTime';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20, left: 15, right: 15),
      child: GestureDetector(
        onTap: () {
          showDialog(context: context, builder: (context) => TileViewDialog(tile: tile, updater: updater));
        },
        child: Container(
          padding: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
          height: 85,
          width: 340,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Color(0xfff8f8f8),
              boxShadow: [BoxShadow(color: Colors.black26, offset: Offset(0, 4), blurRadius: 3)]),
          child: Row(
            children: [
              SvgPicture.asset(
                consts.typesIcons['${jsonDecode(tile[0])['productType']}']!,
                height: 40,
                width: 40,
              ),
              SizedBox(width: 15),
              Container(height: 60, width: 2, color: Color(CustomColors.shadow)),
              SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 245,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        jsonDecode(tile[0])['productName'],
                        style: TextStyle(color: Color(0xff32E474), fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 245,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        jsonDecode(tile[0])['productType'],
                        style:
                            TextStyle(color: Color(0xff38CACF), fontSize: 13, fontWeight: FontWeight.bold, height: 1),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    width: 240,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.only(left: 5, right: 5),
                            height: 23,
                            width: 60,
                            decoration:
                                BoxDecoration(color: Color(0xFFEAEAEA), borderRadius: BorderRadius.circular(10)),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Text(
                                "${jsonDecode(tile[0])['numOption'] == 2 ? tile[1] : jsonDecode(tile[0])['weight']} ${jsonDecode(tile[0])['numOption'] == 2 ? 'шт' : jsonDecode(tile[0])['weightOption'] == 1 ? 'г' : 'мл'}",
                                style: TextStyle(
                                    color: Color(CustomColors.bright), fontSize: 13, fontWeight: FontWeight.bold),
                              ),
                            )),
                        Spacer(),
                        Text(
                          dateNontifier(tile),
                          style: TextStyle(
                              color: Color(CustomColors.bright),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.75),
                        )
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
