import 'package:flutter/material.dart';

class AddModel extends ChangeNotifier {
  String _addMode;

  AddModel([this._addMode = "wall"]);

  String get addMode => _addMode;

  setModeWeight() {
    _addMode = "weight";
    notifyListeners();
  }

  setModeWall() {
    _addMode = "wall";
    notifyListeners();
  }
}
