import 'package:flutter/material.dart';
import 'package:refrigerator/widgets/ending_drawer.dart';

class QuitScreen extends StatelessWidget {
  static const routeName = "/quit-screen";

  QuitScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("待機")),
        drawer: const EndingDrawer(),
        body: const Center(
          child: Text("相方の端末を確認してください"),
        ));
  }
}
