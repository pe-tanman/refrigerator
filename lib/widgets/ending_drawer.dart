import 'package:flutter/material.dart';
import '/screens/home_screen.dart';

class EndingDrawer extends StatelessWidget {
  const EndingDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(children: [
      const DrawerHeader(
        decoration: BoxDecoration(color: Colors.lightBlueAccent),
        child: Text(
          "207\n民と雪の女王",
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
      ),
      ListTile(
        title: const Text("初期化", style: TextStyle(fontSize: 20)),
        onTap: () => Navigator.of(context).pushNamed(HomeScreen.routeName),
      ),
      Container(
        alignment: Alignment.bottomCenter,
        child: const Text("Copyright\n207 Ishihara Yuki",
            style: TextStyle(fontSize: 10, color: Colors.grey)),
      )
    ]));
  }
}
