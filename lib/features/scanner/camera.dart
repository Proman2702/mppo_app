import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:mppo_app/etc/colors/colors.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:mppo_app/features/scanner/scanner_content/scan_window_overlay.dart';

import 'package:mppo_app/features/scanner/scanner_content/scanned_barcode_label.dart';
import 'package:mppo_app/features/scanner/scanner_content/scanner_button_widgets.dart';
import 'package:mppo_app/features/scanner/scanner_content/scanner_error_widget.dart';

class ScannerPageMenu extends StatefulWidget {
  const ScannerPageMenu({super.key});

  @override
  State<ScannerPageMenu> createState() => _ScannerPageMenuState();
}

class _ScannerPageMenuState extends State<ScannerPageMenu> {
  final MobileScannerController controller = MobileScannerController();

  @override
  Widget build(BuildContext context) {
    final MobileScannerController controller = MobileScannerController(
      formats: const [BarcodeFormat.qrCode],
    );

    final scanWindow = Rect.fromCenter(
      center: MediaQuery.sizeOf(context).center(Offset.zero),
      width: 200,
      height: 200,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: AppBar(
            toolbarHeight: 75,
            leadingWidth: 70,
            automaticallyImplyLeading: true,
            backgroundColor: Color(CustomColors.shadowLight),
            flexibleSpace: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50), bottomRight: Radius.circular(50))),
            ),
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back, color: Color(CustomColors.main), size: 35)),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50), bottomRight: Radius.circular(50))),
            title: Padding(
              padding: const EdgeInsets.only(left: 0),
              child: GradientText('Сканировать QR',
                  colors: [Color(0xFF32E474), Color(0xff38CACF)],
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Nunito',
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0)),
            ),
          )),
      body: Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: [
          Center(
            child: MobileScanner(
              fit: BoxFit.contain,
              controller: controller,
              scanWindow: scanWindow,
              errorBuilder: (context, error, child) {
                return ScannerErrorWidget(error: error);
              },
              overlayBuilder: (context, constraints) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Align(
                    alignment: Alignment.center,
                    child: ScannedBarcodeLabel(controller: controller),
                  ),
                );
              },
            ),
          ),
          ValueListenableBuilder(
            valueListenable: controller,
            builder: (context, value, child) {
              if (!value.isInitialized || !value.isRunning || value.error != null || scanWindow.isEmpty) {
                return Container(
                  color: Colors.white,
                );
              }

              return ScanWindowOverlay(
                controller: controller,
                scanWindow: scanWindow,
              );
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ToggleFlashlightButton(controller: controller),
                  SwitchCameraButton(controller: controller),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    await controller.dispose();
  }
}
