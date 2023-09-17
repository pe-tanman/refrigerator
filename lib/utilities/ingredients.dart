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
  final container = ProviderContainer();
  String inventoryImgPath = "assets/images/inventory_tile.png";

  bool addToInventory([String? ans]) {
    List<Widget> widgetInventory = container.read(widgetInventoryProvider);
    List<Widget> displayInventory = container.read(displayInventoryProvider);
    List<Ingredient> objectInventory = container.read(objectInventoryProvider);

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

      container
          .read(widgetInventoryProvider.notifier)
          .updateList(widgetInventory);
      container
          .read(objectInventoryProvider.notifier)
          .updateList(objectInventory);
      container
          .read(displayInventoryProvider.notifier)
          .updateList(displayInventory);
      return true;
    } else {
      return false;
    }
  }

  void addToCompleteInventory([String? ans]) {
    List<Widget> completeWidgetInventory =
        container.read(completeWidgetInventoryProvider);
    List<Ingredient> completeObjectInventory =
        container.read(completeObjectInventoryProvider);
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
      container
          .read(completeWidgetInventoryProvider.notifier)
          .updateList(completeWidgetInventory);
      container
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
