import 'package:flutter/material.dart';
import 'package:mppo_app/etc/colors/colors.dart';

// --------------------------
// Файл обработки уведомлений о qr кодах
// Здесь реализовано всплывающее окно с уведомлением об ошибке
// --------------------------

class QrInfoSheet extends StatelessWidget {
  const QrInfoSheet({super.key, required this.type});

  final String type;

  String handler() {
    switch (type) {
      case 'error':
        return 'Ошибка!';
      case 'add':
        return 'Продукт успешно добавлен!';
      case 'remove':
        return 'Продукт успешно удален!';
      case 'none':
        return 'Такого продукта не существует!';
    }
    return 'Что-то пошло не так';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      width: 200,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(left: 5, right: 5),
              alignment: Alignment.center,
              child: Text(handler(), textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w700)),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 30,
              width: 110,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(CustomColors.main),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Закрыть", style: TextStyle(color: Colors.white))),
            )
          ],
        ),
      ),
    );
  }
}
