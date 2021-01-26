import 'package:flutter/material.dart';

class Node extends ChangeNotifier {
  bool visited;
  int val;
  bool isStart;
  bool isFinish;
  bool isWall;
  bool isPath;
  int x;
  int y;

  Node(
      {this.visited = false,
      this.val = 0,
      this.isStart = false,
      this.isFinish = false,
      this.isWall = false,
      this.isPath = false,
      @required this.x,
      @required this.y});

  setVisited(int value) {
    this.visited = true;
    this.val = value;
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

  setPath() {
    this.isPath = true;
    notifyListeners();
  }

  clear() {
    this.isFinish = false;
    this.isStart = false;
    this.isWall = false;
    this.val = 0;
    this.visited = false;
    this.isPath = false;
    notifyListeners();
  }
}
