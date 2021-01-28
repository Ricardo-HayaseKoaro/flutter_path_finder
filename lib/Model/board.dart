import 'package:flutter/material.dart';
import 'package:path_finder/Model/node.dart';
import 'package:path_finder/Services/bfs.dart';

class Board extends ChangeNotifier {
  // Grid size
  int rowCount;
  int columnCount;

  //Status (finished finding path)
  bool isFinished;

  // The board of squares
  List<List<Node>> grid;

  //List of visited (Used with visited property of node, the property is used to makes easier to check when rendering)
  List<Node> visitedNodes;

  // Walls in the grid
  List<Node> walls;

  // Start and finish squates
  Node start;
  Node finish;

  // Algorythms for path finding
  BFS bfs;

  Board() {
    this.rowCount = 20;
    this.columnCount = 30;
    this.isFinished = false;
    this.grid = List<List<Node>>();
    this.visitedNodes = List<Node>();
    this.walls = List<Node>();
  }

  void initialiseBoard() {
    grid = List.generate(rowCount, (i) {
      return List.generate(columnCount, (j) {
        if (i == (rowCount / 2) - 4 && j == (columnCount / 2)) {
          Node newNode = Node(x: i, y: j, isStart: true);
          start = newNode;
          return newNode;
        }
        if (i == (rowCount / 2) + 3 && j == (columnCount / 2)) {
          Node newNode = Node(x: i, y: j, isFinish: true);
          finish = newNode;
          return newNode;
        }
        return Node(x: i, y: j);
      });
    });
    walls = List();
    visitedNodes = List();
  }

  // Used to pass to each square in grid when changing the location of finish and start
  setStart(Node node) {
    this.start = node;
  }

  setFinish(Node node) {
    this.finish = node;
  }

  void clearVisitedNodes() {
    for (var node in visitedNodes) {
      if (!node.isStart && !node.isFinish) node.clear();
    }
  }

  void clearBoard() {
    for (var node in walls) {
      node.fullClear();
    }
    for (var node in visitedNodes) {
      node.fullClear();
    }
  }

  startPathFinding() {
    this.isFinished = false;
    this.clearVisitedNodes();
    bfs = BFS(this);
    bfs.startBFS();
    this.isFinished = true;
    notifyListeners();
  }
}
