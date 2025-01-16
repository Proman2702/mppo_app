import 'package:mppo_app/etc/colors/colors.dart';
import 'package:flutter/material.dart';

class EmailNotificator extends StatelessWidget {
  final String type;
  const EmailNotificator({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        (type == 'sent')
            ? "Ссылка для сброса пароля отправлена на вашу почту"
            : "Ссылка для подтверждения аккаунта отправлена на вашу почту. Перейдите по ней и войдите под ранее записанными данными",
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 13),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        SizedBox(
          height: 30,
          width: 110,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Color(CustomColors.main)),
              onPressed: () => Navigator.pop(context),
              child: const Text("Закрыть", style: TextStyle(color: Colors.white))),
        )
      ],
    );
  }
}
