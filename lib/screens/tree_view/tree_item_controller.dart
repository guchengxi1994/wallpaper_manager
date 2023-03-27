import 'package:flutter/material.dart';

class TreeItemController extends ChangeNotifier {
  late int selectedItemId = -1;

  init({int initialId = 0}) {
    changeSelectedItemId(initialId);
  }

  changeSelectedItemId(int i) {
    if (i != selectedItemId) {
      selectedItemId = i;
      notifyListeners();
    }
  }
}
