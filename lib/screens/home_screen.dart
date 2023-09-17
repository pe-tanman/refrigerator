import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:refrigerator/screens/room4b_screen.dart';
import 'package:refrigerator/screens/ending_screen.dart';
import 'package:refrigerator/provider/tool_provider.dart';
import 'package:refrigerator/widgets/main_appbar.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import 'package:refrigerator/widgets/main_drawer.dart';
import 'package:refrigerator/utilities/ingredients.dart';
import 'package:refrigerator/utilities/tools.dart';
import 'package:refrigerator/utilities/RGB.dart';
import "package:refrigerator/data/room_data.dart";

class HomeScreenArguments {
  final int room;

  HomeScreenArguments({required this.room});
}

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const routeName = "/home-screen";

  @override
  ConsumerState<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends ConsumerState<HomeScreen> {
  String result = '';
  bool isInit = true;
  bool isCorrect = false;
  bool isSuccessful = false;
  bool canSend = false;
  int room = 1;
  int startRoom = 1;
  String inventoryImgPath = "images/background/inventory_tile.png";
  List<Ingredient> objectInventory = [];
  List<Widget> widgetInventory = [];
  List<Widget> displayInventory = [];
  List<Ingredient> completeObjectInventory = [];
  List<Widget> completeWidgetInventory = [];
  var objectInventoryNotifier;
  var widgetInventoryNotifier;
  var displayInventoryNotifier;
  var completeObjectInventoryNotifier;
  var completeWidgetInventoryNotifier;

  late ColorScheme colors;
  String decision = ""; // a or b

  //room1
  Ingredient redEgg = Ingredient(
      name: "赤の卵",
      image: "assets/images/items/red_egg.png",
      password: "red-egg");
  Ingredient blueEgg = Ingredient(
      name: "青の卵",
      image: "assets/images/items/blue_egg.png",
      password: "blue-egg");
  Ingredient yellowEgg = Ingredient(
      name: "黄色の卵",
      image: "assets/images/items/yellow_egg.png",
      password: "yellow-egg");
  Ingredient brownEgg = Ingredient(
      name: "茶色の卵",
      image: "assets/images/items/brown_egg.png",
      password: "brown-egg");
  Ingredient purpleEgg = Ingredient(
      name: "紫の卵",
      image: "assets/images/items/purple_egg.png",
      password: "purple-egg");
  Ingredient greenEgg = Ingredient(
      name: "緑の卵",
      image: "assets/images/items/green_egg.png",
      password: "green-egg");
  Ingredient blackEgg = Ingredient(
      name: "黒の卵",
      image: "assets/images/items/black_egg.png",
      password: "black-egg");
  Ingredient correctCrashedEgg = Ingredient(
      name: "輝く卵",
      image: "assets/images/items/correct_crashed_egg.png",
      password: "correct-egg-52");
  Ingredient incorrectCrashedEgg = Ingredient(
      name: "腐った卵",
      image: "assets/images/items/incorrect_crashed_egg.png",
      password: "incorrect-egg");
  Tools checker1 = Tools(
      capacity: [1],
      password: "checker-1263",
      image: "assets/images/tools/mixer.png",
      actionName: "割って確認");
  //room2
  Tools mixer1 = Tools(
      capacity: [3],
      password: "mixer1-7213",
      image: "assets/images/tools/mortar.png",
      actionName: "混合");
  Ingredient goldenHimono = Ingredient(
      name: "goldenHimono",
      image: "assets/images/items/wasyoku_himono.png",
      password: "himono-0123");
  Ingredient himono1 = Ingredient(
      name: "himono1",
      image: "assets/images/items/wasyoku_himono.png",
      password: "himono-1111");
  Ingredient himono2 = Ingredient(
      name: "himono2",
      image: "assets/images/items/wasyoku_himono.png",
      password: "himono-2222");
  Ingredient himono3 = Ingredient(
      name: "himono3",
      image: "assets/images/items/wasyoku_himono.png",
      password: "himono-3333");
//room3
  Ingredient goldenLiquid = Ingredient(
      name: "goldenLiquid",
      image: "assets/images/monster.png",
      password: "liquid-0123");
  Ingredient redLiquid = RGB(1, 0, 0).liquid;
  Ingredient greenLiquid = RGB(0, 1, 0).liquid;
  Ingredient blueLiquid = RGB(0, 0, 1).liquid;
  Ingredient yellowLiquid = RGB(1, 1, 0).liquid;
  Ingredient magentaLiquid = RGB(1, 0, 1).liquid;
  Ingredient cyanLiquid = RGB(0, 1, 1).liquid;
  Ingredient blackLiquid = RGB(0, 0, 0).liquid;
  Ingredient whiteLiquid = RGB(1, 1, 1).liquid;

  Tools lightMixer = Tools(
      capacity: [2, 3],
      password: "lightMixer",
      image: "assets/images/tools/mixer.png",
      actionName: "光の混合");
  Tools lightSeparator = Tools(
      capacity: [1],
      password: "lightSeparator",
      image: "assets/images/tools/mixer.png",
      actionName: "光の分解");
  Tools colorMixer = Tools(
      capacity: [2, 3],
      password: "colorMixer",
      image: "assets/images/tools/mixer.png",
      actionName: "色の混合");
  Tools colorSeparator = Tools(
      capacity: [1],
      password: "colorMixer",
      image: "assets/images/tools/mixer.png",
      actionName: "色の分解");
  Tools blackAndWhiteMixer = Tools(
      capacity: [2],
      password: "mixer2-7113",
      image: "assets/images/tools/mixer.png",
      actionName: "混合");

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      objectInventoryNotifier = ref.watch(objectInventoryProvider.notifier);
      widgetInventoryNotifier = ref.watch(widgetInventoryProvider.notifier);
      displayInventoryNotifier = ref.watch(displayInventoryProvider.notifier);
      completeObjectInventoryNotifier =
          ref.watch(completeObjectInventoryProvider.notifier);
      completeWidgetInventoryNotifier =
          ref.watch(completeWidgetInventoryProvider.notifier);

      objectInventory = ref.watch(objectInventoryProvider);
      widgetInventory = ref.watch(widgetInventoryProvider);
      displayInventory = ref.watch(displayInventoryProvider);
      completeWidgetInventory = ref.watch(completeWidgetInventoryProvider);
      completeObjectInventory = ref.watch(completeObjectInventoryProvider);

      makeInventoryOutline();
      canSend = (startRoom == 1);
    });
  }

  Future<String> scan() async {
    var res = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const SimpleBarcodeScannerPage(),
        ));
    print(res as String);
    return res as String;
  }

  void pick(String password) {
    switch (room) {
      case 1:
        //インベントリ追加//TODO:egg1,2,3と追加する
        setState(() {
          isSuccessful = redEgg.addToInventory(ref, password);
          isSuccessful = greenEgg.addToInventory(ref, password);
          isSuccessful = purpleEgg.addToInventory(ref, password);
          isSuccessful = yellowEgg.addToInventory(ref, password);
          isSuccessful = blackEgg.addToInventory(ref, password);
          isSuccessful = blueEgg.addToInventory(ref, password);
          isSuccessful = brownEgg.addToInventory(ref, password);
        });
        //test

        checker1.showSelectItemsDialog(password, checker1.useCompleteMixer, ref,
            correctCrashedEgg, [], [yellowEgg], showFirstClearDialog);

        if (objectInventory.length < 5 && isSuccessful) {
          showPickedDialog();
          isSuccessful = false;
        } else if (objectInventory.length >= 5) {
          showPickFailedDialog();
        }
        break;

      case 2:
        setState(() {
          isSuccessful = himono1.addToInventory(ref, password);
          isSuccessful = himono2.addToInventory(ref, password);
          isSuccessful = himono3.addToInventory(ref, password);
        });
        mixer1.showSelectItemsDialog(
            password,
            mixer1.useCompleteMixer,
            ref,
            goldenHimono,
            [],
            [himono1, himono2, himono3],
            showSecondClearDialog);

        if (objectInventory.length < 5 && isSuccessful) {
          showPickedDialog();
          isSuccessful = false;
        } else if (objectInventory.length >= 5) {
          showPickFailedDialog();
        }
        break;

      case 3:
        setState(() {
          isSuccessful = greenLiquid.addToInventory(ref, password);
          isSuccessful = yellowLiquid.addToInventory(ref, password);
          isSuccessful = redLiquid.addToInventory(ref, password);
          isSuccessful = blueLiquid.addToInventory(ref, password);
          isSuccessful = cyanLiquid.addToInventory(ref, password);
          isSuccessful = magentaLiquid.addToInventory(ref, password);
          isSuccessful = whiteLiquid.addToInventory(ref, password);
          isSuccessful = blackLiquid.addToInventory(ref, password);
        });

        lightMixer.showSelectItemsDialog(
            password, lightMixer.useLightMixer, ref);
        lightSeparator.showSelectItemsDialog(
            password, lightSeparator.useLightSeparator, ref);
        colorMixer.showSelectItemsDialog(
            password, colorSeparator.useColorSeparator, ref);
        colorSeparator.showSelectItemsDialog(
            password, colorMixer.useColorMixer, ref);
        blackAndWhiteMixer.showSelectItemsDialog(
            password,
            blackAndWhiteMixer.useCompleteMixer,
            ref,
            goldenLiquid,
            [],
            [blackLiquid, whiteLiquid],
            showThirdClearDialog);

        if (objectInventory.length <= 5 && isSuccessful) {
          //受け取ったときの処理
          canSend = true;
          showPickedDialog();
          isSuccessful = false;
        } else {
          showPickFailedDialog();
        }
        break;
    }
  }

  void makeInventoryOutline() {
    for (int i = 0; i <= 4; i++) {
      displayInventoryNotifier.add(Container(
        width: 180,
        height: 180,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(inventoryImgPath), fit: BoxFit.cover)),
      ));
      completeWidgetInventoryNotifier.add(Container(
        width: 180,
        height: 180,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(inventoryImgPath), fit: BoxFit.cover)),
      ));
    }
    setState(() {});
  }

  void showPickedDialog() {
    setState(() {});
    int latestIndex = widgetInventory.length - 1;
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: const Text("GET",
                style: TextStyle(fontSize: 60, fontWeight: FontWeight.w600)),
            content: SizedBox(
              width: 200,
              height: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: 200, height: 30),
                  widgetInventory[latestIndex],
                  Text(objectInventory[latestIndex].detail!),
                ],
              ),
            ),
            actions: <Widget>[
              // ボタン領域
              TextButton(
                  child: const Text("OK"),
                  onPressed: () => Navigator.of(context).pop()),
            ],
          );
        });
  }

  void showPickFailedDialog() {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: const Text("MISS",
                style: TextStyle(fontSize: 60, fontWeight: FontWeight.w600)),
            content: const SizedBox(
              width: 200,
              height: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 200, height: 30),
                  Text("インベントリが満タンか、正しくない食材を手に取りました。"),
                ],
              ),
            ),
            actions: <Widget>[
              // ボタン領域
              TextButton(
                  child: const Text("OK"),
                  onPressed: () => Navigator.of(context).pop()),
            ],
          );
        });
  }

  Widget _buildTrashBoxButton() {
    List<int> selectedItems = [];
    List<int> tags = List.generate(objectInventory.length, (index) => index);
    return IconButton(
      onPressed: () {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("消去するアイテムを選択"),
                content: Wrap(
                  runSpacing: 16,
                  spacing: 16,
                  children: tags.map((tag) {
                    // selectedTags の中に自分がいるかを確かめる
                    bool isSelected = selectedItems.contains(tag);
                    return InkWell(
                      borderRadius: const BorderRadius.all(Radius.circular(32)),
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            // すでに選択されていれば取り除く
                            selectedItems.remove(tag);
                          } else {
                            // 選択されていなければ追加する
                            selectedItems.add(tag);
                          }
                          isSelected = selectedItems.contains(tag);
                        });
                      },
                      child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(32)),
                            border: Border.all(
                              width: 2,
                              color:
                                  isSelected ? Colors.lightBlue : Colors.white,
                            ),
                            color: isSelected ? Colors.lightBlue : null,
                          ),
                          child: widgetInventory[tag]),
                    );
                  }).toList(),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: (selectedItems.isNotEmpty)
                        ? () {
                            for (int i in tags) {
                              objectInventoryNotifier.removeAt(i);
                              widgetInventoryNotifier.removeAt(i);
                              displayInventoryNotifier.add(Container(
                                width: 150,
                                height: 150,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(inventoryImgPath),
                                        fit: BoxFit.cover)),
                              ));
                            }
                            Navigator.of(context).pop();
                          }
                        : null,
                    child: const Text("削除"),
                  )
                ],
              );
            });
      },
      icon: const Icon(Icons.delete),
      style: IconButton.styleFrom(
        foregroundColor: colors.onPrimary,
        backgroundColor: colors.primary,
        disabledBackgroundColor: colors.onSurface.withOpacity(0.12),
        hoverColor: colors.onPrimary.withOpacity(0.08),
        focusColor: colors.onPrimary.withOpacity(0.12),
        highlightColor: colors.onPrimary.withOpacity(0.12),
      ),
    );
  }

  Widget _buildResetButton() {
    return IconButton(
      onPressed: () {
        for (int i = 0; i <= 4; i++) {
          displayInventoryNotifier.replace(
              i,
              Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(inventoryImgPath),
                        fit: BoxFit.cover)),
              ));
        }
        objectInventoryNotifier.clear();
        widgetInventoryNotifier.clear();
      },
      icon: const Icon(Icons.close),
      style: IconButton.styleFrom(
        foregroundColor: colors.onPrimary,
        backgroundColor: colors.primary,
        disabledBackgroundColor: colors.onSurface.withOpacity(0.12),
        hoverColor: colors.onPrimary.withOpacity(0.08),
        focusColor: colors.onPrimary.withOpacity(0.12),
        highlightColor: colors.onPrimary.withOpacity(0.12),
      ),
    );
  }

  Widget _buildSendButton() {
    return ElevatedButton.icon(
        onPressed: () {
          showDialog(
              context: context,
              builder: (_) => AlertDialog(
                    title: const Text("送信するアイテムを選択"),
                    content: SizedBox(
                      width: 400,
                      child: Wrap(
                        direction: Axis.horizontal,
                        children: optionsToSend(),
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text("キャンセル"))
                    ],
                  ));
        },
        label: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text("手渡す", style: TextStyle(fontSize: 25)),
        ),
        icon: const Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Icon(Icons.send, size: 25),
        ),
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40),
        )));
  }

//クリア時のポップアップ
  void showFirstClearDialog() {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: const Text("タマゴの部屋クリア!!",
                style: TextStyle(fontSize: 60, fontWeight: FontWeight.w600)),
            content: const SizedBox(
              width: 200,
              height: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text("次の部屋へ進んでください\n逆走禁止:絶対にこの部屋へ戻らないでください。")],
              ),
            ),
            actions: <Widget>[
              // ボタン領域
              TextButton(
                  child: const Text("次へ"),
                  onPressed: () {
                    setState(() {
                      room = 2;
                    });
                    Navigator.of(context).pop();
                  })
            ],
          );
        });
  }

  void showSecondClearDialog() {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: const Text("野菜室クリア!!",
                style: TextStyle(fontSize: 60, fontWeight: FontWeight.w600)),
            content: const SizedBox(
              width: 200,
              height: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("この先は二組に分かれて進んでください",
                      style:
                          TextStyle(fontSize: 40, fontWeight: FontWeight.w600)),
                  Text("こびとAはAの部屋へ、こびとBはBの部屋へ進んでください"),
                ],
              ),
            ),
            actions: <Widget>[
              // ボタン領域
              TextButton(
                  child: const Text("Aへ進む"),
                  onPressed: () {
                    setState(() {
                      room = 3;
                    });
                    Navigator.of(context).pop();
                  }),
              TextButton(
                  child: const Text("Bへ進む"),
                  onPressed: () {
                    setState(() {
                      room = 3;
                    });
                    Navigator.of(context).pop();
                  })
            ],
          );
        });
  }

  void showThirdClearDialog() {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: const Text("調理室クリア!!",
                style: TextStyle(fontSize: 60, fontWeight: FontWeight.w600)),
            content: const SizedBox(
              width: 200,
              height: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("もう一方の部屋にいる仲間に次の部屋へ進むよう指示してください。"),
                  Text("次の部屋へ進んでください\n逆走禁止:絶対にこの部屋へ戻らないでください。")
                ],
              ),
            ),
            actions: <Widget>[
              // ボタン領域
              TextButton(
                  child: const Text("次へ"),
                  onPressed: () {
                    setState(() {
                      room = 4;
                    });
                    Navigator.of(context).pop();
                    showReadStoryDialog();
                  }),
            ],
          );
        });
  }

  List<Widget> optionsToSend() {
    List<Widget> result = [];

    for (int i = 0; i < objectInventory.length; i++) {
      result.add(IconButton(
        onPressed: () {
          //send
          canSend = false;

          objectInventoryNotifier.removeAt(i);
          widgetInventoryNotifier.removeAt(i);
          displayInventoryNotifier.removeAt(i);
          displayInventoryNotifier.add(Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(inventoryImgPath), fit: BoxFit.cover)),
          ));
          Navigator.of(context).pop();
          //QRcode表示
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text("送信用QRコード"),
              content: SizedBox(
                width: 300,
                height: 300,
                child: QrImageView(
                  data: objectInventory[i].password,
                  version: QrVersions.auto,
                  size: 200.0,
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text("閉じる"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ),
          );
        },
        icon: widgetInventory[i],
        iconSize: 150,
      ));
    }
    return result;
  }

//room4a
  void showReadStoryDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return AlertDialog(
              title: const Text("指示"),
              content: const Text("壁の新聞を読んでください"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      showDecisionDialog();
                    },
                    child: const Text("終わった"))
              ]);
        });
  }

  void showDecisionDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return AlertDialog(
              title: const Text("選択"),
              content: const Text("どちらのこびとを食材にしますか?"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      showWaitDialog();
                      decision = "a";
                    },
                    child: const Text("こびとA")),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      showWaitDialog();
                      decision = "b";
                    },
                    child: const Text("こびとB"))
              ]);
        });
  } //次の部屋にargumentとして残してもいいかも

  void showWaitDialog() {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
              title: const Text("次の部屋に進んでください"),
              content: const Text("南京錠は相方の鍵と同じ番号で開けられます"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      showDecisionDialog();
                    },
                    child: const Text("OK"))
              ]);
        });
  }

  void onReadEndingQR(String ans) {
    if (ans == "moveToQuestion") {
      Navigator.of(context)
          .pushNamed(EndingScreen.routeName, arguments: decision);
    }
  }

  //room4b
  void onReadQuestionQR(String ans) {
    if (ans == "moveToQuestion") {
      Navigator.of(context).pushNamed(Room4bScreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    colors = Theme.of(context).colorScheme;
    startRoom =
        (ModalRoute.of(context)!.settings.arguments as HomeScreenArguments)
            .room;
    if (isInit) {
      room = startRoom;
      isInit = false;
    }

    return Scaffold(
      appBar: MainAppbar(room: room),
      drawer: const MainDrawer(),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(RoomData.roomData(room)!.imgPath),
                fit: BoxFit.cover)),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                children: [
                  SizedBox(
                      height: 180,
                      child: Wrap(
                          runAlignment: WrapAlignment.center,
                          children: displayInventory)),
                  const SizedBox(height: 10),
                  SizedBox(
                      height: 180,
                      child: Wrap(
                          runAlignment: WrapAlignment.center,
                          children: completeWidgetInventory)),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.lightBlue.shade300,
                ),
                child:
                    (room == 3) ? _buildResetButton() : _buildTrashBoxButton(),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  scan().then((value) => pick(value));
                },
                icon: const Padding(
                  padding: EdgeInsets.only(left: 18.0),
                  child: Icon(Icons.qr_code, size: 30),
                ),
                label: const Padding(
                  padding: EdgeInsets.all(18.0),
                  child: Text(
                    ' 行動 ',
                    style: TextStyle(fontSize: 30),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(60),
                    ),
                    elevation: 13),
              ),
              const SizedBox(height: 20),
              Visibility(
                visible: room == 3,
                child: _buildSendButton(),
              )
            ],
          ),
        ),
      ),
    );
  }
}