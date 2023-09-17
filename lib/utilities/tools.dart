import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:refrigerator/utilities/ingredients.dart';
import 'dart:math' as math;
import 'package:refrigerator/utilities/RGB.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import "package:refrigerator/provider/tool_provider.dart";

class Tools {
  Tools(
      {required this.password,
      required this.capacity,
      required this.image,
      required this.actionName});

  String password;
  String image;
  List<int> capacity;
  String actionName;
  String inventoryImgPath = "assets/images/inventory_tile.png";

  void showSelectItemsDialog(String ans, Function onSelected, WidgetRef ref,
      [Ingredient? correctOutput,
      List<Ingredient>? incorrectOutputs,
      List<Ingredient>? correctIngredients,
      Function? onPopupConfirmed]) {
    List<Ingredient> selectedIngredients = [];
    List<int> selectedItems = [];
    List<Widget> widgetInventory = ref.watch(widgetInventoryProvider);
    List<Ingredient> objectInventory = ref.read(objectInventoryProvider);
    List<Widget> displayInventory = ref.read(displayInventoryProvider);
    BuildContext? context = ref.read(mainContextProvider);
    List<int> tags = List.generate(widgetInventory.length, (index) => index);

    if (ans == password) {
      showDialog(
          context: context!,
          builder: (_) {
            return StatefulBuilder(builder: (context, StateSetter setState) {
              return AlertDialog(
                title: Text("$actionNameするアイテムを選択"),
                content: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(image),
                      Wrap(
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
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(32)),
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
                    ]),
                actions: <Widget>[
                  TextButton(
                    onPressed: (capacity.contains(selectedItems.length))
                        ? () {
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();

                            for (int i = selectedItems.length - 1;
                                i >= 0;
                                i--) {
                              selectedIngredients.add(objectInventory[tags[i]]);
                              objectInventory.removeAt(tags[i]);
                              widgetInventory.removeAt(tags[i]);
                              displayInventory.removeAt(tags[i]);
                              displayInventory.add(Container(
                                width: 180,
                                height: 180,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(inventoryImgPath),
                                        fit: BoxFit.cover)),
                              ));
                              //更新
                              ref
                                  .read(widgetInventoryProvider.notifier)
                                  .updateList(widgetInventory);
                              ref
                                  .read(objectInventoryProvider.notifier)
                                  .updateList(objectInventory);
                              ref
                                  .read(displayInventoryProvider.notifier)
                                  .updateList(displayInventory);
                              if (correctOutput != null) {
                                onSelected(
                                    correctOutput,
                                    incorrectOutputs,
                                    correctIngredients,
                                    selectedIngredients,
                                    onPopupConfirmed,
                                    ref);
                              } else {
                                onSelected(selectedIngredients, ref);
                              }
                            }
                          }
                        : null,
                    child: Text(actionName),
                  )
                ],
              );
            });
          });
    }
  }

  void useCompleteMixer(
      Ingredient correctOutput,
      List<Ingredient> incorrectOutputs,
      List<Ingredient> correctIngredients,
      List<Ingredient> selectedIngredients,
      Function? onPopupConfirmed,
      WidgetRef ref) {
    //mix
    correctIngredients.sort(((a, b) => a.name.compareTo(b.name)));
    selectedIngredients.sort(((a, b) => a.name.compareTo(b.name)));

    //正解時
    if (listEquals(correctIngredients, selectedIngredients)) {
      correctOutput.addToCompleteInventory(ref);

      if (onPopupConfirmed != null) {
        onPopupConfirmed();
      } else {
        int randomNum = math.Random().nextInt(3);
        switch (randomNum) {
          //明らかに外れなものを入れる
          case 0:
            break;
          case 1:
            break;
          case 2:
            break;
        }
      }
    }
  }

  void useLightMixer(List<Ingredient> selectedIngredients, WidgetRef ref) {
    ///mix
    late Ingredient mixedLiquid;
    if (selectedIngredients.length == 2) {
      if (selectedIngredients[0].rgb != null &&
          selectedIngredients[1].rgb != null) {
        RGB rgb1 = selectedIngredients[0].rgb!;
        RGB rgb2 = selectedIngredients[1].rgb!;
        if (rgb1.sum == 1 && rgb2.sum == 1) {
          mixedLiquid = rgb1.mixLight(rgb2).liquid;
          mixedLiquid.addToInventory(ref);
        }
      } else {
        print("液体しか投入できません");
      }
    }
    if (selectedIngredients.length == 3) {
      if (selectedIngredients[0].rgb != null &&
          selectedIngredients[1].rgb != null &&
          selectedIngredients[2].rgb != null) {
        RGB rgb1 = selectedIngredients[0].rgb!;
        RGB rgb2 = selectedIngredients[1].rgb!;
        RGB rgb3 = selectedIngredients[2].rgb!;
        if (rgb1.sum + rgb2.sum + rgb3.sum == 3) {
          mixedLiquid = RGB(1, 1, 1).liquid;
          mixedLiquid.addToInventory(ref);
        }
      }
    }
  }

  void useLightSeparator(List<Ingredient> selectedIngredients, WidgetRef ref) {
    //separate

    if (selectedIngredients[0].rgb != null) {
      if (selectedIngredients[0].rgb!.sum == 2) {
        RGB rgb1 = selectedIngredients[0].rgb!;
        List<Ingredient> separatedLiquid = rgb1.separateLight();
        for (Ingredient liquid in separatedLiquid) {
          liquid.addToInventory(ref);
        }
      }
    }
  }

  void useColorMixer(List<Ingredient> selectedIngredients, WidgetRef ref) {
    ///mix
    late Ingredient mixedLiquid;

    ///二色混合
    if (selectedIngredients.length == 2) {
      if (selectedIngredients[0].rgb != null &&
          selectedIngredients[1].rgb != null) {
        RGB rgb1 = selectedIngredients[0].rgb!;
        RGB rgb2 = selectedIngredients[1].rgb!;

        mixedLiquid = rgb1.mixLight(rgb2).liquid;
        mixedLiquid.addToInventory(ref);
      } else {
        print("液体しか投入できません");
      }
    }

    ///3色混合
    if (selectedIngredients.length == 3) {
      if (selectedIngredients[0].rgb != null &&
          selectedIngredients[1].rgb != null &&
          selectedIngredients[2].rgb != null) {
        mixedLiquid = RGB(0, 0, 0).liquid;
        mixedLiquid.addToInventory(ref);
      } else {
        print("液体しか投入できません");
      }
    }
  }

  void useColorSeparator(List<Ingredient> selectedIngredients, WidgetRef ref) {
    ///separate
    if (selectedIngredients[0].rgb != null) {
      if (selectedIngredients[0].rgb!.sum == 1) {
        RGB rgb1 = selectedIngredients[0].rgb!;
        List<Ingredient> separatedLiquid = rgb1.separateColor();
        for (Ingredient liquid in separatedLiquid) {
          liquid.addToInventory(ref);
        }
      }
    }
  }
}
