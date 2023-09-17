import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:refrigerator/Screen/room4b_screen.dart';
import 'package:refrigerator/widgets/main_appbar.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import 'package:refrigerator/widgets/main_drawer.dart';
import 'package:refrigerator/Utilities/ingredients.dart';
import 'package:refrigerator/Utilities/tools.dart';
import 'package:refrigerator/Utilities/RGB.dart';
import "package:refrigerator/data/room_data.dart";

class HomeScreenArguments {
  final int room;

  HomeScreenArguments({required this.room});
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const routeName = "/home-screen";

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  String result = '';
  bool isInit = true;
  bool isCorrect = false;
  bool isSuccessful = false;
  bool canSend = false;
  int room = 1;
  int startRoom = 1;
  String inventoryImgPath = "assets/Image/inventory_tile.png";
  List<Ingredient> objectInventory = [];
  List<Widget> widgetInventory = [];
  List<Widget> displayInventory = [];
  List<Ingredient> completeObjectInventory = [];
  List<Widget> completeWidgetInventory = [];

  late ColorScheme colors;
  String decision = ""; // a or b

  Ingredient egg = Ingredient(
      name: "egg", image: "assets/Image/egg_white.png", password: "egg-9753");
  Ingredient tomato = Ingredient(
      name: "tomato",
      image: "assets/Image/tomato.png",
      password: "tomato-5521");
  Ingredient goldenHimono = Ingredient(
      name: "goldenHimono",
      image: "assets/Image/wasyoku_himono.png",
      password: "himono-0123");
  Ingredient goldenEgg = Ingredient(
      name: "goldenEgg",
      image: "assets/Image/golden_egg.png",
      password: "egg-0123");
  Ingredient goldenLiquid = Ingredient(
      name: "goldenLiquid",
      image: "assets/Image/golden_egg.png",
      password: "liquid-0123");
  Ingredient greenLiquid = RGB(0, 1, 0).liquid;
  Ingredient yellowLiquid = RGB(1, 1, 0).liquid;
  Ingredient redLiquid = RGB(1, 0, 0).liquid;
  Ingredient blackLiquid = RGB(0, 0, 0).liquid;
  Ingredient whiteLiquid = RGB(1, 1, 1).liquid;
  Tools mixer1 =
      Tools(capacity: [2], password: "mixer1-7213", actionName: "混合");
  Tools checker1 =
      Tools(capacity: [1], password: "checker-1263", actionName: "割って確認");
  Tools lightMixer =
      Tools(capacity: [2, 3], password: "lightMixer", actionName: "光の混合");
  Tools lightSeparator =
      Tools(capacity: [1], password: "lightSeparator", actionName: "光の分解");
  Tools colorMixer =
      Tools(capacity: [2, 3], password: "colorMixer", actionName: "色の混合");
  Tools colorSeparator =
      Tools(capacity: [1], password: "colorMixer", actionName: "色の分解");
  Tools blackAndWhiteMixer =
      Tools(capacity: [2], password: "mixer2-7113", actionName: "混合");

  @override
  void initState() {
    super.initState();
    makeInventoryOutline();
    canSend = (startRoom == 1);
  }

  Future<String> scan() async {
    var res = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const SimpleBarcodeScannerPage(),
        ));

    return res as String;
  }

  void pick(String password) {
    switch (room) {
      case 1:
        //インベントリ追加//TODO:egg1,2,3と追加する
        setState(() {
          isSuccessful = egg.addToInventory(
              displayInventory, widgetInventory, objectInventory, password);
          isSuccessful = greenLiquid.addToInventory(
              displayInventory, widgetInventory, objectInventory, password);
          isSuccessful = yellowLiquid.addToInventory(
              displayInventory, widgetInventory, objectInventory, password);
          isSuccessful = redLiquid.addToInventory(
              displayInventory, widgetInventory, objectInventory, password);
        });
        checker1.useCompleteMixer(
            context,
            password,
            goldenEgg,
            [egg],
            objectInventory,
            widgetInventory,
            displayInventory,
            completeObjectInventory,
            completeWidgetInventory,
            showFirstClearDialog);

        if (objectInventory.length < 5 && isSuccessful) {
          showPickedDialog();
          isSuccessful = false;
        } else if (objectInventory.length >= 5) {
          showPickFailedDialog();
        }
        break;

      case 2:
        mixer1.useCompleteMixer(
            context,
            password,
            goldenHimono,
            [tomato, egg],
            objectInventory,
            widgetInventory,
            displayInventory,
            completeObjectInventory,
            completeWidgetInventory,
            showSecondClearDialog);
        isSuccessful = tomato.addToInventory(
            displayInventory, widgetInventory, objectInventory, password);

        if (objectInventory.length < 5 && isSuccessful) {
          showPickedDialog();
          isSuccessful = false;
        } else if (objectInventory.length >= 5) {
          showPickFailedDialog();
        }
        break;

      case 3:
        setState(() {
          isSuccessful = egg.addToInventory(
              displayInventory, widgetInventory, objectInventory, password);
          isSuccessful = greenLiquid.addToInventory(
              displayInventory, widgetInventory, objectInventory, password);
          isSuccessful = yellowLiquid.addToInventory(
              displayInventory, widgetInventory, objectInventory, password);
          isSuccessful = redLiquid.addToInventory(
              displayInventory, widgetInventory, objectInventory, password);
        });
        lightMixer.UseLightMixer(context, password, objectInventory,
            widgetInventory, displayInventory);
        lightSeparator.UseLightSeparator(context, password, objectInventory,
            widgetInventory, displayInventory);
        colorMixer.UseColorMixer(context, password, objectInventory,
            widgetInventory, displayInventory);
        colorSeparator.UseColorSeparator(context, password, objectInventory,
            widgetInventory, displayInventory);
        blackAndWhiteMixer.useCompleteMixer(
            context,
            password,
            goldenLiquid,
            [blackLiquid, whiteLiquid],
            objectInventory,
            widgetInventory,
            displayInventory,
            completeObjectInventory,
            completeWidgetInventory,
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
    setState(() {
      for (int i = 0; i <= 4; i++) {
        displayInventory.add(Container(
          width: 180,
          height: 180,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(inventoryImgPath), fit: BoxFit.cover)),
        ));
        completeWidgetInventory.add(Container(
          width: 180,
          height: 180,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(inventoryImgPath), fit: BoxFit.cover)),
        ));
      }
    });
  }

  void showPickedDialog() {
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
                  widgetInventory[widgetInventory.length - 1],
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
                            showDialog(
                                context: context,
                                builder: (_) {
                                  return AlertDialog(
                                      title: const Text("確認"),
                                      content: const Text("本当に削除してよろしいですか？"),
                                      actions: <Widget>[
                                        TextButton(
                                            child: const Text("OK"),
                                            onPressed: () {
                                              for (int i in tags) {
                                                objectInventory.removeAt(i);
                                                widgetInventory.removeAt(i);
                                                widgetInventory.add(Container(
                                                  width: 150,
                                                  height: 150,
                                                  decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                          image: AssetImage(
                                                              inventoryImgPath),
                                                          fit: BoxFit.cover)),
                                                ));
                                              }
                                              Navigator.of(context).pop();
                                              Navigator.of(context).pop();
                                            }),
                                        TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text("キャンセル"))
                                      ]);
                                });
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
          displayInventory[i] = (Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(inventoryImgPath), fit: BoxFit.cover)),
          ));
        }
        objectInventory.clear();
        widgetInventory.clear();
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
            content: SizedBox(
              width: 200,
              height: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  goldenEgg.inventoryTile(),
                  const Text("次の部屋へ進んでください\n逆走禁止:絶対にこの部屋へ戻らないでください。")
                ],
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

  void onReadQuestionQR(String ans) {
    if (ans == "moveToQuestion") {
      Navigator.of(context).pushNamed(Room4bScreen.routeName);
    }
  }

  List<Widget> optionsToSend() {
    List<Widget> result = [];

    for (int i = 0; i < objectInventory.length; i++) {
      result.add(IconButton(
        onPressed: () {
          //send
          canSend = false;

          objectInventory.removeAt(i);
          widgetInventory.removeAt(i);
          displayInventory.removeAt(i);
          displayInventory.add(Container(
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
                    },
                    child: const Text("こびとA")),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      showWaitDialog();
                    },
                    child: const Text("こびとB"))
              ]);
        });
  }

  void showWaitDialog() {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
              title: const Text("次の部屋に進んでください"),
              content: const Text("この鍵は相方の鍵と同じ番号で開けられます"),
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
    room = startRoom;

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
