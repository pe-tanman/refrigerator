import 'package:flutter/material.dart';
import "package:refrigerator/data/room_data.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "../provider/tool_provider.dart";

class MainAppbar extends ConsumerStatefulWidget implements PreferredSizeWidget {
  const MainAppbar({Key? key}) : super(key: key);

  @override
  ConsumerState<MainAppbar> createState() => _MainAppbarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _MainAppbarState extends ConsumerState<MainAppbar> {
  int room = 0;
  String time = "2:00";
  int startMin = 2;
  int min = 1;
  int sec = 59;
  List<Widget> hintWidgets = [];
  List<String> hints = [];
  bool hintAvailable = false;
  bool isInit = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      room = ref.watch(roomProvider);
    });
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
    min = 1;
    sec = 59;
    setState(() {});
  }

  Future runTimer() async {
    if (room != 0 && room != 4) {
      for (int i = 1; i <= hints.length; i++) {
        for (min = startMin - 1; min >= 0; min--) {
          for (sec = 59; sec >= 0; sec--) {
            await Future.delayed(const Duration(seconds: 1));
            if (mounted) {
              setState(() {
                time = (sec >= 10) ? "$min:$sec" : "$min:0$sec";
              });
            } else {
              return;
            }
          }
        }
        addHint(i);
      }
    }
  }

  void addHint(int hintNum) {
    hintAvailable = true;
    String availableHint = hints[hintNum - 1];
    hintWidgets.add(Text(
      "ヒント$hintNum:",
      style: const TextStyle(fontWeight: FontWeight.w600),
    ));
    hintWidgets.add(Text(availableHint));
    hintWidgets.add(const Divider());
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<int>(
      roomProvider, // 購読対象のProviderを指定
      (previous, next) {
        startTimer();
        Future.delayed(Duration.zero, () {
          hints = RoomData.roomData(ref.watch(roomProvider))!.hints;
          hintWidgets.clear();
          if (isInit) {
            runTimer();
            isInit = false;
          }
          setState(() {});
        });
      },
    );
    return AppBar(
      backgroundColor: Colors.lightBlue[200],
      title: Text(RoomData.roomData(ref.watch(roomProvider))!.title),
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
