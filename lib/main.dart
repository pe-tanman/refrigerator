import 'package:flutter/material.dart';
import 'package:refrigerator/Screen/barcode_reader_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Refrigerator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const BarcodeReaderScreen(),
    );
  }
}
