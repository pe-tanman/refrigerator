import 'package:refrigerator/utilities/ingredients.dart';
import 'package:flutter/material.dart';

class RGB {
  RGB(this.r, this.g, this.b) {
    sum = r + g + b;
    id = r + 2 * g + 4 * b;
    switch (id) {
      case 0: //k(0,0,0)
        color = Colors.black;
        liquid = Ingredient(
            name: "黒の魔剤",
            image: "assets/images/items/black_liquid.png",
            password: "black-7196",
            rgb: this);
        break;
      case 1: //R(1,0,0)
        color = Colors.red;
        liquid = Ingredient(
            name: "赤の魔剤",
            image: "assets/images/items/red_liquid.png",
            password: "red-5290",
            rgb: this);
        break;
      case 2: //G(0,1,0)
        color = Colors.green;
        liquid = Ingredient(
            name: "緑の魔剤",
            image: "assets/images/items/green_liquid.png",
            password: "green-7129",
            rgb: this);
        break;
      case 4: //b(0,0,1)
        color = Colors.blue;
        liquid = Ingredient(
            name: "青の魔剤",
            image: "assets/images/items/blue_liquid.png",
            password: "blue-0975",
            rgb: this);
        break;
      case 3: //Y(1,1.0)
        color = Colors.yellow;
        liquid = Ingredient(
            name: "黄色の魔剤",
            image: "assets/images/items/yellow_liquid.png",
            password: "yellow-7127",
            rgb: this);
        break;
      case 5: //M(1,0,1)
        color = Colors.pink;
        liquid = Ingredient(
            name: "マゼンタの魔剤",
            image: "assets/images/items/magenta_liquid.png",
            password: "magenta-1237",
            rgb: this);
        break;
      case 6: //C(0,1,1)
        color = Colors.cyan;
        liquid = Ingredient(
            name: "シアンの魔剤",
            image: "assets/images/items/cyan_liquid.png",
            password: "cyan-1267",
            rgb: this);
        break;
      case 7: //w(1,1,1)
        color = Colors.white;
        liquid = Ingredient(
            name: "白の魔剤",
            image: "assets/images/items/white_liquid.png",
            password: "white-1923",
            rgb: this);
        break;
    }
  }
  int r;
  int g;
  int b;
  late Color color;
  late Ingredient liquid;
  late int id;
  late int sum;

  RGB mixLight(RGB otherLiquid) {
    RGB result = RGB(r + otherLiquid.r, g + otherLiquid.g, b + otherLiquid.b);
    return result;
  }

  List<Ingredient> separateLight() {
    List<Ingredient> result = [];
    if (r == 1) {
      result.add(RGB(1, 0, 0).liquid);
    }
    if (g == 1) {
      result.add(RGB(0, 1, 0).liquid);
    }
    if (b == 1) {
      result.add(RGB(0, 0, 1).liquid);
    }
    return result;
  }

  Ingredient mixColor(other) {
    late RGB rgb;
    if ((r + other.r) * (g + other.g) * (b + other.b) != 0 &&
        (sum + other.sum == 3 || sum + other.sum == 4)) {
      rgb = mixLight(other);
      rgb = RGB(rgb.r - 1, rgb.g - 1, rgb.b - 1);
    }
    return rgb.liquid;
  }

  List<Ingredient> separateColor() {
    List<Ingredient> result = [];
    if (r == 0) {
      result.add(RGB(0, 1, 1).liquid);
    }
    if (g == 0) {
      result.add(RGB(1, 0, 1).liquid);
    }
    if (b == 0) {
      result.add(RGB(1, 1, 0).liquid);
    }
    return result;
  }
}
