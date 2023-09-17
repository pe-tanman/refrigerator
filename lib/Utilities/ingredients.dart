import 'package:flutter/material.dart';
import "package:refrigerator/Utilities/RGB.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';
import "package:refrigerator/provider/tool_provider.dart";

class Ingredient {
  Ingredient(
      {required this.name,
      required this.image,
      required this.password,
      this.rgb});

  String name;
  String image;
  String password;
  RGB? rgb;
  final container = ProviderContainer();

  bool addToInventory(List<Widget> displayInventory,
      List<Widget> widgetInventory, List<Ingredient> objectInventory,
      [String? ans]) {
    if ((ans == null || ans == password) &&
        !objectInventory.contains(this) &&
        objectInventory.length <= 5) {
      String inventoryImgPath = "assets/Image/inventory_tile.png";

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

      return true;
    } else {
      return false;
    }
  }

  void addToCompleteInventory(
      List<Widget> widgetInventory, List<Ingredient> objectInventory,
      [String? ans]) {
    if ((ans == null || ans == password) &&
        !objectInventory.contains(this) &&
        objectInventory.length <= 5) {
      widgetInventory.add(inventoryTile());
      objectInventory.add(this);
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
