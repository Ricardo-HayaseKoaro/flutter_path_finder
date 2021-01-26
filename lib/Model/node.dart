import 'package:flutter/material.dart';

class Node extends ChangeNotifier {
  bool visited;
  int val;
  bool isStart;
  bool isFinish;
  bool isWall;

  Node(
      {this.visited = false,
      this.val = 0,
      this.isStart = false,
      this.isFinish = false,
      this.isWall = false});

  setVisited() {
    this.visited = true;
    notifyListeners();
  }

  setFinish() {
    this.isFinish = true;
    this.isStart = false;
    this.isWall = false;
    notifyListeners();
  }

  setStart() {
    this.isFinish = false;
    this.isStart = true;
    this.isWall = false;
    notifyListeners();
  }

  changeWall() {
    this.isFinish = false;
    this.isStart = false;
    this.isWall = !this.isWall;
    notifyListeners();
  }

  clear() {
    this.isFinish = false;
    this.isStart = false;
    this.isWall = false;
    notifyListeners();
  }
}
