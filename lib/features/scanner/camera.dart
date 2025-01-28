import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:mppo_app/etc/colors/colors.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:mppo_app/features/scanner/scan_window_overlay.dart';

import 'package:mppo_app/features/scanner/scanned_barcode_label.dart';
import 'package:mppo_app/features/scanner/scanner_button_widgets.dart';
import 'package:mppo_app/features/scanner/scanner_error_widget.dart';

class ScannerPageMenu extends StatefulWidget {
  const ScannerPageMenu({super.key});

  @override
  State<ScannerPageMenu> createState() => _ScannerPageMenuState();
}

class _ScannerPageMenuState extends State<ScannerPageMenu> {
  final MobileScannerController _controller = MobileScannerController();

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
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Scanner with Overlay Example app'),
      ),
      body: Stack(
        fit: StackFit.expand,
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
                    alignment: Alignment.bottomCenter,
                    child: ScannedBarcodeLabel(barcodes: controller.barcodes),
                  ),
                );
              },
            ),
          ),
          ValueListenableBuilder(
            valueListenable: controller,
            builder: (context, value, child) {
              if (!value.isInitialized || !value.isRunning || value.error != null || scanWindow.isEmpty) {
                return const SizedBox();
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
    await _controller.dispose();
  }
}
