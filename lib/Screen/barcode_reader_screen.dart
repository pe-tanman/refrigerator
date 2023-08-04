import 'package:flutter/material.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import 'package:permission_handler_web/permission_handler_web.dart';

class BarcodeReaderScreen extends StatefulWidget {
  const BarcodeReaderScreen({Key? key}) : super(key: key);
  static const routeName = "/barcode-reader-screen";

  @override
  State<BarcodeReaderScreen> createState() => BarcodeReaderScreenState();
}

class BarcodeReaderScreenState extends State<BarcodeReaderScreen> {
  String result = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () async {
                var res = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SimpleBarcodeScannerPage(),
                    ));
                setState(() {
                  if (res is String) {
                    result = res;
                  }
                });
              },
              child: const Text('Open Scanner'),
            ),
            Text('Barcode Result: $result'),
          ],
        ),
      ),
    );
  }
}
