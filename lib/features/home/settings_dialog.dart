import 'package:flutter/material.dart';
import 'package:mppo_app/etc/colors/colors.dart';
import 'package:mppo_app/etc/colors/gradients/background.dart';

class SettingsDialog extends StatefulWidget {
  const SettingsDialog({super.key});

  @override
  State<SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.all(20),
      backgroundColor: Colors.white,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 65,
                width: 260,
                decoration: BoxDecoration(gradient: BackgroundGrad(), borderRadius: BorderRadius.circular(20)),
                alignment: Alignment.center,
                child: Text(
                  'Настройки',
                  style:
                      TextStyle(color: Colors.white, fontSize: 32, fontFamily: 'Nunito', fontWeight: FontWeight.bold),
                ),
              ),
              Flexible(child: SizedBox(width: 500)),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 65,
                      height: 65,
                      decoration: BoxDecoration(gradient: BackgroundGrad(), borderRadius: BorderRadius.circular(20)),
                      alignment: Alignment.center,
                      child: Icon(Icons.text_fields, size: 35, color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 5),
                  Text('Сменить IP сервера',
                      style: TextStyle(color: Color(CustomColors.bright), fontSize: 13, fontWeight: FontWeight.bold))
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
