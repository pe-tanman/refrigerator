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
  String inventoryImgPath = "assets/images/inventory_tile.png";

  bool addToInventory(WidgetRef ref, [String? ans]) {
    ref.read(displayInventoryProvider.notifier).add(Container());
    List<Widget> displayInventory =
        ref.read(displayInventoryProvider.notifier).get();
    print(displayInventory);
    List<Widget> widgetInventory = ref.read(widgetInventoryProvider);
    List<Ingredient> objectInventory = ref.read(objectInventoryProvider);

    if ((ans == null || ans == password) &&
        !objectInventory.contains(this) &&
        objectInventory.length <= 5) {
      String inventoryImgPath = "assets/images/inventory_tile.png";

      displayInventory.insert(
          widgetInventory.length,
          Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(inventoryImgPath), fit: BoxFit.cover)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: inventoryTile(),
            ),
          ));
      widgetInventory.add(inventoryTile());
      objectInventory.add(this);
      displayInventory.removeAt(4);

      ref.read(widgetInventoryProvider.notifier).updateList(widgetInventory);
      ref.read(objectInventoryProvider.notifier).updateList(objectInventory);
      ref.read(displayInventoryProvider.notifier).updateList(displayInventory);

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
      completeWidgetInventory.add(Container(
        width: 180,
        height: 180,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(inventoryImgPath), fit: BoxFit.cover),
        ),
        child: inventoryTile(),
      ));
      completeObjectInventory.add(this);
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
