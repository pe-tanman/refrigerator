import 'package:flutter/material.dart';

class ReferenceScreen extends StatelessWidget {
  static const routeName = "/reference-screen";

  ReferenceScreen({
    super.key,
  });

  final _viewTransformationController = TransformationController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("操作説明")),
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
                child: Image.asset("images/map.png"),
              ),
            ],
          ),
           */
        ),
      ),
    );
  }
}
