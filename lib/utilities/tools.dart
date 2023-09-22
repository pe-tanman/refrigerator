import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:refrigerator/utilities/ingredients.dart';
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
  String inventoryImgPath = "images/background/inventory_tile.png";

  bool showSelectItemsDialog(String ans, Function onSelected, WidgetRef ref,
      [Ingredient? correctOutput,
      Ingredient? incorrectOutput,
      List<Ingredient>? correctIngredients,
      Function? onPopupConfirmed,
      Function? showIncorrectDialog]) {
    List<Ingredient> selectedIngredients = [];
    List<int> selectedItems = [];
    List<Widget> widgetInventory = ref.watch(widgetInventoryProvider);
    List<Ingredient> objectInventory = ref.read(objectInventoryProvider);
    var objectInventoryNotifier = ref.watch(objectInventoryProvider.notifier);
    var widgetInventoryNotifier = ref.watch(widgetInventoryProvider.notifier);
    var recognitionNotifier = ref.watch(recognitionProvider.notifier);
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
                      SizedBox(
                          width: 100, height: 100, child: Image.asset(image)),
                      const Divider(),
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

                            for (int i = selectedItems.length - 1;
                                i >= 0;
                                i--) {
                              print("tag" + selectedItems[i].toString());
                              selectedIngredients
                                  .add(objectInventory[selectedItems[i]]);
                              objectInventoryNotifier
                                  .removeAt(selectedItems[i]);
                              widgetInventoryNotifier
                                  .removeAt(selectedItems[i]);
                            }
                            //更新
                            recognitionNotifier.increment();

                            if (showIncorrectDialog != null) {
                              if (onPopupConfirmed != null) {
                                onSelected(
                                    correctOutput,
                                    incorrectOutput,
                                    correctIngredients,
                                    selectedIngredients,
                                    onPopupConfirmed,
                                    showIncorrectDialog,
                                    ref);
                              } else {
                                onSelected(selectedIngredients,
                                    showIncorrectDialog, ref);
                              }
                            } else {
                              onSelected(correctIngredients,
                                  selectedIngredients, onPopupConfirmed, ref);
                            }
                          }
                        : null,
                    child: Text(actionName),
                  )
                ],
              );
            });
          });
      return true;
    }
    return false;
  }

  void useKeyhole(
      List<Ingredient> correctIngredients,
      List<Ingredient> selectedIngredients,
      Function? onPopupConfirmed,
      WidgetRef ref) {
    //mix
    correctIngredients.sort(((a, b) => a.name.compareTo(b.name)));
    selectedIngredients.sort(((a, b) => a.name.compareTo(b.name)));

    //正解時
    if (listEquals(correctIngredients, selectedIngredients)) {
      if (onPopupConfirmed != null) {
        onPopupConfirmed();
      }
    }
  }

  void useCompleteMixer(
      Ingredient correctOutput,
      Ingredient incorrectOutput,
      List<Ingredient> correctIngredients,
      List<Ingredient> selectedIngredients,
      Function? onPopupConfirmed,
      Function? showIncorrectDialog,
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
        incorrectOutput.addToInventory(ref);
        if (showIncorrectDialog != null) {
          showIncorrectDialog();
        }
      }
    }
  }

  void useLightMixer(
    List<Ingredient> selectedIngredients,
    Function? showIncorrectDialog,
    WidgetRef ref,
  ) {
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
          return;
        }
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
          return;
        }
      }
      if (showIncorrectDialog != null) {
        showIncorrectDialog();
      }
    }
    if (showIncorrectDialog != null) {
      showIncorrectDialog();
    }
  }

  void useLightSeparator(
    List<Ingredient> selectedIngredients,
    Function? showIncorrectDialog,
    WidgetRef ref,
  ) {
    //separate
    if (ref.read(objectInventoryProvider).length <
            4 - selectedIngredients.length &&
        selectedIngredients[0].rgb != null) {
      if (selectedIngredients[0].rgb!.sum == 2) {
        RGB rgb1 = selectedIngredients[0].rgb!;
        List<Ingredient> separatedLiquid = rgb1.separateLight();
        for (Ingredient liquid in separatedLiquid) {
          liquid.addToInventory(ref);
        }
        return;
      }
    }
    if (showIncorrectDialog != null) {
      showIncorrectDialog();
    }
  }

  void useColorMixer(
    List<Ingredient> selectedIngredients,
    Function? showIncorrectDialog,
    WidgetRef ref,
  ) {
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
        return;
      }
    }

    ///3色混合
    if (selectedIngredients.length == 3) {
      if (selectedIngredients[0].rgb != null &&
          selectedIngredients[1].rgb != null &&
          selectedIngredients[2].rgb != null) {
        mixedLiquid = RGB(0, 0, 0).liquid;
        mixedLiquid.addToInventory(ref);
        return;
      }
    }
    if (showIncorrectDialog != null) {
      showIncorrectDialog();
    }
  }

  void useColorSeparator(List<Ingredient> selectedIngredients,
      Function? showIncorrectDialog, WidgetRef ref) {
    ///separate
    if (ref.read(objectInventoryProvider).length <
            4 - selectedIngredients.length &&
        selectedIngredients[0].rgb != null) {
      if (selectedIngredients[0].rgb!.sum == 1) {
        RGB rgb1 = selectedIngredients[0].rgb!;
        List<Ingredient> separatedLiquid = rgb1.separateColor();
        for (Ingredient liquid in separatedLiquid) {
          liquid.addToInventory(ref);
        }
        return;
      }
    }
    if (showIncorrectDialog != null) {
      showIncorrectDialog();
    }
  }
}
