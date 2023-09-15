import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import 'package:refrigerator/Screen/endingA_screen.dart';
import 'package:refrigerator/Screen/endingB_screen.dart';
import 'package:refrigerator/Widget/main_drawer.dart';
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
  static const routeName = "/Home-screen";

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  String result = '';
  bool isInit = true;
  bool isCorrect = false;
  bool isSuccessful = false;
  bool hintAvailable = false;
  bool canSend = false;
  int room = 1;
  int startRoom = 1;
  String inventoryImgPath = "assets/Image/inventory_tile.png";
  String time = "2:00";
  List<Ingredient> objectInventory = [];
  List<Widget> widgetInventory = [];
  List<Widget> displayInventory = [];
  List<Ingredient> completeObjectInventory = [];
  List<Widget> completeWidgetInventory = [];
  List<List<String>> HINTS = [
    ["1-1", "1-2", "1-3"],
    ["2-1", "2-2", "2-3"],
    ["3-1", "3-2", "3-3"],
    ["4-1", "4-2", "4-3"]
  ];
  List<Widget> hintWidgets = [];
  late ColorScheme colors;

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
    StartTimer();
    MakeInventoryOutline();
    canSend = (startRoom == 1);
  }

  Future<void> scanAndPick() async {
    var res = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const SimpleBarcodeScannerPage(),
        ));

    if (res is String) {
      result = res;
      //クリア処理
      switch (room) {
        case 1:
          //インベントリ追加//TODO:egg1,2,3と追加する
          setState(() {
            isSuccessful = egg.addToInventory(
                displayInventory, widgetInventory, objectInventory, res);
            isSuccessful = greenLiquid.addToInventory(
                displayInventory, widgetInventory, objectInventory, res);
            isSuccessful = yellowLiquid.addToInventory(
                displayInventory, widgetInventory, objectInventory, res);
            isSuccessful = redLiquid.addToInventory(
                displayInventory, widgetInventory, objectInventory, res);
          });
          checker1.UseMixer(
              context,
              res,
              goldenEgg,
              [egg],
              objectInventory,
              widgetInventory,
              displayInventory,
              completeObjectInventory,
              completeWidgetInventory,
              ShowClearDialog);

          if (objectInventory.length < 5 && isSuccessful) {
            showDialog(
                context: context,
                builder: (_) {
                  return PickedDialog();
                });
            isSuccessful = false;
          } else if (objectInventory.length >= 5) {
            showDialog(
                context: context,
                builder: (_) {
                  return FailedPickDialog();
                });
          }
          break;

        case 2:
          mixer1.UseMixer(
              context,
              res,
              goldenHimono,
              [tomato, egg],
              objectInventory,
              widgetInventory,
              displayInventory,
              completeObjectInventory,
              completeWidgetInventory,
              ShowClearDialog);
          isSuccessful = tomato.addToInventory(
              displayInventory, widgetInventory, objectInventory, res);

          if (objectInventory.length < 5 && isSuccessful) {
            showDialog(
                context: context,
                builder: (_) {
                  return PickedDialog();
                });
            isSuccessful = false;
          } else if (objectInventory.length >= 5) {
            showDialog(
                context: context,
                builder: (_) {
                  return FailedPickDialog();
                });
          }
          break;

        case 3:
          setState(() {
            isSuccessful = egg.addToInventory(
                displayInventory, widgetInventory, objectInventory, res);
            isSuccessful = greenLiquid.addToInventory(
                displayInventory, widgetInventory, objectInventory, res);
            isSuccessful = yellowLiquid.addToInventory(
                displayInventory, widgetInventory, objectInventory, res);
            isSuccessful = redLiquid.addToInventory(
                displayInventory, widgetInventory, objectInventory, res);
          });
          lightMixer.UseLightMixer(
              context, res, objectInventory, widgetInventory, displayInventory);
          lightSeparator.UseLightSeparator(
              context, res, objectInventory, widgetInventory, displayInventory);
          colorMixer.UseColorMixer(
              context, res, objectInventory, widgetInventory, displayInventory);
          colorSeparator.UseColorSeparator(
              context, res, objectInventory, widgetInventory, displayInventory);
          blackAndWhiteMixer.UseMixer(
              context,
              res,
              goldenLiquid,
              [blackLiquid, whiteLiquid],
              objectInventory,
              widgetInventory,
              displayInventory,
              completeObjectInventory,
              completeWidgetInventory,
              ThirdClearDialog);

          if (objectInventory.length <= 5 && isSuccessful) {
            //受け取ったときの処理
            canSend = true;
            showDialog(
                context: context,
                builder: (_) {
                  return PickedDialog();
                });
            isSuccessful = false;
          } else {
            showDialog(
                context: context,
                builder: (_) {
                  return FailedPickDialog();
                });
          }
          break;
        case 4:
          showDialog(
              context: context,
              builder: (_) {
                return ForthClearDialog();
              });
          break;
        default:
          print("error");
      }
    }
  }

  void MakeInventoryOutline() {
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

  Widget FailedPickDialog() {
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
                        print(selectedItems);
                        print(isSelected);
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
                    child: const Text("削除"),
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

  Widget PickedDialog() {
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
  }

  void ShowClearDialog() {
    switch (room) {
      case 1:
        if (completeObjectInventory.contains(goldenEgg)) {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (_) {
                return FirstClearDialog();
              });
        }
        break;
      case 2:
        if (completeObjectInventory.contains(goldenHimono)) {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (_) {
                return SecondClearDialog();
              });
        }
        break;
      //case3,4も追加
      default:
        break;
    }
  }

//クリア時のポップアップ
  Widget FirstClearDialog() {
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
                hintWidgets = [];
                hintAvailable = false;
                StartTimer();
              });
              StartTimer();
              Navigator.of(context).pop();
            })
      ],
    );
  }

  Widget SecondClearDialog() {
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
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.w600)),
            Text("どちらか片方の端末ではA、もう一方ではBを選択してください。"),
            Text("注意:同じ部屋を選択しないでください\n絶対にこの部屋へ戻らないでください。")
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
                hintAvailable = false;
                hintWidgets = [];
                StartTimer();
              });
              StartTimer();
              Navigator.of(context).pop();
            }),
        TextButton(
            child: const Text("Bへ進む"),
            onPressed: () {
              setState(() {
                room = 3;
                hintAvailable = false;
                hintWidgets = [];
                StartTimer();
              });
              StartTimer();
              Navigator.of(context).pop();
            })
      ],
    );
  }

  Widget ThirdClearDialog() {
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
                hintAvailable = false;
                hintWidgets = [];
                StartTimer();
              });
              StartTimer();
              Navigator.of(context).pop();
            }),
      ],
    );
  }

  Widget ForthClearDialog() {
    return AlertDialog(
      title: const Text("先駆者のメモロードクリア!!",
          style: TextStyle(fontSize: 60, fontWeight: FontWeight.w600)),
      content: const SizedBox(
        width: 200,
        height: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("この選択によってあなたともう一方の小人たちの命が決まる",
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.w600)),
            Text("A, Bのどちらかを選択してください。"),
            Text("注意:選択し直すことはできません\n絶対にこの部屋へ戻らないでください。")
          ],
        ),
      ),
      actions: <Widget>[
        // ボタン領域
        TextButton(
            child: const Text("Aへ進む"),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (_) {
                    return AlertDialog(
                      title: const Text("Aへ進んでください"),
                      actions: <Widget>[
                        TextButton(
                          child: const Text("OK"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    );
                  });
              Navigator.of(context).pushNamed(EndingAScreen.routeName);
            }),
        TextButton(
            child: const Text("Bへ進む"),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (_) {
                    return AlertDialog(
                      title: const Text("Bへ進んでください"),
                      actions: <Widget>[
                        TextButton(
                          child: const Text("OK"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    );
                  });
              Navigator.of(context).pushNamed(EndingBScreen.routeName);
            })
      ],
    );
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

  void AddHint(int hintNum) {
    hintAvailable = true;
    String availableHint = HINTS[room - 1][hintNum - 1];
    hintWidgets.add(Text(
      "ヒント$hintNum:",
      style: const TextStyle(fontWeight: FontWeight.w600),
    ));
    hintWidgets.add(Text(availableHint));
    hintWidgets.add(const Divider());
  }

  void scheduleRebuild() => setState(() {});

  Future StartTimer() async {
    int STARTMIN = 1;
    for (int i = 1; i <= 3; i++) {
      for (int min = STARTMIN - 1; min >= 0; min--) {
        for (int sec = 59; sec >= 0; sec--) {
          if (mounted) {
            setState(() {
              time = (sec >= 10) ? "$min:$sec" : "$min:0$sec";
            });
          }

          await Future.delayed(const Duration(seconds: 1));
        }
      }
      print("hint$i open");
      AddHint(i);
    }
    print("finish");
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
      appBar: AppBar(
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
      ),
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
                  scanAndPick();
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
