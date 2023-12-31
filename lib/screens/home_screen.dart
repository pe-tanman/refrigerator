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
import 'package:audioplayers/audioplayers.dart';

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
  bool isSuccessfulPick = false;
  bool isSuccessfulUse = false;
  bool canSend = false;
  int room = 1;
  int startRoom = 1;
  String inventoryImgPath = "assets/images/background/inventory_tile.png";
  List<Ingredient> objectInventory = [];
  List<Widget> widgetInventory = [];
  List<Widget> displayInventory = [];
  List<Ingredient> completeObjectInventory = [];
  List<Widget> completeWidgetInventory = [];
  int recognition = 0;
  final audioPlayer = AudioPlayer();
  var objectInventoryNotifier;
  var widgetInventoryNotifier;
  var completeObjectInventoryNotifier;
  var completeWidgetInventoryNotifier;
  var roomNotifier;
  var contextNotifier;
  var recognitionNotifier;

  late ColorScheme colors;
  String decision = ""; // a or b

  //room0
  Ingredient key = Ingredient(
      name: "鍵", image: "assets/images/items/key.png", password: "key-5281");
  Tools keyhole = Tools(
      password: "keyhole",
      capacity: [1],
      image: "assets/images/tools/keyhole.png",
      actionName: "解錠");
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
      name: "桃色の卵",
      image: "assets/images/items/pink_egg.png",
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
      name: "雲色の卵",
      image: "assets/images/items/clown_egg.png",
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
      image: "assets/images/tools/bowl.png",
      actionName: "割って確認");
  //room2
  Tools mixer1 = Tools(
      capacity: [3],
      password: "mixer1-7213",
      image: "assets/images/tools/mortar.png",
      actionName: "混合");
  Ingredient correctHimono = Ingredient(
      name: "ときめく粉末",
      image: "assets/images/items/correct_himono.png",
      password: "correct_himono");
  Ingredient incorrectHimono = Ingredient(
      name: "腐った粉末",
      image: "assets/images/items/correct_himono.png",
      password: "incorrect_himono");
  Ingredient monosashiUo = Ingredient(
      name: "mo no sa shi u o",
      image: "assets/images/items/monosashi_uo.png",
      password: "monosashi-uo",
      detail:
          "mo no sa shi u o\nka na ra zu ki ma ttsu ta o o ki sa ni na ru\no to na ni na ru to 5 0 c m ni na ru");
  Ingredient akakiGoi = Ingredient(
      name: "N xn xv tb v",
      image: "assets/images/items/akaki_goi.png",
      password: "akaki-goi");
  Ingredient haburashiModoki = Ingredient(
      name: "Un oh en fuv zb gb xv",
      image: "assets/images/items/haburashi_modoki.png",
      password: "haburashi-modoki");
  Ingredient masanba = Ingredient(
      name: "Zn fu a on",
      image: "assets/images/items/masanba.png",
      password: "masanba");
  Ingredient rizuminori = Ingredient(
      name: "Ev mh zv ab ev",
      image: "assets/images/items/rizuminori.png",
      password: "rizuminori");
  Ingredient medamaDake = Ingredient(
      name: "Zr qn zn qn xr",
      image: "assets/images/items/medama_dake.png",
      password: "medamadake");
  Ingredient akaDama = Ingredient(
      name: "N xn qn zn",
      image: "assets/images/items/aka_dama.png",
      password: "aka-dama");
  Ingredient tomaTomato = Ingredient(
      name: "Gl zn gl zn gl",
      image: "assets/images/items/toma_tomato.png",
      password: "toma-tomato");
  Ingredient shiragaDake = Ingredient(
      name: "Fuv en tn gn xr",
      image: "assets/images/items/shiraga_dake.png",
      password: "shiraga-dake");
  Ingredient kinnoMi = Ingredient(
      name: "Xv a ab zv",
      image: "assets/images/items/kinno_mi.png",
      password: "kinno-mi");
  Ingredient sotennoMi = Ingredient(
      name: "Fb gr a ab zv",
      image: "assets/images/items/sotenno_mi.png",
      password: "sotenno-mi");
  Ingredient tamichi = Ingredient(
      name: "Gn zv gv",
      image: "assets/images/items/tamichi.png",
      password: "tamichi");
  Ingredient hakoBudou = Ingredient(
      name: "Un xb oh qb h",
      image: "assets/images/items/hako_budou.png",
      password: "hako-budou");
//room3
  Ingredient correctLiquid = Ingredient(
      name: "エメラルドの液体",
      image: "assets/images/items/correct_liquid.png",
      password: "liquid-0123");
  Ingredient incorrectLiquid = Ingredient(
      name: "腐った液体",
      image: "assets/images/items/incorrect_liquid.png",
      password: "liquid-4928");
  Ingredient redLiquid = RGB(1, 0, 0).liquid;
  Ingredient greenLiquid = RGB(0, 1, 0).liquid;
  Ingredient blueLiquid = RGB(0, 0, 1).liquid;
  Ingredient yellowLiquid = RGB(1, 1, 0).liquid;
  Ingredient magentaLiquid = RGB(1, 0, 1).liquid;
  Ingredient cyanLiquid = RGB(0, 1, 1).liquid;
  Ingredient blackLiquid = RGB(0, 0, 0).liquid;
  Ingredient whiteLiquid = RGB(1, 1, 1).liquid;

  Tools lightMixer = Tools(
      capacity: [3],
      password: "lightMixer",
      image: "assets/images/tools/mixer.jpg",
      actionName: "光の混合");
  Tools lightSeparator = Tools(
      capacity: [1],
      password: "lightSeparator",
      image: "assets/images/tools/separator.jpg",
      actionName: "光の分解");
  Tools colorMixer = Tools(
      capacity: [3],
      password: "colorMixer",
      image: "assets/images/tools/mixer.jpg",
      actionName: "色の混合");
  Tools colorSeparator = Tools(
      capacity: [1],
      password: "colorSeparator",
      image: "assets/images/tools/separator.jpg",
      actionName: "色の分解");
  Tools blackAndWhiteMixer = Tools(
      capacity: [2],
      password: "mixer2-7113",
      image: "assets/images/tools/mixer.jpg",
      actionName: "混合");

  //room 4 image
  Ingredient eye = Ingredient(
      name: "こびとの眼球", image: "assets/images/items/eye.png", password: "eye");

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      objectInventoryNotifier = ref.watch(objectInventoryProvider.notifier);
      widgetInventoryNotifier = ref.watch(widgetInventoryProvider.notifier);
      completeObjectInventoryNotifier =
          ref.watch(completeObjectInventoryProvider.notifier);
      completeWidgetInventoryNotifier =
          ref.watch(completeWidgetInventoryProvider.notifier);
      roomNotifier = ref.watch(roomProvider.notifier);
      contextNotifier = ref.watch(mainContextProvider.notifier);
      recognitionNotifier = ref.watch(recognitionProvider.notifier);
      objectInventory = ref.watch(objectInventoryProvider);
      widgetInventory = ref.watch(widgetInventoryProvider);
      //displayInventory = ref.watch(displayInventoryProvider);
      completeWidgetInventory = ref.watch(completeWidgetInventoryProvider);
      completeObjectInventory = ref.watch(completeObjectInventoryProvider);
      room = ref.watch(roomProvider);
      recognition = ref.watch(recognitionProvider);
      makeInitInventoryOutline();
      roomNotifier.setRoom(startRoom);

      canSend = (startRoom == 0);
    });
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
    switch (ref.watch(roomProvider)) {
      case 0:
        setState(() {
          isSuccessfulPick = key.addToInventory(ref, password);
        });
        isSuccessfulUse = keyhole.showSelectItemsDialog(
            password,
            keyhole.useKeyhole,
            ref,
            null,
            null,
            [key],
            showTutorialClearDialog);
        if (isSuccessfulPick) {
          showPickedDialog();
          isSuccessfulPick = false;
        } else if (isSuccessfulUse) {
          isSuccessfulUse = false;
        } else {
          showPickFailedDialog();
        }
        break;
      case 1:
        setState(() {
          isSuccessfulPick = (redEgg.addToInventory(ref, password) ||
              greenEgg.addToInventory(ref, password) ||
              purpleEgg.addToInventory(ref, password) ||
              yellowEgg.addToInventory(ref, password) ||
              blackEgg.addToInventory(ref, password) ||
              blueEgg.addToInventory(ref, password) ||
              brownEgg.addToInventory(ref, password));
        });
        isSuccessfulUse = checker1.showSelectItemsDialog(
            password,
            checker1.useCompleteMixer,
            ref,
            correctCrashedEgg,
            incorrectCrashedEgg,
            [yellowEgg],
            showFirstClearDialog,
            showUseFailedDialog);

        if (isSuccessfulPick) {
          showPickedDialog();
          isSuccessfulPick = false;
        } else if (isSuccessfulUse) {
          isSuccessfulUse = false;
        } else {
          showPickFailedDialog();
        }
        break;

      case 2:
        setState(() {
          isSuccessfulPick = monosashiUo.addToInventory(ref, password) ||
              haburashiModoki.addToInventory(ref, password) ||
              rizuminori.addToInventory(ref, password) ||
              masanba.addToInventory(ref, password) ||
              akakiGoi.addToInventory(ref, password) ||
              shiragaDake.addToInventory(ref, password) ||
              tomaTomato.addToInventory(ref, password) ||
              akaDama.addToInventory(ref, password) ||
              medamaDake.addToInventory(ref, password) ||
              tamichi.addToInventory(ref, password) ||
              kinnoMi.addToInventory(ref, password) ||
              hakoBudou.addToInventory(ref, password) ||
              sotennoMi.addToInventory(ref, password);
        });
        isSuccessfulUse = mixer1.showSelectItemsDialog(
            password,
            mixer1.useCompleteMixer,
            ref,
            correctHimono,
            incorrectHimono,
            [masanba, tomaTomato, kinnoMi],
            showSecondClearDialog,
            showUseFailedDialog);

        if (isSuccessfulPick) {
          showPickedDialog();
          isSuccessfulPick = false;
        } else if (isSuccessfulUse) {
          isSuccessfulUse = false;
        } else {
          showPickFailedDialog();
        }
        break;

      case 3:
        setState(() {
          isSuccessfulPick = (greenLiquid.addToInventory(ref, password) ||
              yellowLiquid.addToInventory(ref, password) ||
              redLiquid.addToInventory(ref, password) ||
              blueLiquid.addToInventory(ref, password) ||
              cyanLiquid.addToInventory(ref, password) ||
              magentaLiquid.addToInventory(ref, password) ||
              whiteLiquid.addToInventory(ref, password) ||
              blackLiquid.addToInventory(ref, password));
        });

        isSuccessfulUse = lightMixer.showSelectItemsDialog(
                password,
                lightMixer.useLightMixer,
                ref,
                null,
                null,
                null,
                null,
                showUseFailedDialog) ||
            lightSeparator.showSelectItemsDialog(
                password,
                lightSeparator.useLightSeparator,
                ref,
                null,
                null,
                null,
                null,
                showUseFailedDialog) ||
            lightMixer.showSelectItemsDialog(
                password,
                colorSeparator.useColorSeparator,
                ref,
                null,
                null,
                null,
                null,
                showUseFailedDialog) ||
            colorMixer.showSelectItemsDialog(password, colorMixer.useColorMixer,
                ref, null, null, null, null, showUseFailedDialog) ||
            colorSeparator.showSelectItemsDialog(
                password,
                colorSeparator.useColorSeparator,
                ref,
                null,
                null,
                null,
                null,
                showUseFailedDialog) ||
            blackAndWhiteMixer.showSelectItemsDialog(
                password,
                blackAndWhiteMixer.useBlackAndWhiteMixer,
                ref,
                correctLiquid,
                incorrectLiquid,
                [blackLiquid, whiteLiquid],
                showThirdClearDialog,
                showUseFailedDialog) ||
            onReadQuestionQR(password) ||
            onReadMoveQR(password);

        if (isSuccessfulPick) {
          //受け取ったときの処理
          canSend = true;
          showPickedDialog();
          isSuccessfulPick = false;
        } else if (isSuccessfulUse) {
          isSuccessfulUse = false;
        } else {
          showPickFailedDialog();
        }
        break;
      case 6:
        onReadEndingQR(password);
        break;
    }
  }

  void makeInventoryOutline() {
    List<Widget> display = [];
    for (int j = 0; j < widgetInventory.length; j++) {
      display.add(Container(
        width: 180,
        height: 180,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(inventoryImgPath), fit: BoxFit.cover)),
        child: widgetInventory[j],
      ));
    }

    for (int i = 0; i <= 3 - widgetInventory.length; i++) {
      display.add(Container(
        width: 180,
        height: 180,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(inventoryImgPath), fit: BoxFit.cover)),
      ));
    }
    displayInventory = display;
    setState(() {});
  }

  void makeInitInventoryOutline() {
    for (int i = 0; i <= 3; i++) {
      displayInventory.add(Container(
        width: 180,
        height: 180,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(inventoryImgPath), fit: BoxFit.cover)),
      ));
    }
    completeWidgetInventoryNotifier.clear();
    for (int i = 0; i <= 3; i++) {
      completeWidgetInventory.add(Container(
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
            title: const Center(
              child: Text("GET",
                  style: TextStyle(fontSize: 60, fontWeight: FontWeight.w600)),
            ),
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
                  Text("正しくないQRコードを読み込みました。"),
                  Text(
                    "違う部屋のQRコードやすでに持っているアイテムのQRコードを読み込んだ、またはインベントリが満タンであることが考えられます。",
                    style: TextStyle(fontSize: 12),
                  ),
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

  void showUseFailedDialog() {
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
                  Text("正しくないアイテムを投入しました。"),
                  Text(
                    "問題や指示に従って投入してください。",
                    style: TextStyle(fontSize: 12),
                  ),
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
              return StatefulBuilder(builder: (context, StateSetter setState) {
                return AlertDialog(
                  title: const Text("消去するアイテムを選択"),
                  content: Wrap(
                    runSpacing: 16,
                    spacing: 16,
                    children: tags.map((tag) {
                      // selectedTags の中に自分がいるかを確かめる
                      bool isSelected = selectedItems.contains(tag);
                      return InkWell(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(32)),
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
                                color: isSelected
                                    ? Colors.lightBlue
                                    : Colors.white,
                              ),
                              color: isSelected ? Colors.lightBlue : null,
                            ),
                            child: (widgetInventory.isNotEmpty)
                                ? widgetInventory[tag]
                                : Container()),
                      );
                    }).toList(),
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: (selectedItems.isNotEmpty)
                          ? () {
                              for (int i = selectedItems.length - 1;
                                  i >= 0;
                                  i--) {
                                objectInventoryNotifier.removeAt(tags[i]);
                                widgetInventoryNotifier.removeAt(tags[i]);
                              }
                              recognitionNotifier.increment();
                              Navigator.of(context).pop();
                            }
                          : null,
                      child: const Text("削除"),
                    )
                  ],
                );
              });
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
        objectInventoryNotifier.clear();
        widgetInventoryNotifier.clear();
        recognitionNotifier.increment();
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
              barrierDismissible: false,
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
  void showTutorialClearDialog() {
    audioPlayer.play(AssetSource("clear_audio.mp3"));
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: 200,
                  height: 300,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(
                            'assets/images/background/clear_background.jpg'),
                        fit: BoxFit.fill),
                  ),
                ),
              ),
              AlertDialog(
                title: const Text("チュートリアルクリア!!",
                    style:
                        TextStyle(fontSize: 60, fontWeight: FontWeight.w600)),
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
                        ref.read(roomProvider.notifier).increment();
                        audioPlayer.stop();
                        Navigator.of(context).pop();
                      })
                ],
              ),
            ],
          );
        });
  }

  void showFirstClearDialog() {
    audioPlayer.play(AssetSource("clear_audio.mp3"));
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(
                            'assets/images/background/clear_background.jpg'),
                        fit: BoxFit.fill),
                  ),
                ),
              ),
              AlertDialog(
                title: const Text("1の部屋クリア!!",
                    style:
                        TextStyle(fontSize: 60, fontWeight: FontWeight.w600)),
                content: SizedBox(
                  width: 200,
                  height: 300,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      correctCrashedEgg.inventoryTile(),
                      const Text("次の部屋へ進んでください\n逆走禁止:絶対にこの部屋へ戻らないでください。")
                    ],
                  ),
                ),
                actions: <Widget>[
                  // ボタン領域
                  TextButton(
                      child: const Text("次へ"),
                      onPressed: () {
                        audioPlayer.stop();
                        ref.read(roomProvider.notifier).increment();
                        Navigator.of(context).pop();
                      })
                ],
              )
            ],
          );
        });
  }

  void showSecondClearDialog() {
    audioPlayer.play(AssetSource("clear_audio.mp3"));
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(
                            'assets/images/background/clear_background.jpg'),
                        fit: BoxFit.fill),
                  ),
                ),
              ),
              AlertDialog(
                title: const Text("2の部屋クリア!!",
                    style:
                        TextStyle(fontSize: 60, fontWeight: FontWeight.w600)),
                content: SizedBox(
                  width: 200,
                  height: 300,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      correctHimono.inventoryTile(),
                      const Text("この先は二組に分かれて進んでください",
                          style: TextStyle(
                              fontSize: 40, fontWeight: FontWeight.w600)),
                      (startRoom == 0)
                          ? const Text("Aの部屋に進んでください")
                          : const Text("Bの部屋に進んでください")
                    ],
                  ),
                ),
                actions: <Widget>[
                  // ボタン領域
                  TextButton(
                      child: const Text("OK"),
                      onPressed: () {
                        audioPlayer.stop();
                        ref.read(roomProvider.notifier).increment();
                        Navigator.of(context).pop();
                      }),
                ],
              )
            ],
          );
        });
  }

  void showThirdClearDialog() {
    audioPlayer.play(AssetSource("clear_audio.mp3"));
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(
                            'assets/images/background/clear_background.jpg'),
                        fit: BoxFit.fill),
                  ),
                ),
              ),
              AlertDialog(
                title: const Text("3の部屋クリア!!",
                    style:
                        TextStyle(fontSize: 60, fontWeight: FontWeight.w600)),
                content: SizedBox(
                  width: 200,
                  height: 300,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      correctLiquid.inventoryTile(),
                      const Text(
                          "もう一方の部屋にいる仲間に次の部屋へ進むよう指示してください。\n鍵の番号は両方471です。"),
                      const Text("次の部屋へ進んでください\n逆走禁止:絶対にこの部屋へ戻らないでください。")
                    ],
                  ),
                ),
                actions: <Widget>[
                  // ボタン領域
                  TextButton(
                      child: const Text("次へ"),
                      onPressed: () {
                        audioPlayer.stop();
                        setState(() {
                          ref.read(roomProvider.notifier).increment();
                        });
                        Navigator.of(context).pop();
                        showReadStoryDialog();
                      }),
                ],
              )
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

          Navigator.of(context).pop();
          //QRcode表示
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (_) => AlertDialog(
              backgroundColor: Colors.white,
              title: const Text("送信用QRコード"),
              content: SizedBox(
                width: 150,
                height: 150,
                child: QrImageView(
                  data: objectInventory[i].password,
                  version: QrVersions.auto,
                  size: 100.0,
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text("閉じる"),
                  onPressed: () {
                    objectInventoryNotifier.removeAt(i);
                    widgetInventoryNotifier.removeAt(i);
                    recognitionNotifier.increment();
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
              content: const SizedBox(
                  width: 700,
                  height: 500,
                  child: Center(child: Text("どちらのこびとを食材にしますか?"))),
              actions: [
                TextButton(
                    onPressed: () {
                      showDecisionConfirmDialog("こびとNo.37(自分)", "a");
                    },
                    child: const Text("こびとNo.37(自分)")),
                TextButton(
                    onPressed: () {
                      showDecisionConfirmDialog("こびとNo.547(相手)", "b");
                    },
                    child: const Text("こびとNo.547(相手)"))
              ]);
        });
  } //次

  void showDecisionConfirmDialog(String message, String localDecision) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: const Text("確認"),
            content: Text("本当に$messageを食材にしますか?"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("キャンセル"),
              ),
              TextButton(
                onPressed: () {
                  eye.addToCompleteInventory(ref);
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  showWaitDialog();
                  decision = localDecision;
                },
                child: const Text("OK"),
              ),
            ],
          );
        });
  } // の部屋にargumentとして残してもいいかも

  void showWaitDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return AlertDialog(
              title: const Text("次の部屋に進んでください"),
              content: const Text("南京錠は相方の鍵と同じ番号で開けられます"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      ref.read(roomProvider.notifier).increment();
                      ref.read(roomProvider.notifier).increment();
                    },
                    child: const Text("OK"))
              ]);
        });
  }

  void onReadEndingQR(String ans) {
    if (ans == "moveToEnding") {
      Navigator.of(context).pushNamed(EndingScreen.routeName,
          arguments: EndingScreenArguments(decision: decision));
    }
  }

  bool onReadMoveQR(String ans) {
    if (ans == "moveTo4") {
      correctLiquid.addToCompleteInventory(ref);
      showThirdClearDialog();
      return true;
    }
    return false;
  }

  //room4b
  bool onReadQuestionQR(String ans) {
    if (ans == "moveToQuestion") {
      ref.read(roomProvider.notifier).increment();
      ref.read(roomProvider.notifier).increment();
      Navigator.of(context).pushNamed(Room4bScreen.routeName);
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    colors = Theme.of(context).colorScheme;
    startRoom =
        (ModalRoute.of(context)!.settings.arguments as HomeScreenArguments)
            .room;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isInit) {
        ref.read(mainContextProvider.notifier).setContext(context);
        ref.read(roomProvider.notifier).setRoom(startRoom);
        isInit = false;
      }
    });
    ref.listen(recognitionProvider, (previous, next) {
      makeInventoryOutline();
    });
    ref.listen(roomProvider, (previous, next) {
      setState(() {});
    });
    return Scaffold(
      appBar: const MainAppbar(),
      drawer: const MainDrawer(),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                    RoomData.roomData(ref.watch(roomProvider))!.imgPath),
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
                child: (ref.watch(roomProvider) == 3)
                    ? _buildResetButton()
                    : _buildTrashBoxButton(),
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
                visible: ref.watch(roomProvider) == 3,
                child: _buildSendButton(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
