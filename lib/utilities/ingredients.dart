import 'package:flutter/material.dart';
import "package:refrigerator/utilities/RGB.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';
import "package:refrigerator/provider/tool_provider.dart";

class Ingredient {
  Ingredient(
      {required this.name,
      required this.image,
      required this.password,
      this.detail,
      this.rgb}) {
    detail ??= "";
  }

  String name;
  String image;
  String password;
  String? detail;
  RGB? rgb;
  String inventoryImgPath = "images/background/inventory_tile.png";

  bool addToInventory(WidgetRef ref, [String? ans]) {
    List<Ingredient> objectInventory = ref.read(objectInventoryProvider);

    if ((ans == null || ans == password) &&
        !objectInventory.contains(this) &&
        objectInventory.length < 4) {
      //なぜか変数にまとめるとだめだった
      ref.read(widgetInventoryProvider.notifier).add(inventoryTile());
      ref.read(objectInventoryProvider.notifier).add(this);
      ref.read(recognitionProvider.notifier).increment();

      return true;
    } else {
      return false;
    }
  }

  void addToCompleteInventory(WidgetRef ref, [String? ans]) {
    List<Widget> completeWidgetInventory =
        ref.read(completeWidgetInventoryProvider);
    List<Ingredient> completeObjectInventory =
        ref.read(completeObjectInventoryProvider);
    if ((ans == null || ans == password) &&
        !completeObjectInventory.contains(this) &&
        completeObjectInventory.length <= 5) {
      completeWidgetInventory.insert(
          completeObjectInventory.length,
          Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(inventoryImgPath), fit: BoxFit.cover),
            ),
            child: inventoryTile(),
          ));
      completeObjectInventory.add(this);
      completeWidgetInventory.removeAt(4);

      ref
          .read(completeWidgetInventoryProvider.notifier)
          .updateList(completeWidgetInventory);
      ref
          .read(completeObjectInventoryProvider.notifier)
          .updateList(completeObjectInventory);
    }
  }

  Widget inventoryTile() {
    return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 120,
            height: 120,
            child: Image.asset(image, fit: BoxFit.contain),
          ),
          Text(
            name,
            style: const TextStyle(fontWeight: FontWeight.w600),
          )
        ]);
  }
}
