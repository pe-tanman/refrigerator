import 'package:flutter_riverpod/flutter_riverpod.dart';
import "package:flutter/material.dart";
import 'package:refrigerator/Utilities/ingredients.dart';

class WidgetInventoryNotifier extends StateNotifier<List<Widget>> {
  WidgetInventoryNotifier() : super([]);

  void updateList(List<Widget> list) {
    state = list;
  }
}

class ObjectInventoryNotifier extends StateNotifier<List<Ingredient>> {
  ObjectInventoryNotifier() : super([]);

  void updateList(List<Ingredient> list) {
    state = list;
  }
}

class ContextNotifier extends StateNotifier<BuildContext?> {
  ContextNotifier(BuildContext? context) : super(context);

  void setContext(BuildContext? context) {
    if (context != null) {
      state = context;
    }
  }
}

final widgetInventoryProvider =
    StateNotifierProvider<WidgetInventoryNotifier, List<Widget>>(
        (ref) => WidgetInventoryNotifier());
final displayInventoryProvider =
    StateNotifierProvider<WidgetInventoryNotifier, List<Widget>>(
        (ref) => WidgetInventoryNotifier());
final completeWidgetInventoryProvider =
    StateNotifierProvider<WidgetInventoryNotifier, List<Widget>>(
        (ref) => WidgetInventoryNotifier());
final completeDisplayInventoryProvider =
    StateNotifierProvider<WidgetInventoryNotifier, List<Widget>>(
        (ref) => WidgetInventoryNotifier());

final objectInventoryProvider =
    StateNotifierProvider<ObjectInventoryNotifier, List<Ingredient>>(
        (ref) => ObjectInventoryNotifier());
final completeObjectInventoryProvider =
    StateNotifierProvider<ObjectInventoryNotifier, List<Ingredient>>(
        (ref) => ObjectInventoryNotifier());

final mainContextProvider =
    StateNotifierProvider<ContextNotifier, BuildContext?>(
        (ref) => ContextNotifier(null));
