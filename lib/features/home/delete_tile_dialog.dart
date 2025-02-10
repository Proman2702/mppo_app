import 'dart:convert';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mppo_app/etc/colors/colors.dart';
import 'package:mppo_app/etc/models/user.dart';
import 'package:mppo_app/features/qr_info_handler.dart';
import 'package:mppo_app/repositories/database/database_service.dart';
import 'package:mppo_app/repositories/database/get_values.dart';

class DeleteTileDialog extends StatefulWidget {
  final List tile;
  final Function updater;

  const DeleteTileDialog({super.key, required this.tile, required this.updater});

  @override
  State<DeleteTileDialog> createState() => _DeleteTileDialogState();
}

class _DeleteTileDialogState extends State<DeleteTileDialog> {
  double _deleteCount = 0;

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
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(20),
      titlePadding: const EdgeInsets.only(left: 20, right: 20, top: 20),
      backgroundColor: Colors.white,
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 40,
            width: 160,
            alignment: Alignment.center,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Color(CustomColors.main)),
            child: const Text(
              'Удалить',
              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Color(CustomColors.main)),
              child: const Icon(
                Icons.close,
                color: Colors.white,
                size: 30,
              ),
            ),
          )
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Slider(
            value: _deleteCount,
            divisions: widget.tile[1],
            onChanged: (double value) => setState(() {
              _deleteCount = value;
            }),
            max: widget.tile[1].toDouble(),
          ),
          Container(
            width: 210,
            alignment: Alignment.center,
            child: RichText(
                text: TextSpan(children: [
              const TextSpan(text: 'Кол-во продуктов для удаления: '),
              TextSpan(text: '$_deleteCount', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14))
            ], style: TextStyle(fontSize: 11, color: Color(CustomColors.bright), fontFamily: 'Jura'))),
          ),
          const SizedBox(height: 30),
          Container(
            decoration: BoxDecoration(color: Color(CustomColors.delete), borderRadius: BorderRadius.circular(10)),
            height: 35,
            width: 120,
            child: ElevatedButton(
              onPressed: () async {
                if (_deleteCount.toInt() != 0) {
                  if (dbGetter?.getUser() != null) {
                    CustomUser curUser = dbGetter!.getUser()!;

                    var curHistory = curUser.history;

                    for (int i = 0; i < _deleteCount.toInt(); i++) {
                      log('deleted');
                      curHistory.add(jsonEncode(
                        {
                          "productType": jsonDecode(widget.tile[0])['productType'],
                          'date': '${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}',
                          'type': 'deleted'
                        },
                      ));
                    }

                    if (curHistory.length > 1000) {
                      curHistory.length = 1000;
                    }
                    await database.updateUser(curUser.copyWith(history: curHistory));

                    widget.updater(delete: true, tile: [widget.tile[0], _deleteCount.toInt()]);
                    Navigator.of(context).pushNamedAndRemoveUntil('/', ModalRoute.withName('/'));
                    showModalBottomSheet(context: context, builder: (context) => const InfoSheet(type: 'delete'));
                  } else {
                    showModalBottomSheet(context: context, builder: (context) => const InfoSheet(type: ''));
                  }
                } else {
                  showModalBottomSheet(context: context, builder: (context) => const InfoSheet(type: 'no_delete'));
                }
              },
              child: const Text(
                'Удалить',
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, height: 1),
              ),
              style: ElevatedButton.styleFrom(
                shadowColor: Colors.transparent,
                backgroundColor: Colors.transparent,
                padding: const EdgeInsets.all(8),
                alignment: Alignment.center,
              ),
            ),
          )
        ],
      ),
    );
  }
}
