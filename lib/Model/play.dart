import 'package:flutter/material.dart';

class Play extends ChangeNotifier {
  bool _isPlaying;

  Play([this._isPlaying = false]);

  bool get isPlaying => _isPlaying;

  changeState() {
    _isPlaying = !_isPlaying;
    notifyListeners();
  }
}
