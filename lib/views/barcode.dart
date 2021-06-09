import 'package:ai_barcode/ai_barcode.dart';
import 'package:flutter/material.dart';

class Barcode extends StatefulWidget {
  const Barcode({Key? key}) : super(key: key);

  @override
  _BarcodeState createState() => _BarcodeState();
}

class _BarcodeState extends State<Barcode> {
  late ScannerController _scannerController;

  @override
  void initState() {
    super.initState();

    _scannerController = ScannerController(
      scannerResult: (result) {
        print(result);
        // _resultCallback(result);
      },
      scannerViewCreated: () {
        TargetPlatform platform = Theme.of(context).platform;
        if (TargetPlatform.iOS == platform) {
          Future.delayed(Duration(seconds: 2), () {
            _scannerController.startCamera();
            _scannerController.startCameraPreview();
          });
        } else {
          _scannerController.startCamera();
          _scannerController.startCameraPreview();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      // ),
      body: PlatformAiBarcodeScannerWidget(
        platformScannerController: _scannerController,
      ),
    );
  }
}
