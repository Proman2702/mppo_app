import 'package:flutter/material.dart';
import 'package:mppo_app/etc/colors/colors.dart';

// --------------------------
// Файл обработки ошибок
// Здесь реализовано всплывающее окно с уведомлением об ошибке
// --------------------------

class GeneratorDenySheet extends StatelessWidget {
  const GeneratorDenySheet({super.key, required this.type});

  final String type;

  String handler() {
    switch (type) {
      case 'none':
        return 'Не все данные заполнены';
      case 'int':
        return 'Значение в некоторых полях должны быть числовыми';
      case 'date':
        return 'Ошибка в записи даты';
      case 'success':
        return 'Успешно!';
    }
    return 'Что-то пошло не так';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
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
              child: Text(
                handler(),
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 30,
              width: 110,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(CustomColors.main),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Закрыть", style: TextStyle(color: Colors.white))),
            )
          ],
        ),
      ),
    );
  }
}
