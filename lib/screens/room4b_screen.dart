import 'package:flutter/material.dart';
import 'package:refrigerator/provider/tool_provider.dart';
import 'package:refrigerator/widgets/main_appbar.dart';
import "/Screens/quit_screen.dart";
import "package:refrigerator/data/room_data.dart";

import 'package:refrigerator/widgets/main_drawer.dart';
import "package:flutter_riverpod/flutter_riverpod.dart";

class Room4bScreen extends ConsumerStatefulWidget {
  const Room4bScreen({Key? key}) : super(key: key);
  static const routeName = "/room-4b-screen";
  @override
  ConsumerState<Room4bScreen> createState() => _Room4bScreenState();
}

class _Room4bScreenState extends ConsumerState<Room4bScreen> {
  int room = 5;
  String questionImgPath = "assets/images/question.jpg";

  void showFinishedDialog() {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: const Text("確認"),
            content: const Column(
              children: [
                Text("南京錠を開けて次の部屋に進んでください"),
                Text(
                  "OKボタンを押すと、問題文やヒント、答えは見られなくなります",
                  style: TextStyle(fontWeight: FontWeight.w600),
                )
              ],
            ),
            actions: [
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.of(context).pushNamed(QuitScreen.routeName);
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      room = ref.watch(roomProvider);
    });
    return Scaffold(
      appBar: const MainAppbar(),
      drawer: const MainDrawer(),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(RoomData.roomData(4)!.imgPath),
              fit: BoxFit.cover),
        ),
        child: Column(
          children: [
            Container(
                width: 800,
                height: 600,
                decoration: BoxDecoration(
                    image:
                        DecorationImage(image: AssetImage(questionImgPath)))),
            const SizedBox(height: 50),
            ElevatedButton(
              child: const Text("解き終わった"),
              onPressed: () {
                showFinishedDialog();
              },
            )
          ],
        ),
      ),
    );
  }
}
