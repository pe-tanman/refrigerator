import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:zxing2/qrcode.dart';

class QRCodeReaderScreen extends StatefulWidget {
  const QRCodeReaderScreen({Key? key}) : super(key: key);
  static const routeName = "/qrcode-reader-screen";

  @override
  State<StatefulWidget> createState() => QRCodeReaderScreenState();
}

class QRCodeReaderScreenState extends State<QRCodeReaderScreen> {
  var imagePng =
      img.decodePng(File('lib/Image/IMG_2217.png').readAsBytesSync())!;

  String ReadQRCodeText() {
    LuminanceSource source = RGBLuminanceSource(
        imagePng.width,
        imagePng.height,
        imagePng
            .convert(numChannels: 4)
            .getBytes(order: img.ChannelOrder.abgr)
            .buffer
            .asInt32List());
    var bitmap = BinaryBitmap(GlobalHistogramBinarizer(source));

    var reader = QRCodeReader();
    var result = reader.decode(bitmap);
    return result.text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Text(ReadQRCodeText()));
  }
}
