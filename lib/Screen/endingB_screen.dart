import 'package:flutter/material.dart';
import 'package:refrigerator/widgets/ending_drawer.dart';

class EndingBScreen extends StatelessWidget {
  static const routeName = "/ending-b-screen";

  EndingBScreen({
    super.key,
  });

  final _viewTransformationController = TransformationController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("エンディング")),
      drawer: const EndingDrawer(),
      body: InteractiveViewer(
        transformationController: _viewTransformationController,
        maxScale: 5,
        child: const SizedBox(
          width: double.infinity,
          height: double.infinity,
          /*
          操作説明の画像をここに
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Image.asset("assets/images/map.png"),
              ),
            ],
          ),
           */
        ),
      ),
    );
  }
}
