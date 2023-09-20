import 'dart:core';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import "package:flutter/material.dart";
import 'package:refrigerator/utilities/ingredients.dart';

class WidgetInventoryNotifier extends StateNotifier<List<Widget>> {
  WidgetInventoryNotifier() : super([]);

  void insert(int index, Widget widget) {
    List<Widget> tmpList = state;
    tmpList.insert(index, widget);
    state = [...tmpList];
  }

  void add(Widget widget) {
    List<Widget> tmpList = state;
    tmpList.add(widget);
    state = tmpList;
  }

  void removeAt(int index) {
    List<Widget> tmpList = state;
    tmpList.removeAt(index);
    state = tmpList;
  }

  void remove(Widget widget) {
    state = state.where((e) => e != widget).toList();
  }

  void insertAndRemoveInventoryTile(int index, Widget widget) {
    List<Widget> tmpList = state;
    tmpList.insert(index, widget);
    tmpList.removeAt(4);
    state = tmpList;
  }

  void removeAndInsertInventoryTile(int index) {
    List<Widget> tmpList = state;
    tmpList.removeAt(index);
    tmpList.insert(
        3,
        Container(
          width: 180,
          height: 180,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("images/background/inventory_tile.png"),
                  fit: BoxFit.cover)),
        ));

    state = tmpList;
  }

  void replace(int index, Widget widget) {
    List<Widget> tmpList = state;
    tmpList.removeAt(index);
    tmpList.insert(index, widget);
    state = tmpList;
  }

  void clear() {
    List<Widget> tmpList = state;
    tmpList.clear();
    state = tmpList;
  }

  void updateList(List<Widget> list) {
    state = list;
  }

  List<Widget> get() {
    return state;
  }
}

class ObjectInventoryNotifier extends StateNotifier<List<Ingredient>> {
  ObjectInventoryNotifier() : super([]);

  void insert(int index, Ingredient ingredient) {
    List<Ingredient> tmpList = state;
    tmpList.insert(index, ingredient);
    state = tmpList;
  }

  void add(Ingredient ingredient) {
    List<Ingredient> tmpList = state;
    tmpList.add(ingredient);
    state = tmpList;
  }

  void removeAt(int index) {
    List<Ingredient> tmpList = state;
    tmpList.removeAt(index);
    state = tmpList;
  }

  void replace(int index, Ingredient ingredient) {
    List<Ingredient> tmpList = state;
    tmpList[index] = ingredient;
    state = tmpList;
  }

  void clear() {
    List<Ingredient> tmpList = state;
    tmpList.clear();
    state = tmpList;
  }

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

class RoomNotifier extends StateNotifier<int> {
  RoomNotifier() : super(1);
  void setRoom(int room) {
    state = room;
  }

  void increment() {
    state++;
  }
}

class RecognitionNotifier extends StateNotifier<int> {
  RecognitionNotifier() : super(0);
  void increment() {
    state++;
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
final roomProvider =
    StateNotifierProvider<RoomNotifier, int>((ref) => RoomNotifier());
final recognitionProvider = StateNotifierProvider<RecognitionNotifier, int>(
    (ref) => RecognitionNotifier());
