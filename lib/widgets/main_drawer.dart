import 'package:flutter/material.dart';
import 'package:refrigerator/screens/start_screen.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(padding: EdgeInsets.zero, children: [
      DrawerHeader(
        decoration: BoxDecoration(color: Colors.lightBlue[200]),
        child: const Text(
          "207\n民と雪の女王",
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
      ),
      ListTile(
        title: const Text("初期化", style: TextStyle(fontSize: 20)),
        onTap: () => Navigator.of(context).pushNamed(StartScreen.routeName),
      ),
      Container(
        alignment: Alignment.bottomCenter,
        child: const Text("Copyright\n207 Ishihara Yuki",
            style: TextStyle(fontSize: 10, color: Colors.grey)),
      )
    ]));
  }
}
