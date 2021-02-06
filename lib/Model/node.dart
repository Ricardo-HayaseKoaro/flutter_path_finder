import 'package:flutter/material.dart';

class Node extends ChangeNotifier {
  bool visited;
  int weight;
  double distance;
  bool isStart;
  bool isFinish;
  bool isWall;
  bool isPath;
  bool isWeight;
  int x;
  int y;
  bool mazeVisited; // used to aux maze generator

  Node(
      {this.visited = false,
      this.isStart = false,
      this.isFinish = false,
      this.distance = double.infinity,
      this.weight = 0,
      this.isWall = false,
      this.isWeight = false,
      this.isPath = false,
      this.mazeVisited = false,
      @required this.x,
      @required this.y});

  setVisited() {
    this.visited = true;
    notifyListeners();
  }

  setFinish(bool finish) {
    this.visited = false;
    this.isFinish = finish;
    this.isStart = false;
    this.isWall = false;
    this.isWeight = false;
    this.weight = 0;
    notifyListeners();
  }

  setStart(bool start) {
    this.visited = false;
    this.isFinish = false;
    this.isStart = start;
    this.isWall = false;
    this.isWeight = false;
    this.weight = 0;
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

  changeWeight(int value) {
    this.isWeight = !this.isWeight;
    if (this.isWeight)
      this.weight = value;
    else
      this.weight = 0;
    notifyListeners();
  }

  // Do not clear walls
  clear() {
    this.mazeVisited = false;
    this.isPath = false;
    this.visited = false;
    this.distance = double.infinity;
    notifyListeners();
  }

  fullClear() {
    this.mazeVisited = false;
    this.isWall = false;
    this.distance = double.infinity;
    this.visited = false;
    this.isPath = false;
    this.isWeight = false;
    this.weight = 0;
    notifyListeners();
  }
}
