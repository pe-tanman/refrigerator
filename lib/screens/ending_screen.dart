import 'package:flutter/material.dart';
import "/widgets/ending_drawer.dart";
import 'package:video_player/video_player.dart';

class EndingScreenArguments {
  final String decision;

  EndingScreenArguments({required this.decision});
}

class EndingScreen extends StatefulWidget {
  EndingScreen({Key? key}) : super(key: key);
  static const routeName = "/ending-screen";
  @override
  State<EndingScreen> createState() => _EndingScreenState();
}

class _EndingScreenState extends State<EndingScreen> {
  // コントローラー
  late VideoPlayerController _controller;
  bool videoEnded = false;
  String decision = "a";
  bool isInit = true;
  @override
  void initState() {
    super.initState();
  }

  void checkVideo() {
    if (_controller.value.position == _controller.value.duration) {
      setState(() {
        videoEnded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isInit) {
      decision =
          (ModalRoute.of(context)!.settings.arguments as EndingScreenArguments)
              .decision;
      if (decision == "a") {
        _controller = VideoPlayerController.networkUrl(Uri.parse(
            "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4"))
          ..initialize().then((_) {
            _controller.play();
            // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
            setState(() {});
          });
        _controller.addListener(checkVideo);
      } else {
        _controller = VideoPlayerController.networkUrl(Uri.parse(
            "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4"))
          ..initialize().then((_) {
            _controller.play();
            // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
            setState(() {});
          });
        _controller.addListener(checkVideo);
      }
      isInit = false;
    }

    return Scaffold(
      appBar: (videoEnded)
          ? AppBar(
              title: const Text("エンディング"),
            )
          : null,
      drawer: const EndingDrawer(),
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : Container(),
      ),
      backgroundColor: Colors.black,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
