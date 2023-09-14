import 'package:flutter/material.dart';
import 'package:refrigerator/Screen/home_screen.dart';
import 'package:refrigerator/Widget/main_drawer.dart';
import "/Widget/ending_drawer.dart";

class StartScreen extends StatelessWidget {
  static const routeName = "/ending-a-screen";

  StartScreen({
    super.key,
  });

  final _viewTransformationController = TransformationController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("スタート")),
      drawer: const MainDrawer(),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 100,
            ),
            Container(
              width: 800,
              height: 300,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("Image/title.jpg"), fit: BoxFit.cover)),
            ),
            const SizedBox(
              height: 50,
            ),
            const Text(
              "それぞれ別のプレイヤーを選択してください",
              style: TextStyle(fontSize: 30),
            ),
            const SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(60),
                      ),
                      elevation: 13),
                  onPressed: () {
                    Navigator.pushNamed(context, HomeScreen.routeName,
                        arguments: HomeScreenArguments(room: 1));
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text("こびと1",
                        style: TextStyle(
                            fontSize: 35, fontWeight: FontWeight.w600)),
                  ),
                ),
                const SizedBox(width: 100, height: 50),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(60),
                        ),
                        elevation: 13),
                    onPressed: () {
                      Navigator.pushNamed(context, HomeScreen.routeName,
                          arguments: HomeScreenArguments(room: 3));
                      showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (_) {
                            return AlertDialog(
                              title: const Text(
                                "! 注意",
                                style: TextStyle(fontSize: 40),
                              ),
                              content: const Text("3つめの部屋までこの端末は使用できません",
                                  style: TextStyle(fontSize: 25)),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("3の部屋に到着した")),
                              ],
                            );
                          });
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text("こびと2",
                          style: TextStyle(
                              fontSize: 35, fontWeight: FontWeight.w600)),
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }
}
