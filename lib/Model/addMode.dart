import 'package:flutter/material.dart';

class AddModel extends ChangeNotifier {
  String _addMode;

  AddModel([this._addMode = "wall"]);

  String get addMode => _addMode;

  setModeStart() {
    _addMode = "start";
    notifyListeners();
  }

  setModeFinish() {
    _addMode = "finish";
    notifyListeners();
  }

  setModeWall() {
    _addMode = "wall";
    notifyListeners();
  }
}
