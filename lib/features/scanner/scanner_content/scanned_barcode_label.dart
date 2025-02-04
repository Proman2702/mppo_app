import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:mppo_app/features/scanner/scanner_page.dart';

class ScannedBarcodeLabel extends StatelessWidget {
  ScannedBarcodeLabel({
    super.key,
    required this.controller,
  });

  final MobileScannerController controller;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: controller.barcodes,
      builder: (context, snapshot) {
        final scannedBarcodes = snapshot.data?.barcodes ?? [];

        final values = scannedBarcodes.map((e) => e.displayValue).join(', ');

        if (!scannedBarcodes.isEmpty) {
          controller.dispose();
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).popAndPushNamed('/scan', arguments: values);
          });
          return SizedBox();
        }

        return SizedBox();
      },
    );
  }
}
