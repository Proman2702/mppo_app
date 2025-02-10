import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mppo_app/etc/colors/colors.dart';
import 'package:mppo_app/features/scanner/generator_error_hander.dart';

class ListDialog extends StatefulWidget {
  final Function updater;
  const ListDialog({super.key, required this.updater});

  @override
  State<ListDialog> createState() => _ListDialogState();
}

class _ListDialogState extends State<ListDialog> {
  Map<String, String?> byingList = {'name': null, 'other': null};

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
              'Добавить',
              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Color(CustomColors.main)),
              child: const Icon(Icons.close, color: Colors.white, size: 30),
            ),
          )
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
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
                    onChanged: (value) => setState(() {
                      byingList['name'] = value;
                    }),
                    decoration: const InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      contentPadding: EdgeInsets.only(bottom: 10),
                      counterText: "",
                      border: InputBorder.none,
                      labelText: "Название товара",
                      labelStyle: TextStyle(color: Colors.black12, fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
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
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 1000),
                      child: TextField(
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: Colors.black87),
                        maxLength: 80,
                        onChanged: (value) => setState(() {
                          byingList['other'] = value;
                        }),
                        decoration: const InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          contentPadding: EdgeInsets.only(bottom: 10),
                          counterText: "",
                          border: InputBorder.none,
                          labelText: "Прочее",
                          labelStyle: TextStyle(color: Colors.black12, fontSize: 20, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Container(
            decoration: BoxDecoration(color: Color(CustomColors.bright), borderRadius: BorderRadius.circular(10)),
            height: 35,
            width: 140,
            child: ElevatedButton(
              onPressed: () {
                if (byingList.values.every((element) => element != null)) {
                  widget.updater(add: true, data: jsonEncode(byingList));
                  Navigator.of(context).pop();
                } else {
                  showModalBottomSheet(
                      context: context, builder: (BuildContext context) => const GeneratorDenySheet(type: 'none'));
                }
              },
              child: Text(
                'Сохранить',
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, height: 1),
              ),
              style: ElevatedButton.styleFrom(
                shadowColor: Colors.transparent,
                backgroundColor: Colors.transparent,
                padding: EdgeInsets.all(5),
                alignment: Alignment.center,
              ),
            ),
          )
        ],
      ),
    );
  }
}
