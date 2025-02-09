import 'package:flutter/material.dart';
import 'package:mppo_app/etc/colors/colors.dart';
import 'package:mppo_app/features/qr_info_handler.dart';

class DeleteTileDialog extends StatefulWidget {
  final List tile;
  final Function updater;

  const DeleteTileDialog({super.key, required this.tile, required this.updater});

  @override
  State<DeleteTileDialog> createState() => _DeleteTileDialogState();
}

class _DeleteTileDialogState extends State<DeleteTileDialog> {
  double _deleteCount = 0;

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
              'Удалить',
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
              child: Icon(
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
              TextSpan(text: 'Кол-во продуктов для удаления: '),
              TextSpan(text: '$_deleteCount', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14))
            ], style: TextStyle(fontSize: 11, color: Color(CustomColors.bright), fontFamily: 'Jura'))),
          ),
          const SizedBox(height: 30),
          Container(
            decoration: BoxDecoration(color: Color(CustomColors.delete), borderRadius: BorderRadius.circular(10)),
            height: 35,
            width: 120,
            child: ElevatedButton(
              onPressed: () {
                if (_deleteCount.toInt() != 0) {
                  widget.updater(delete: true, tile: [widget.tile[0], _deleteCount.toInt()]);
                  Navigator.of(context).pushNamedAndRemoveUntil('/', ModalRoute.withName('/'));
                  showModalBottomSheet(context: context, builder: (context) => InfoSheet(type: 'delete'));
                } else {
                  showModalBottomSheet(context: context, builder: (context) => InfoSheet(type: 'no_delete'));
                }
              },
              child: Text(
                'Удалить',
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
        ],
      ),
    );
  }
}
