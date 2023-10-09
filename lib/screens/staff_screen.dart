import "package:flutter/material.dart";
import "package:refrigerator/provider/tool_provider.dart";
import "package:refrigerator/screens/ending_screen.dart";
import "package:refrigerator/widgets/ending_drawer.dart";
import "package:refrigerator/widgets/main_appbar.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

class StaffScreen extends ConsumerWidget {
  const StaffScreen({Key? key}) : super(key: key);
  static String routeName = "/staff-screen";
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: const MainAppbar(),
        drawer: const EndingDrawer(),
        body: Center(
            child: Column(
          children: [
            ElevatedButton(
                onPressed: () {
                  ref.read(roomProvider.notifier).setRoom(2);
                },
                child: const Text("room 2")),
            ElevatedButton(
                onPressed: () {
                  ref.read(roomProvider.notifier).setRoom(3);
                },
                child: const Text("room 3")),
            ElevatedButton(
                onPressed: () {
                  ref.read(roomProvider.notifier).setRoom(4);
                },
                child: const Text("room 4a")),
            ElevatedButton(
                onPressed: () {
                  ref.read(roomProvider.notifier).setRoom(5);
                },
                child: const Text("room 4b")),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(EndingScreen.routeName);
                },
                child: const Text("ending"))
          ],
        )));
  }
}
