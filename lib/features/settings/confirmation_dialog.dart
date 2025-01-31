import 'package:mppo_app/etc/colors/colors.dart';
import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  const ConfirmationDialog({super.key, required this.info, required this.action});
  final Function action;
  final String info;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        info,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        SizedBox(
          height: 30,
          width: 80,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color(CustomColors.main),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              onPressed: () => Navigator.pop(context),
              child: const Text("Нет", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700))),
        ),
        SizedBox(
          height: 30,
          width: 80,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color(CustomColors.main),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              onPressed: () async {
                Navigator.pop(context);
                action();
              },
              child: const Text("Да", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700))),
        )
      ],
    );
  }
}
