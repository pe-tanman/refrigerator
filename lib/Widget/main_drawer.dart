import 'package:flutter/material.dart';
import 'package:refrigerator/Screen/reference_screen.dart';

import '/Screen/reference_screen.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(padding: EdgeInsets.zero, children: [
      const DrawerHeader(
        decoration: BoxDecoration(color: Colors.lightBlueAccent),
        child: Text(
          "207\n民と雪の女王",
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
      ),
      ListTile(
        title: const Text("操作説明", style: TextStyle(fontSize: 20)),
        onTap: () => Navigator.of(context).pushNamed(ReferenceScreen.routeName),
      ),
      Container(
        alignment: Alignment.bottomCenter,
        child: Text("Copyright\n207 Ishihara Yuki",
            style: TextStyle(fontSize: 10, color: Colors.grey)),
      )
    ]));
  }
}
