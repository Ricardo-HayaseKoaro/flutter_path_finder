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
  bool mazeVisited; // used to aux maze generator

  Node(
      {this.visited = false,
      this.val = 0,
      this.isStart = false,
      this.isFinish = false,
      this.isWall = false,
      this.isPath = false,
      this.mazeVisited = false,
      @required this.x,
      @required this.y});

  setVisitedValue(int value) {
    this.visited = true;
    this.val = value;
    notifyListeners();
  }

  setVisited() {
    this.visited = true;
    notifyListeners();
  }

  setFinish(bool finish) {
    this.visited = false;
    this.isFinish = finish;
    this.isStart = false;
    this.isWall = false;
    notifyListeners();
  }

  setStart(bool start) {
    this.visited = false;
    this.isFinish = false;
    this.isStart = start;
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

  setWall(bool value) {
    this.isWall = value;
    notifyListeners();
  }

  // Do not clear walls
  clear() {
    this.mazeVisited = false;
    this.isPath = false;
    this.visited = false;
    this.val = 0;
    notifyListeners();
  }

  fullClear() {
    this.mazeVisited = false;
    this.isWall = false;
    this.val = 0;
    this.visited = false;
    this.isPath = false;
    notifyListeners();
  }
}
