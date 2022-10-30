import 'package:flutter/foundation.dart';

class AppState {
  static final AppState _instance = AppState._internal();

  factory AppState() {
    return _instance;
  }

  AppState._internal();

  ValueNotifier<List<int>> bags = ValueNotifier<List<int>>(<int>[]);
  addItemBag(int item) {
    bags.value = List.from(bags.value)..add(item);
  }

  //removeItemBag by index
  removeItemBag(int item) {
    bags.value = List.from(bags.value)..remove(item);
  }

  clearItemsBag() {
    bags.value = <int>[];
  }

  ValueNotifier<int> pageIndex = ValueNotifier<int>(1);
}
