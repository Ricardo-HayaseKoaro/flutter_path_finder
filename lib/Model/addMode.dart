import 'package:flutter/material.dart';
import 'package:path_finder/Enums/addMode.dart';

class AddModel extends ChangeNotifier {
  AddMode _addMode;

  AddModel([this._addMode = AddMode.Wall]);

  AddMode get addMode => _addMode;

  setModeWeight() {
    _addMode = AddMode.Weight;
    notifyListeners();
  }

  setModeWall() {
    _addMode = AddMode.Wall;
    notifyListeners();
  }
}
