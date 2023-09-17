import 'package:flutter/material.dart';
import "package:refrigerator/data/room_data.dart";

class MainAppbar extends StatefulWidget implements PreferredSizeWidget {
  final int room;
  const MainAppbar({required this.room, Key? key}) : super(key: key);

  @override
  State<MainAppbar> createState() => _MainAppbarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _MainAppbarState extends State<MainAppbar> {
  late int room;
  String time = "2:00";
  List<Widget> hintWidgets = [];
  bool hintAvailable = false;
  List<String> hints = [];
  @override
  void initState() {
    super.initState();
    room = widget.room;
    startTimer();
  }

  Widget _buildHintButton() {
    return ElevatedButton.icon(
        onPressed: (hintAvailable)
            ? () => showDialog(
                context: context,
                builder: (_) {
                  return AlertDialog(
                      title: const Text("確認"),
                      content: const Text("ヒントを表示してよろしいですか？"),
                      actions: [
                        TextButton(
                          child: const Text("OK"),
                          onPressed: () {
                            Navigator.of(context).pop();
                            showDialog(
                                context: context,
                                builder: (_) {
                                  return AlertDialog(
                                      title: const Text("ヒント"),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: hintWidgets,
                                      ));
                                });
                          },
                        ),
                        TextButton(
                          child: const Text("キャンセル"),
                          onPressed: () => Navigator.of(context).pop(),
                        )
                      ]);
                })
            : null,
        label: const Text(
          "ヒント",
        ),
        icon: const Icon(
          Icons.lightbulb,
        ));
  }

  Future startTimer() async {
    int startMin = 1;
    for (int i = 1; i <= 3; i++) {
      for (int min = startMin - 1; min >= 0; min--) {
        for (int sec = 59; sec >= 0; sec--) {
          if (mounted) {
            setState(() {
              time = (sec >= 10) ? "$min:$sec" : "$min:0$sec";
            });
          }

          await Future.delayed(const Duration(seconds: 1));
        }
      }
      addHint(i);
    }
  }

  void addHint(int hintNum) {
    hintAvailable = true;
    String availableHint = hints[room - 1][hintNum - 1];
    hintWidgets.add(Text(
      "ヒント$hintNum:",
      style: const TextStyle(fontWeight: FontWeight.w600),
    ));
    hintWidgets.add(Text(availableHint));
    hintWidgets.add(const Divider());
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(RoomData.roomData(room)!.title),
      actions: [
        const Text("ヒント追加まで"),
        Center(
          child: Text(
            time,
            style: const TextStyle(fontSize: 25),
          ),
        ),
        const SizedBox(width: 10),
        Center(child: _buildHintButton()),
        const SizedBox(width: 20)
      ],
    );
  }
}
